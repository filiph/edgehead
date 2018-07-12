import 'package:edgehead/edgehead_event_callbacks.dart';
import 'package:edgehead/edgehead_global.dart';
import 'package:edgehead/edgehead_simulation.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/context.dart';
import 'package:edgehead/fractal_stories/item.dart';
import 'package:edgehead/fractal_stories/items/weapon_type.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/team.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/ruleset/ruleset.dart';
import 'package:edgehead/src/fight/fight_situation.dart';
import 'package:edgehead/src/room_roaming/room_roaming_situation.dart';

const int agruthId = 6666;

const int brianaId = 100;

const int escapeTunnelGoblinId = 12345;

const int escapeTunnelOrcId = 12344;

const int madGuardianId = 50615;

const int orcthornId = 425015;

const int slaveQuartersGoblinId = 789457;

const int slaveQuartersOrcId = 789456;

const int sleepingGoblinId = 4445655;

const int sleepingGoblinsSpearId = 45234205;

/// Mostly quotes that Briana says while roaming Bloodrock.
const _brianaQuotes = const [
  '''Briana spits on the floor. "Can't wait to smell something other than 
  orc sweat and piss."
  
  _"You come from the country, then?"_
  
  "Not really. I had been living in Fort Ironcast the last five year."
  
  _"How does Fort Ironcast smell like?"_ 
  
  Briana frowns. "Mostly human sweat and piss."''',
  '''Somewhere in the distance, there are yells that rise in intensity, 
  then suddenly stop entirely.''',
  '''Briana turns to you with an intense whisper.
  
  "You know, I _have_ a right to hate orcs." 
  
  _"I did not know people needed to have a right to hate them, to be honest."_ 
  
  She observes you for a moment. "I'm glad we are in agreement."''',
  '''More yells from the distance.''',
  '''Briana stops and listens for a moment. "Aren, we're pushing our luck. 
  I'd hate to go all this way only to get
  my head smashed in by some random orc patrol."''',
  '''END''',
];

final Item orcthorn = new Item.weapon(orcthornId, WeaponType.sword,
    name: "Orcthorn",
    nameIsProperNoun: true,
    slashingDamage: 2,
    thrustingDamage: 2);

final Item sleepingGoblinsSpear =
    new Item.weapon(sleepingGoblinsSpearId, WeaponType.spear);

/// Ruleset created from [_brianaQuotes]. All quotes are `onlyOnce`. The last
/// quote is `"END"`, which will not print, and is there as the terminal
/// point.
final _brianaQuotesRuleset = new Ruleset.unordered(_brianaQuotes.map((quote) {
  return new Rule(quote.hashCode, 1, quote != 'END', (_) => true, (c) {
    if (quote == 'END') return;
    c.outputStoryline.add(quote, wholeSentence: true);
  });
}));

bool bothAreAlive(Actor a, Actor b) {
  return a.isAliveAndActive && b.isAliveAndActive;
}

void describeSuccessRate(Simulation sim, WorldState w, Storyline s) {
  s.add("<p class='meta'>", wholeSentence: true);
  s.add("Thanks for playing _Insignificant Little Vermin._",
      wholeSentence: true);

  bool hasOrcthorn = w.actionHasBeenPerformedSuccessfully("take_orcthorn");
  bool destroyed = w.actionHasBeenPerformedSuccessfully("smelter_throw_spear");
  final player = getPlayer(w);

  player.report(
      s, "<subject> ${hasOrcthorn ? 'took' : 'didn\'t find'} Orcthorn");
  player.report(
      s,
      "<subject> ${destroyed ? 'destroyed' : 'didn\'t destroy'} "
      "the iron monster",
      but: hasOrcthorn != destroyed);

  String getWeaponDescription(WeaponType type, String name) {
    final count = player.countWeapons(type);
    return count > 1 ? '${name}s' : count == 1 ? 'a $name' : 'no $name';
  }

  // You're leaving Mount Bloodrock with swords, a scimitar and a shield.
  final sword = getWeaponDescription(WeaponType.sword, 'sword');
  final spear = getWeaponDescription(WeaponType.spear, 'spear');
  final shield = getWeaponDescription(WeaponType.shield, 'shield');
  player.report(s,
      "<subject> <is> leaving Mount Bloodrock with $sword, $spear and $shield.",
      wholeSentence: true);

  // You are in good health and with energy to spare.
  final health = player.hitpoints >= 2 ? 'in good health' : 'seriously injured';
  final stamina = player.stamina > 0 ? 'with energy to spare' : 'exhausted';
  player.report(s, "<subject> <is> $health and $stamina.", wholeSentence: true);

  // Briana is not in good health.
  final briana = w.getActorById(brianaId);
  final brianaHealth = briana.hitpoints >= 2 ? 'uninjured' : 'wounded';
  briana.report(s, "<subject> <is> $brianaHealth");

  s.add(
      "The important thing, though, is that you survived. "
      "<strong>Congratulations!</strong>",
      wholeSentence: true);

  s.add("</p>", wholeSentence: true);
}

void enterTunnelWithCancel(ActionContext c) {
  final w = c.world;
  bool hasOrcthorn = w.actionHasBeenPerformedSuccessfully("take_orcthorn");
  bool destroyedIronMonster =
      w.actionHasBeenPerformedSuccessfully("smelter_throw_spear");
  bool hasHadChanceToCancel = w.actionHasBeenPerformedSuccessfully(
      "guardpost_above_church_enter_tunnel_with_cancel");

  if (hasOrcthorn || destroyedIronMonster || hasHadChanceToCancel) {
    movePlayer(c, "tunnel");
    return;
  }

  movePlayer(c, "tunnel_cancel_chance");
}

void executeSpearThrowAtOgre(ActionContext c) {
  final player = getPlayer(c.world);
  final inventorySpears = player.weapons
      .where((item) => item.damageCapability.type == WeaponType.spear)
      .toList(growable: false);
  if (inventorySpears.isNotEmpty) {
    c.outputWorld.updateActorById(
        player.id, (b) => b..items.remove(inventorySpears.first));
  } else {
    // No spear in inventory but we know that the actor has a spear. So it
    // must be in their hand.
    final replacementWeapon =
        player.findBestWeapon() ?? Actor.createBodyPartWeapon(player.anatomy);
    c.outputWorld.updateActorById(
        player.id,
        (b) => b
          ..currentWeapon = replacementWeapon.toBuilder()
          ..items.remove(replacementWeapon));
  }
  movePlayer(c, "war_forge", silent: true);
}

FightSituation generateAgruthFight(Simulation sim, WorldStateBuilder w,
    RoomRoamingSituation roomRoamingSituation, Iterable<Actor> party) {
  var agruth = _generateAgruth();
  w.actors.add(agruth);
  return new FightSituation.initialized(
      w.randomInt(),
      party,
      [agruth],
      "{rock|cavern} floor",
      roomRoamingSituation,
      {
        1: youre_dead_slave,
        5: agruth_spits,
        9: agruth_enjoy_eating_flesh,
        12: agruth_grit_teeth,
        17: agruth_scowls,
      });
}

FightSituation generateEscapeTunnelFight(Simulation sim, WorldStateBuilder w,
    RoomRoamingSituation roomRoamingSituation, Iterable<Actor> party) {
  var orc = _makeOrc(w, id: escapeTunnelOrcId);
  var goblin = _makeGoblin(w, id: escapeTunnelGoblinId);
  var monsters = [orc, goblin];
  w.actors.addAll(monsters);
  return new FightSituation.initialized(w.randomInt(), party, monsters,
      "{rock|cavern} floor", roomRoamingSituation, {
    1: escape_tunnel_look,
    4: escape_tunnel_insignificant,
    6: escape_tunnel_loud_cries,
    9: escape_tunnel_earsplitting,
    12: escape_tunnel_halfway,
    16: escape_pursuers_reach,
  });
}

FightSituation generateMadGuardianFight(Simulation sim, WorldStateBuilder w,
    RoomRoamingSituation roomRoamingSituation, Iterable<Actor> party) {
  var knowsAboutGuardian = w.actionHasBeenPerformed("talk_to_briana_3");
  var madGuardian = _generateMadGuardian(w, knowsAboutGuardian);
  w.actors.add(madGuardian);
  return new FightSituation.initialized(
      w.randomInt(),
      party,
      [madGuardian],
      "{rock|cavern} floor",
      roomRoamingSituation,
      {
        1: mad_guardian_good,
        3: mad_guardian_pain,
        5: mad_guardian_shut_up,
      });
}

FightSituation generateMountainPassGuardPostFight(
    Simulation sim,
    WorldStateBuilder w,
    RoomRoamingSituation roomRoamingSituation,
    Iterable<Actor> party) {
  List<Actor> monsters;
  if (w.actionHasBeenPerformedSuccessfully("take_out_gate_guards") ||
      w.actionHasBeenPerformedSuccessfully("take_out_gate_guards_rescue")) {
    monsters = [_makeOrc(w)];
  } else {
    monsters = [_makeOrc(w), _makeGoblin(w)];
  }
  w.actors.addAll(monsters);

  return new FightSituation.initialized(
      w.randomInt(), party, monsters, "ground", roomRoamingSituation, {});
}

FightSituation generateSlaveQuartersPassageFight(
    Simulation sim,
    WorldStateBuilder w,
    RoomRoamingSituation roomRoamingSituation,
    Iterable<Actor> party) {
  var orc = _makeOrc(w, id: slaveQuartersOrcId);
  var goblin = _makeGoblin(w, id: slaveQuartersGoblinId, spear: true);
  var monsters = [orc, goblin];
  w.actors.addAll(monsters);
  return new FightSituation.initialized(w.randomInt(), party, monsters,
      "{rough|stone} floor", roomRoamingSituation, {
    1: slave_quarters_orc_looks,
    3: slave_quarters_mean_nothing,
  });
}

/// Test fight. Do not use in production.
FightSituation generateTestFight(Simulation sim, WorldStateBuilder w,
    RoomRoamingSituation roomRoamingSituation, Iterable<Actor> party) {
  final aguthsSword = new Item.weapon(89892130, WeaponType.sword);
  final playersSword = new Item.weapon(89892131, WeaponType.sword);
  var agruth = _generateAgruth()
      .rebuild((b) => b..currentWeapon = aguthsSword.toBuilder());
  w.actors.add(agruth);
  w.updateActorById(
      playerId, (b) => b..currentWeapon = playersSword.toBuilder());
  return new FightSituation.initialized(
    w.randomInt(),
    party.where((a) => a.isPlayer),
    [agruth],
    "{rock|cavern} floor",
    roomRoamingSituation,
    {},
  );
}

Actor getEscapeTunnelGoblin(WorldState w) =>
    w.getActorById(escapeTunnelGoblinId);

Actor getEscapeTunnelOrc(WorldState w) => w.getActorById(escapeTunnelOrcId);

EdgeheadGlobalState getGlobal(WorldStateBuilder w) =>
    w.global as EdgeheadGlobalState;

Actor getPlayer(WorldState w) => w.getActorById(playerId);

RoomRoamingSituation getRoomRoaming(WorldState w) {
  return w
      .getSituationByName<RoomRoamingSituation>(RoomRoamingSituation.className);
}

Actor getSlaveQuartersGoblin(WorldStateBuilder w) =>
    w.getActorById(slaveQuartersGoblinId);

Actor getSlaveQuartersOrc(WorldStateBuilder w) =>
    w.getActorById(slaveQuartersOrcId);

void giveGoblinsSpearToPlayer(WorldStateBuilder w) => w.updateActorById(
    getPlayer(w.build()).id, (b) => b..weapons.add(sleepingGoblinsSpear));

void giveGoldToPlayer(WorldStateBuilder w, int amount) {
  w.updateActorById(getPlayer(w.build()).id, (b) => b..gold += amount);
}

void giveStaminaToPlayer(WorldStateBuilder w, int amount) {
  w.updateActorById(getPlayer(w.build()).id, (b) => b..stamina += amount);
}

/// Returns `true` while player is roaming through Bloodrock. Note that the list
/// of rooms contains only those that are actual rooms (it excludes the likes
/// of `just_after_agruth_fight`, which is a helper room for naming Agruth's
/// sword).
bool isRoamingInBloodrock(WorldState w) {
  if ((w.currentSituation as RoomRoamingSituation).monstersAlive) return false;
  const bloodrockRoamingRooms = const [
    "cave_with_agruth",
    "guardpost_above_church",
    "orcthorn_room",
    "slave_quarters_passage",
    "smelter",
    "underground_church",
    "war_forge",
  ];
  return bloodrockRoamingRooms
      .contains((w.currentSituation as RoomRoamingSituation).currentRoomName);
}

/// Checks whether player was just now at [fromRoomName].
///
/// This only returns `true` if no other room was visited since then.
///
/// If player was in a variant of [fromRoomName], then that counts as well.
bool justCameFrom(WorldState w, String fromRoomName) {
  final player = getPlayer(w);
  final latest = w.visitHistory.getLatestOnly(player);
  if (latest == null) return false;
  return latest.roomName == fromRoomName ||
      latest.parentRoomName == fromRoomName;
}

void movePlayer(ActionContext context, String locationName,
    {bool silent: false}) {
  getRoomRoaming(context.world)
      .moveActor(context, locationName, silent: silent);
}

void nameAgruthSword(WorldStateBuilder w, String name) {
  final built = w.build();
  // Assume only one sword wielded by either Aren or Briana.
  for (var actor in built.actors.where((a) => a.team == playerTeam)) {
    if (!actor.isBarehanded) {
      var sword = actor.currentWeapon;
      var named = sword.toBuilder()
        ..name = name
        ..nameIsProperNoun = true;
      w.updateActorById(actor.id, (b) => b..currentWeapon = named);
      break;
    }
  }
}

bool playerHasVisited(Simulation sim, WorldState built, String roomName) {
  final room = sim.getRoomByName(roomName);
  final player = getPlayer(built);
  return built.visitHistory.query(player, room).hasHappened;
}

void rollBrianaQuote(ActionContext context) {
  _brianaQuotesRuleset.apply(context);
}

/// Updates state according to whatever happened when Aren tried to steal
/// the shield from the sleeping guard. If he was successful, there will be
/// no fight, otherwise, there will be fight.
void setUpStealShield(Actor a, Simulation sim, WorldStateBuilder w, Storyline s,
    bool wasSuccess) {
  w.updateActorById(
      a.id,
      (b) => b
        ..currentShield =
            new Item.weapon(w.randomInt(), WeaponType.shield).toBuilder());
  if (!wasSuccess) {
    final built = w.build();
    final playerParty = built.actors.where((a) => a.team == playerTeam);
    final goblin = _makeGoblin(w, id: sleepingGoblinId);
    w.actors.add(goblin);
    final roomRoamingSituation = getRoomRoaming(built);
    w.pushSituation(new FightSituation.initialized(
        w.randomInt(),
        playerParty,
        [goblin],
        "{smooth |}rock floor",
        roomRoamingSituation,
        {
          1: sleeping_goblin_thief,
        }));
  }
}

void takeOrcthorn(Simulation sim, WorldStateBuilder w, Actor a) {
  w.updateActorById(a.id, (b) {
    if (!a.isBarehanded) {
      b.weapons.add(a.currentWeapon);
    }
    b.currentWeapon = orcthorn.toBuilder();
  });
}

void updateGlobal(Simulation sim, WorldStateBuilder w,
    EdgeheadGlobalStateBuilder updates(EdgeheadGlobalStateBuilder b)) {
  var builder = (w.global as EdgeheadGlobalState).toBuilder();
  w.global = updates(builder).build();
}

Actor _generateAgruth() {
  return new Actor.initialized(agruthId, "Agruth",
      nameIsProperNoun: true,
      pronoun: Pronoun.HE,
      constitution: 2,
      team: defaultEnemyTeam,
      initiative: 100);
}

Actor _generateMadGuardian(WorldStateBuilder w, bool playerKnowsAboutGuardian) {
  return new Actor.initialized(
      madGuardianId, playerKnowsAboutGuardian ? "guardian" : "orc",
      pronoun: Pronoun.HE,
      currentWeapon:
          new Item.weapon(w.randomInt(), WeaponType.sword, name: "rusty sword"),
      constitution: 3,
      team: defaultEnemyTeam,
      initiative: 100);
}

Actor _makeGoblin(WorldStateBuilder w, {int id, bool spear: false}) =>
    new Actor.initialized(id ?? w.randomInt(), "goblin",
        nameIsProperNoun: false,
        pronoun: Pronoun.HE,
        currentWeapon: spear
            ? new Item.weapon(w.randomInt(), WeaponType.spear)
            : new Item.weapon(w.randomInt(), WeaponType.sword,
                name: "scimitar"),
        team: defaultEnemyTeam,
        combineFunctionHandle: carelessMonsterCombineFunctionHandle);

Actor _makeOrc(WorldStateBuilder w, {int id, int constitution: 2}) =>
    new Actor.initialized(id ?? w.randomInt(), "orc",
        nameIsProperNoun: false,
        pronoun: Pronoun.HE,
        currentWeapon: new Item.weapon(w.randomInt(), WeaponType.sword),
        constitution: constitution,
        team: defaultEnemyTeam,
        combineFunctionHandle: carelessMonsterCombineFunctionHandle);
