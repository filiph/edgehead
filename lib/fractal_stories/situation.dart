library stranded.situation;

import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:meta/meta.dart';

import 'action.dart';
import 'actor.dart';
import 'simulation.dart';
import 'storyline/storyline.dart';

/// Situation is a phase during play. It governs which actions are available,
/// and what actors can act (and in what order).
///
/// Situations are stacked on a push-down automaton. [Action]s can push new
/// situations on the stack, which are then processed until completion. Actions
/// can also replace the top-most situation with another one, or remove
/// the top-most situation.
///
/// To implement a Situation:
///
/// * Subclass [Situation]. For sake of clarity, we'll call the subclass
///   `MySituation` here.
/// * Put the new class in a separate Dart file.
/// * Make sure that the new class `MySituation` implements
///   `BuiltValue<MySituation, MySituationBuilder>` as required by built_value.
/// * Create the `MySituationBuilder` class.
/// * Add the new Dart file into `tool/phases.dart`.
/// * Run `tool/build.dart` if it doesn't run automatically.
/// * Follow instruction in the newly generated `*.g.dart` file.
/// * Make sure your `MySituationBuilder` includes the [id] field and that
///   it reads like this:
///         @virtual
///         int id = getRandomId();
@immutable
abstract class Situation {
  /// Default value for [maxActionsToShow].
  static const int defaultMaxActionsToShow = 3;

  /// The actions available to the actors.
  List<Action<dynamic>> get actions;

  /// Identifies the situation even after it has changed (for example, the time
  /// has been increased, or an actor has changed).
  int get id;

  /// How many actions the player will be shown when inside this situation.
  ///
  /// Defaults to [defaultMaxActionsToShow]. For situations like combat, this
  /// can be much higher.
  int get maxActionsToShow;

  /// Identifies the type of the Situation (i.e. 'FightSituation' for
  /// [FightSituation].
  ///
  /// This is so that we can do things like [Simulation.popSituationsUntil].
  String get name;

  /// This is increased every 'turn'. It starts at `0` when the situation is
  /// first created.
  int get time;

  /// Returns updated state with `time++`.
  Situation elapseTime();

  /// Returns the actor whose turn it is at specified [time].
  ///
  /// Returns `null` when no actor can act anymore (for example, all
  /// actors are dead, or all have acted).
  Actor getActorAtTime(int time, Simulation sim, WorldState world);

  /// Filters the [actors] that are active in this situation.
  Iterable<Actor> getActors(
      Iterable<Actor> actors, Simulation sim, WorldState world);

  /// Returns the actor whose time it is at the current [time].
  Actor getCurrentActor(Simulation sim, WorldState world);

  /// Called after action is executed inside this situation.
  ///
  /// This method is called immediately after executing the action, even when
  /// the action adds more situations to the top of the stack. It _won't_ run
  /// if the situation is popped from the stack by the action.
  ///
  /// For example, a room roaming situation can remove dead actors from play
  /// after you've left the area.
  void onAfterAction(
      Simulation sim, WorldStateBuilder world, Storyline outputStoryline);

  /// Called after action is executed inside this situation, including any
  /// subsequent actions that happen in situations above in the stack.
  ///
  /// For example, if the action adds new situations at the top of the stack,
  /// those situations will first get resolved (and popped) and only then will
  /// [onAfterTurn] get called.
  void onAfterTurn(
      Simulation sim, WorldStateBuilder world, Storyline outputStoryline);

  /// Called just before executing an action.
  ///
  /// This should NOT modify the world. This is only for adding to the
  /// [outputStoryline].
  void onBeforeAction(
      Simulation sim, WorldState world, Storyline outputStoryline);

  /// Called when this situation is about to be popped from the
  /// [Simulation.situations] stack, either manually (by using
  /// [Simulation.popSituation]) or automatically (when [shouldContinue] is
  /// no longer true or [getCurrentActor] returns `null`).
  void onPop(Simulation sim, WorldStateBuilder world);

  /// Return `false` when this [Situation] should no longer continue.
  ///
  /// This is called at the end of a turn (after [onAfterAction] finished) and
  /// will remove this action from the [Simulation.situations] stack when
  /// the situation is finished.
  ///
  /// Note that this is not the only way for situations to end. They can
  /// be popped manually from the stack.
  bool shouldContinue(Simulation sim, WorldState world);

  // TODO: toMap (save [time] as well as currentActor (because we want to make
  //       sure that we load with the same actor although some actors may have
  //       been removed from play))
}

/// Provides some sane defaults to [Situation] subclasses.
///
/// This is meant to be used as a mixin.
abstract class SituationBaseBehavior implements Situation {
  @override
  List<Action<dynamic>> get actions => const [];

  @override
  int get maxActionsToShow => Situation.defaultMaxActionsToShow;

  @override
  Actor getCurrentActor(Simulation sim, WorldState world) =>
      getActorAtTime(time, sim, world);

  @override
  void onAfterAction(
      Simulation sim, WorldStateBuilder world, Storyline outputStoryline) {
    // No-op by default.
  }

  @override
  void onAfterTurn(
      Simulation sim, WorldStateBuilder world, Storyline outputStoryline) {
    // No-op by default.
  }

  @override
  void onBeforeAction(
      Simulation sim, WorldState world, Storyline outputStoryline) {
    // No-op by default.
  }

  @override
  void onPop(Simulation sim, WorldStateBuilder world) {
    // No-op by default.
  }

  @override
  bool shouldContinue(Simulation sim, WorldState world) => true;
}
