import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/context.dart';
import 'package:edgehead/fractal_stories/pose.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/storyline/randomly.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/src/fight/common/conflict_chance.dart';
import 'package:edgehead/src/fight/common/defense_situation.dart';
import 'package:edgehead/src/fight/counter_attack/counter_attack_situation.dart';

ReasonedSuccessChance computeDodgeThrust(
    Actor a, Simulation sim, WorldState w, Actor enemy) {
  return getCombatMoveChance(a, enemy, 0.6, [
    const Bonus(60, CombatReason.dexterity),
    const Bonus(50, CombatReason.balance),
    const Bonus(50, CombatReason.targetHasOneLegDisabled),
    const Bonus(90, CombatReason.targetHasAllLegsDisabled),
    const Bonus(50, CombatReason.targetHasOneEyeDisabled),
    const Bonus(90, CombatReason.targetHasAllEyesDisabled),
  ]);
}

OtherActorAction dodgeThrustBuilder(Actor enemy) => new DodgeThrust(enemy);

class DodgeThrust extends OtherActorAction {
  static const String className = "DodgeThrust";

  @override
  final String helpMessage = "Dodging means moving your body out of harm's "
      "way. When done correctly, it will throw your opponent off balance and "
      "it will open an opportunity for a counter attack. When botched, it "
      "can get you killed.";

  @override
  final bool isAggressive = false;

  @override
  final bool isProactive = false;

  @override
  final bool rerollable = true;

  @override
  final Resource rerollResource = Resource.stamina;

  DodgeThrust(Actor enemy) : super(enemy);

  @override
  String get commandTemplate => "dodge and counter";

  @override
  String get name => className;

  @override
  String get rollReasonTemplate => "will <subject> dodge?";

  @override
  String applyFailure(ActionContext context) {
    Actor a = context.actor;
    Simulation sim = context.simulation;
    WorldStateBuilder w = context.outputWorld;
    Storyline s = context.outputStoryline;
    a.report(s, "<subject> tr<ies> to {dodge|sidestep}");
    if (a.isOffBalance) {
      a.report(s, "<subject> <is> out of balance", but: true);
    } else {
      Randomly.run(
          () => a.report(s, "<subject> {can't|fail<s>|<does>n't succeed}",
              but: true),
          () => target.report(s, "<subject> <is> too quick for <object>",
              object: a, but: true));
    }
    w.popSituation(sim);
    return "${a.name} fails to dodge ${target.name}'s thrust";
  }

  @override
  String applySuccess(ActionContext context) {
    Actor a = context.actor;
    Simulation sim = context.simulation;
    WorldStateBuilder w = context.outputWorld;
    Storyline s = context.outputStoryline;
    a.report(s, "<subject> {dodge<s>|sidestep<s>} it",
        object: target, positive: true);
    if (target.isStanding) {
      target.report(s, "<subject> lose<s> balance because of that",
          endSentence: true, negative: true);
      w.updateActorById(target.id, (b) => b.pose = Pose.offBalance);
    }
    w.popSituationsUntil("FightSituation", sim);
    if (a.isPlayer) {
      s.add("this opens an opportunity for a counter attack");
    }
    var counterAttackSituation =
        new CounterAttackSituation.initialized(w.randomInt(), a, target);
    w.pushSituation(counterAttackSituation);
    return "${a.name} dodges ${target.name}'s thrust";
  }

  @override
  ReasonedSuccessChance getSuccessChance(
      Actor a, Simulation sim, WorldState w) {
    final situation = w.currentSituation as DefenseSituation;
    return situation.predeterminedChance
        .or(computeDodgeThrust(a, sim, w, target));
  }

  @override
  bool isApplicable(Actor a, Simulation sim, WorldState w) => !a.isOnGround;
}
