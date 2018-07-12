import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/context.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/storyline/randomly.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/team.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/src/fight/common/conflict_chance.dart';
import 'package:edgehead/src/fight/common/defense_situation.dart';
import 'package:edgehead/src/fight/common/weapon_as_object2.dart';
import 'package:edgehead/src/fight/counter_attack/counter_attack_situation.dart';

final Entity swing =
    new Entity(name: "swing", team: neutralTeam, nameIsProperNoun: true);

ReasonedSuccessChance computeShieldBlockSlash(
    Actor a, Simulation sim, WorldState w, Actor enemy) {
  return getCombatMoveChance(a, enemy, 0.7, [
    const Bonus(50, CombatReason.dexterity),
    const Bonus(30, CombatReason.balance),
    const Bonus(50, CombatReason.targetHasSecondaryArmDisabled),
    const Bonus(30, CombatReason.targetHasOneLegDisabled),
    const Bonus(90, CombatReason.targetHasAllLegsDisabled),
    const Bonus(50, CombatReason.targetHasOneEyeDisabled),
    const Bonus(90, CombatReason.targetHasAllEyesDisabled),
  ]);
}

OtherActorAction shieldBlockSlashBuilder(Actor enemy) =>
    new ShieldBlockSlash(enemy);

class ShieldBlockSlash extends OtherActorAction {
  static const String className = "ShieldBlockSlash";

  @override
  final String helpMessage = "A shield blocks enemy attacks with the least "
      "amount of energy and movement. It is easy and quick to launch "
      "a counter-attack when the enemy's weapon is stopped in this way.";

  @override
  final bool isAggressive = false;

  @override
  final bool isProactive = false;

  @override
  final bool rerollable = true;

  @override
  final Resource rerollResource = Resource.stamina;

  ShieldBlockSlash(Actor enemy) : super(enemy);

  @override
  String get commandTemplate => "block with shield and counter";

  @override
  String get name => className;

  @override
  String get rollReasonTemplate => "will <subject> block the slash?";

  @override
  String applyFailure(ActionContext context) {
    Actor a = context.actor;
    Simulation sim = context.simulation;
    WorldStateBuilder w = context.outputWorld;
    Storyline s = context.outputStoryline;
    a.report(
        s,
        "<subject> tr<ies> to {block|stop|deflect} the {swing|attack|strike} "
        "with ${shieldAsObject2(a)}");
    if (a.isOffBalance) {
      a.report(s, "<subject> <is> out of balance", but: true);
    } else {
      Randomly.run(
          () => a.report(s, "<subject> {fail<s>|<does>n't succeed}", but: true),
          () => a.report(s, "<subject> <is> too slow", but: true),
          () => target.report(s, "<subject> <is> too quick for <object>",
              object: a, but: true));
    }
    w.popSituation(sim);
    return "${a.name} fails to block ${target.name} with shield";
  }

  @override
  String applySuccess(ActionContext context) {
    Actor a = context.actor;
    Simulation sim = context.simulation;
    WorldStateBuilder w = context.outputWorld;
    Storyline s = context.outputStoryline;
    if (target.isOffBalance) {
      s.add("<subject> <is> out of balance",
          subject: target, negative: true, startSentence: true);
      s.add("so <ownerPronoun's> <subject> is {weak|feeble}",
          owner: target, subject: swing);
      a.report(
          s,
          "<subject> easily {block<s>|stop<s>|deflect<s>} the {swing|attack|strike} "
          "with ${shieldAsObject2(a)}",
          positive: true);
    } else {
      a.report(
          s,
          "<subject> {block<s>|stop<s>|deflect<s>} the {swing|attack|strike} "
          "with ${shieldAsObject2(a)}",
          positive: true);
    }

    w.popSituationsUntil("FightSituation", sim);
    if (a.isPlayer) {
      s.add("this opens an opportunity for a counter attack");
    }
    var counterAttackSituation =
        new CounterAttackSituation.initialized(w.randomInt(), a, target);
    w.pushSituation(counterAttackSituation);
    return "${a.name} blocks ${target.name} with a shield";
  }

  @override
  ReasonedSuccessChance getSuccessChance(
      Actor a, Simulation sim, WorldState w) {
    final situation = w.currentSituation as DefenseSituation;
    return situation.predeterminedChance
        .or(computeShieldBlockSlash(a, sim, w, target));
  }

  @override
  bool isApplicable(Actor a, Simulation sim, WorldState w) =>
      a.currentShield != null;
}
