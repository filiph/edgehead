library stranded.fight.fight_situation;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/anatomy/body_part.dart';
import 'package:edgehead/fractal_stories/anatomy/deal_slashing_damage.dart';
import 'package:edgehead/fractal_stories/item.dart';
import 'package:edgehead/fractal_stories/pose.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/situation.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/util/alternate_iterables.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/src/fight/actions/confuse.dart';
import 'package:edgehead/src/fight/actions/disarm_kick.dart';
import 'package:edgehead/src/fight/actions/kick_to_ground.dart';
import 'package:edgehead/src/fight/actions/pound.dart';
import 'package:edgehead/src/fight/actions/regain_balance.dart';
import 'package:edgehead/src/fight/actions/scramble.dart';
import 'package:edgehead/src/fight/actions/stand_up.dart';
import 'package:edgehead/src/fight/actions/start_break_neck_on_ground.dart';
import 'package:edgehead/src/fight/actions/start_leap.dart';
import 'package:edgehead/src/fight/actions/start_punch.dart';
import 'package:edgehead/src/fight/actions/start_slash_at_body_part.dart';
import 'package:edgehead/src/fight/actions/start_slash_from_direction.dart';
import 'package:edgehead/src/fight/actions/start_strike_down.dart';
import 'package:edgehead/src/fight/actions/start_thrust.dart';
import 'package:edgehead/src/fight/actions/start_thrust_spear_down.dart';
import 'package:edgehead/src/fight/actions/take_dropped_shield.dart';
import 'package:edgehead/src/fight/actions/take_dropped_weapon.dart';
import 'package:edgehead/src/fight/actions/throw_spear.dart';
import 'package:edgehead/src/fight/actions/unconfuse.dart';
import 'package:edgehead/src/fight/loot/loot_situation.dart';
import 'package:edgehead/src/room_roaming/room_roaming_situation.dart';

part 'fight_situation.g.dart';

String getGroundMaterial(WorldStateBuilder w) {
  var fight = w.getSituationByName<FightSituation>(FightSituation.className);
  var groundMaterial = fight.groundMaterial;
  return groundMaterial;
}

abstract class FightSituation extends Situation
    implements Built<FightSituation, FightSituationBuilder> {
  /// The advantage that player has over all other actors in terms of frequency
  /// of turns.
  static const double _playerTurnAdvantage = 1.5;

  static const String className = "FightSituation";

  static Serializer<FightSituation> get serializer =>
      _$fightSituationSerializer;

  factory FightSituation([void updates(FightSituationBuilder b)]) =
      _$FightSituation;

  factory FightSituation.initialized(
          int id,
          Iterable<Actor> playerTeam,
          Iterable<Actor> enemyTeam,
          String groundMaterial,
          RoomRoamingSituation roomRoamingSituation,
          Map<int, EventCallback> events,
          {Iterable<Item> items: const []}) =>
      new FightSituation((b) => b
        ..id = id
        ..time = 0
        ..playerTeamIds.replace(playerTeam.map<int>((a) => a.id))
        ..enemyTeamIds.replace(enemyTeam.map<int>((a) => a.id))
        ..groundMaterial = groundMaterial
        ..droppedItems = new ListBuilder<Item>(items)
        ..roomRoamingSituationId = roomRoamingSituation.id
        ..events = new MapBuilder<int, EventCallback>(events));
  FightSituation._();

// TODO
// @override
//  @deprecated
//  List<ActionBuilder> get actionGenerators => [
////        Confuse.builder,
////        DisarmKick.builder,
//        KickToGround.builder,
//        Pound.builder,
//        startBreakNeckOnGroundBuilder,
//        startLeapBuilder,
//        startPunchBuilder,
//        startSlashAtBodyPartGenerator(BodyPartDesignation.primaryArm),
//        startSlashAtBodyPartGenerator(BodyPartDesignation.secondaryArm),
//        startSlashAtBodyPartGenerator(BodyPartDesignation.neck),
//        startSlashAtBodyPartGenerator(BodyPartDesignation.leftLeg),
//        startSlashAtBodyPartGenerator(BodyPartDesignation.rightLeg),
//        startSlashFromDirectionGenerator(SlashDirection.left),
//        startSlashFromDirectionGenerator(SlashDirection.right),
//        startStrikeDownBuilder,
//        startThrustAtBodyPartGenerator(BodyPartDesignation.leftEye),
//        startThrustAtBodyPartGenerator(BodyPartDesignation.rightEye),
//        startThrustAtBodyPartGenerator(BodyPartDesignation.torso),
//        startThrustAtBodyPartGenerator(BodyPartDesignation.head),
//        startThrustSpearDownBuilder,
//        TakeDroppedShield.builder,
//        TakeDroppedWeapon.builder,
//        ThrowSpear.builder,
//      ];

  @override
  List<Action<dynamic>> get actions => <Action<dynamic>>[
        Confuse.singleton,
        DisarmKick.singleton,
        // simple ones
        RegainBalance.singleton,
        StandUp.singleton,
        Scramble.singleton,
        Unconfuse.singleton
      ];

  /// The items dropped by dead combatants. The Map's `value` is a qualified
  /// name, such as "goblin's scimitar". The `key` is the actual item.
  BuiltList<Item> get droppedItems;

  BuiltList<int> get enemyTeamIds;

  BuiltMap<int, EventCallback> get events;

  /// The material on the ground. It can be 'wooden floor' or 'grass'.
  ///
  /// This is used when describing how monsters and team members fall to the
  /// ground and how missiles get stuck in it.
  String get groundMaterial;

  @override
  int get id;

  @override
  int get maxActionsToShow => 1000;

  @override
  String get name => className;

  BuiltList<int> get playerTeamIds;

  /// This is used to update the underlying [RoomRoamingSituation] with the
  /// fact that all monsters have been slain.
  int get roomRoamingSituationId;

  @override
  int get time;

  /// Returns `true` if any actor among `teamIds` can still fight
  /// (and is active).
  bool canFight(
          Simulation sim, WorldStateBuilder world, Iterable<int> teamIds) =>
      teamIds.any((id) => world.getActorById(id).isAliveAndActive);

  @override
  FightSituation elapseTime() => rebuild((b) => b..time += 1);

  @override
  Actor getActorAtTime(int time, Simulation sim, WorldState world) {
    var allActorIds = alternate<int>(playerTeamIds, enemyTeamIds);
    var actors = allActorIds
        .map((id) => world.getActorById(id))
        .where((a) => a.isAliveAndActive)
        .toList(growable: false);
    var players = actors.where((a) => a.isPlayer).toList(growable: false);
    assert(players.length <= 1);
    Actor player = players.length == 1 ? players.single : null;

    if (time == 0) {
      // Always start with the player if possible.
      if (player != null) {
        return player;
      }
    }

    num best = 0.0;
    Actor chosen;

    for (var actor in actors) {
      // Compute the last time this actor did any pro-active action.
      var latestProactiveRecord =
          world.actionHistory.getLatestProactiveTime(actor);
      final pastInfinity = new DateTime.utc(-10000);
      DateTime latestProactiveTime = latestProactiveRecord ?? pastInfinity;
      int proactiveRecency =
          world.time.difference(latestProactiveTime).inSeconds;
      // If actor did something just now, they shouldn't be chosen.
      if (proactiveRecency <= 0) continue;
      // Otherwise, let's look at who was active recently.
      var latestAnyRecord = world.actionHistory.getLatestTime(actor);
      DateTime latestAnyTime = latestAnyRecord ?? pastInfinity;
      int anyRecency = world.time.difference(latestAnyTime).inSeconds;
      // We care about how long ago someone acted, but we especially care
      // about how long ago they made a pro-active action. This is because
      // otherwise an actor can be perpetually reacting to opponents and
      // never getting to their own action repertoire.
      num recency = (anyRecency + proactiveRecency) / 2;
      if (actor.isPlayer) {
        // Let player act more often.
        recency = recency * _playerTurnAdvantage;
      }
      if (recency > best) {
        chosen = actor;
        best = recency;
      }
    }

    return chosen;
  }

  // We're using [onBeforeAction] because when using onAfterAction, we'd report
  // timed events at a time when an action in FightSituation might have
  // created other (child) situations.
  @override
  Iterable<Actor> getActors(Iterable<Actor> actors, _, __) =>
      actors.where((Actor actor) =>
          actor.isAliveAndActive &&
          (playerTeamIds.contains(actor.id) ||
              enemyTeamIds.contains(actor.id)));

  @override
  void onAfterTurn(Simulation sim, WorldStateBuilder world, Storyline s) {
    if (events.containsKey(time)) {
      final callback = events[time];
      callback(sim, world, s);
    }
  }

  @override
  void onPop(Simulation sim, WorldStateBuilder world) {
    if (roomRoamingSituationId != null &&
        !canFight(sim, world, enemyTeamIds) &&
        canFight(sim, world, playerTeamIds)) {
      // We should update the underlying roomRoamingSituation with the fact
      // that all monsters have been slain.
      final situation = world.getSituationById(roomRoamingSituationId)
          as RoomRoamingSituation;
      world.replaceSituationById(
          situation.id, situation.rebuild((b) => b..monstersAlive = false));

      for (var id in playerTeamIds) {
        if (world.getActorById(id).isAliveAndActive) {
          world.updateActorById(id, (b) => b..pose = Pose.standing);
        }
      }

      // Allow player to take and distribute loot.
      world.pushSituation(new LootSituation.initialized(
          world.randomInt(), playerTeamIds, groundMaterial, droppedItems));
    } else if (!canFight(sim, world, playerTeamIds)) {
      // Nothing to do here. The player's team is all dead.
    } else {
      assert(
          true,
          "$name is being popped but there are still players alive "
          "and we have no code path for that (for example, actors don't stand "
          "up). If this is a 'run away', you should probably implement a "
          "situation on top of $name");
    }
  }

  @override
  bool shouldContinue(Simulation sim, WorldState world) {
    bool isPlayerAndAlive(int id) {
      var actor = world.getActorById(id);
      return actor.isPlayer && actor.isAliveAndActive;
    }

    final built = world.toBuilder();
    return canFight(sim, built, playerTeamIds) &&
        canFight(sim, built, enemyTeamIds) &&
        playerTeamIds.any(isPlayerAndAlive);
  }
}
