library stranded.planner;

import 'dart:async';
import 'dart:collection';

import 'action.dart';
import 'actor.dart';
import 'package:edgehead/ecs/pubsub.dart';
import 'package:edgehead/fractal_stories/actor_score.dart';
import 'package:edgehead/fractal_stories/context.dart';
import 'package:edgehead/fractal_stories/planner_recommendation.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:logging/logging.dart';
import 'plan_consequence.dart';
import 'simulation.dart';

class ActorPlanner {
  final Logger log = new Logger('ActorPlanner');

  /// We will stop processing a plan path once its leaf node has lower
  /// cumulative probability than this.
  static const num minimumCumulativeProbability = 0.05;

  /// Only consequences with cumulative probability over this threshold
  /// will be considered for best cases.
  static const num bestCaseProbabilityThreshold = 0.15;

  static DateTime _latestWait = new DateTime.now();
  final int actorId;

  final PlanConsequence _initial;
  int planConsequencesComputed = 0;

  bool _resultsReady = false;

  PubSub _pubsub;

  final Simulation simulation;

  final Map<Performance, ActorScoreChange> firstActionScores = new Map();

  ActorPlanner(
      Actor actor, this.simulation, WorldState initialWorld, this._pubsub)
      : actorId = actor?.id,
        _initial = new PlanConsequence.initial(initialWorld) {
    if (actor == null) {
      throw new ArgumentError("Called ActorPlanner with actor == null. "
          "That may mean that a Situation returns getCurrentActor as null. "
          "Some action that you added should make sure it removes the "
          "Situation "
          "(maybe ${initialWorld.actionHistory.getLatest().description}?). "
          "World: $initialWorld. "
          "Situation: ${initialWorld.currentSituation}. "
          "Action Records: "
          "${initialWorld.actionHistory.describe()}");
    }
    assert(actor.isAlive);
  }

  /// Computes the combined score for a bunch of consequences.
  ///
  /// TODO: allow to personalize this (for example, optimistic characters
  /// only take `isSuccess == true` consequences into account).
  ActorScoreChange combineScores(
      Iterable<ConsequenceStats> stats, ActorScore initialScore, int maxOrder) {
    log.finest("...");
    log.finest("combining scores");

    var uplifts = <ActorScoreChange>[];

    ConsequenceStats _bestCase;

    num combineForBestCase(ActorScore score) =>
        score.teamPreservation - score.enemy;

    for (var consequence in stats) {
      log.finest(() => "  - consequence: $consequence");
      if (consequence.cumulativeProbability > bestCaseProbabilityThreshold) {
        if (_bestCase == null) {
          log.finest("    - first _bestCase");
          _bestCase = consequence;
        } else if (combineForBestCase(consequence.score) >
            combineForBestCase(_bestCase.score)) {
          _bestCase = consequence;
          log.finest("    - new _bestCase");
        }
      }

      ActorScoreChange uplift = (consequence.score - initialScore) *
          consequence.cumulativeProbability;
      log.finest(() => "    - uplift = $uplift");
      uplifts.add(uplift);
    }

    // Look at average to see what kind of effect, on average, this action
    // will have.
    var average = new ActorScoreChange.average(uplifts);

    // Also look at the best possible outcome. If we only used the average,
    // an action that leads to a lot of bad outcomes but one great one
    // (presumably the one the actor has in mind) would receive a bad score.
    var bestUpside = _bestCase == null
        ? const ActorScoreChange.zero()
        : (_bestCase.score - initialScore);
    ActorScoreChange best = bestUpside / (_bestCase?.order ?? 1);

    log.finest("- uplifts average = $average");
    log.finest("- best = $best");

    var result = best + average;

    log.finest("- result = $result");
    return result;
  }

  Iterable<String> generateTable() sync* {
    int i = 1;
    for (var key in firstActionScores.keys) {
      yield "$i) ${key.command}\t${firstActionScores[key]}";
      i += 1;
    }
  }

  PlannerRecommendation getRecommendations() {
    assert(_resultsReady);
    if (firstActionScores.isEmpty) {
      log.warning("There are no actions available for "
          "actorId=$actorId.");
      log.fine("Actions not available for $actorId and $_initial.");
    }
    return new PlannerRecommendation(firstActionScores);
  }

  Future<Null> plan(
      {int maxOrder: 10,
      int maxConsequences: 50,
      Future<Null> waitFunction()}) async {
    firstActionScores.clear();

    var currentActor =
        _initial.world.actors.singleWhere((a) => a.id == actorId);
    var initialScore = currentActor.scoreWorld(_initial.world);

    log.fine("Planning for ${currentActor.name}, initialScore=$initialScore");

    final context =
        new ApplicabilityContext(currentActor, simulation, _initial.world);

    for (var performance in simulation.generateAllPerformances(context)) {
      log.finer(() => "Evaluating action '${performance.command}' "
          "for ${currentActor.name}");

      if (!performance.action.isApplicable(
          currentActor, simulation, _initial.world, performance.object)) {
        log.finer(() => "- action '${performance.command}' isn't applicable");
        // Bail early if action isn't possible at all.
        continue;
      }
      var consequenceStats = await _getConsequenceStats(
              _initial, performance, maxOrder, maxConsequences, waitFunction)
          .toList();

      if (consequenceStats.isEmpty) {
        log.finer(() => "- action '${performance.command}' is possible but we "
            "couldn't get to any outcomes while planning. "
            "Scoring with negative infinity.");
        // For example, at the very end of a book, it is possible to have
        // 'no future'.
        firstActionScores[performance] = const ActorScoreChange.undefined();
        continue;
      }

      log.finer(() => "- action '${performance.command}' leads "
          "to ${consequenceStats.length} "
          "different ConsequenceStats, initialScore=$initialScore");
      var score = combineScores(consequenceStats, initialScore, maxOrder);

      firstActionScores[performance] = score;

      log.finer(() => "- action '${performance.command}' was scored $score");
    }

    _resultsReady = true;
  }

  /// Returns the stats for consequences of a given [initial] state after
  /// applying [firstPerformance] and then up to [maxOrder] other steps.
  ///
  /// [firstPerformance] is the action which we evaluate. All following
  /// actions are consequences -- actions taken by the different actors
  /// after the main actor ([actorId]) chooses this path.
  Stream<ConsequenceStats> _getConsequenceStats(
      PlanConsequence initial,
      Performance<dynamic> firstPerformance,
      int maxOrder,
      int maxConsequences,
      Future<Null> waitFunction()) async* {
    // Actor object changes during planning, so we need to look up via id.
    var mainActor = initial.world.actors.singleWhere((a) => a.id == actorId);

    log.finer("=====");
    log.finer(() => "_getConsequenceStats for firstAction "
        "'${firstPerformance.command}' of ${mainActor.name}");
    log.finer(() => "- firstAction == $firstPerformance");

    if (!firstPerformance.action.isApplicable(
        mainActor, simulation, initial.world, firstPerformance.object)) {
      log.finer("- firstAction not applicable");
      return;
    }

    ActorScore initialScore = mainActor.scoreWorld(initial.world);

    log.finer(() => "- current: initialScore=$initialScore, "
        "cumProb=${initial.cumulativeProbability} "
        "(prob=${initial.probability}, "
        "ord=${initial.order})");
    log.finer(() => "- initial action: "
        "${' ' * initial.order}- ${initial.performance}");

    Queue<PlanConsequence> open = new Queue<PlanConsequence>();
    final Set<WorldState> closed = new Set<WorldState>();

    var initialWorldHash = initial.world.hashCode;
    for (var firstConsequence in firstPerformance.action.apply(mainActor,
        initial, simulation, initial.world, _pubsub, firstPerformance.object)) {
      if (initial.world.hashCode != initialWorldHash) {
        throw new StateError(
            "Action $firstPerformance modified world state when "
            "producing $firstConsequence.");
      }
      open.add(firstConsequence);
    }

    int consequences = 0;

    while (open.isNotEmpty) {
      consequences += 1;

      if (waitFunction != null &&
          new DateTime.now().difference(_latestWait) >
              const Duration(milliseconds: 5)) {
        await waitFunction();
        _latestWait = new DateTime.now();
      }
      var current = open.removeFirst();

      log.finest("----");
      log.finest(() => "evaluating a PlanConsequence "
          "of '${current.performance.command}'");
      log.finest(() => "- situation: "
          "${current.world.currentSituation.runtimeType}");

      if (current.order > maxOrder || consequences > maxConsequences) {
        log.finest(() => "- order (${current.order}) higher than "
            "maximum ($maxOrder), "
            "or consequences ($consequences) higher than maximum");
        log.finest(() {
          String path = current.world.actionHistory.describe();
          return "- how we got here: $path";
        });

        // We can break because we go from lowest order to highest (because
        // new consequences are added to the end of the [open] queue).
        break;
      }

      if (current.world.situations.isEmpty) {
        log.finest("- leaf node: world.situations is empty (end of book)");

        var mainActor = current.world.actors
            .firstWhere((a) => a.id == actorId, orElse: () => null);

        if (mainActor == null) {
          log.finest("- this actor ($actorId) has been removed");
          continue;
        }

        var score = mainActor.scoreWorld(current.world);

        var stats = new ConsequenceStats(
            score, current.cumulativeProbability, current.order);

        log.finest(() => "- $stats");

        yield stats;
        continue;
      }

      var currentActor = current.world.currentSituation
          .getCurrentActor(simulation, current.world);
      assert(
          currentActor != null,
          "Situation ${current.world.currentSituation} "
          "returned null for getCurrentActor for world ${current.world}");

      // This actor is the one we originally started planning for.
      Actor mainActor;
      var mainActorDuplicates =
          current.world.actors.where((a) => a.id == actorId).length;
      if (mainActorDuplicates > 1) {
        throw new StateError("World has several duplicates of mainActor: "
            "${current.world}");
      } else if (mainActorDuplicates == 0) {
        log.info("mainActor $actorId dies and is removed in world - "
            "will use defaultScoreWhenDead");
      } else {
        mainActor = current.world.actors.singleWhere((a) => a.id == actorId);
      }
      bool currentActorIsMain = currentActor == mainActor;

      log.finest("- actor: ${currentActor.name} (isMain==$currentActorIsMain)");
      log.finest("- mainActor: ${mainActor?.name}");

      var score =
          mainActor?.scoreWorld(current.world) ?? Actor.defaultScoreWhenDead;
      var stats = new ConsequenceStats(
          score, current.cumulativeProbability, current.order);

      log.finest(() => "- mainActor's score == $stats (initial=$initialScore)");
      log.finest(() {
        String path = current.world.actionHistory.describe();
        return "- how we got here: $path";
      });

      yield stats;

      log.finest("- generating all actions for ${currentActor.name}");
      var originalCount = open.length;

      final context =
          new ApplicabilityContext(currentActor, simulation, current.world);

      for (final performance in simulation.generateAllPerformances(context)) {
        if (!performance.action.isApplicable(
            currentActor, simulation, current.world, performance.object)) {
          continue;
        }
        var consequences = performance.action.apply(currentActor, current,
            simulation, current.world, _pubsub, performance.object);

        for (PlanConsequence next in consequences) {
          planConsequencesComputed++;

          // Ignore consequences that have a tiny probability of happening.
          var cumulativeProbability = next.cumulativeProbability;
          if (cumulativeProbability < minimumCumulativeProbability) {
            continue;
          }

          // Normally, we would check whether the consequence world doesn't
          // already exist (in closed). But that is almost impossible
          // (remember: WorldState includes the action history),
          // and the computation required to check involves computing
          // hashCode for the whole WorldState, which is expensive
          // (6.4% CPU time of a long-running test).
          open.add(next);
        }
      }

      log.finest("- added ${open.length - originalCount} new PlanConsequences");

      closed.add(current.world);
    }
  }
}
