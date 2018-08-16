import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/situation.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/src/fight/actions/start_defensible_action.dart';
import 'package:edgehead/src/fight/common/conflict_chance.dart';
import 'package:edgehead/src/fight/punch/punch_defense/punch_defense_situation.dart';
import 'package:edgehead/src/fight/punch/punch_situation.dart';

const String startPunchCommandTemplate = "punch <object>";

const String startPunchHelpMessage =
    "Punching someone hard enough can cause them to lose their footing. "
    "And it hurts.";

ReasonedSuccessChance computeStartPunch(
    Actor a, Simulation sim, WorldState w, Actor enemy) {
  return getCombatMoveChance(a, enemy, 0.6, [
    const Bonus(75, CombatReason.dexterity),
    const Bonus(30, CombatReason.balance),
    const Bonus(20, CombatReason.targetHasSecondaryArmDisabled),
    const Bonus(50, CombatReason.targetHasPrimaryArmDisabled),
    const Bonus(30, CombatReason.targetHasOneLegDisabled),
    const Bonus(50, CombatReason.targetHasAllLegsDisabled),
    const Bonus(50, CombatReason.targetHasOneEyeDisabled),
    const Bonus(90, CombatReason.targetHasAllEyesDisabled),
  ]);
}

EnemyTargetAction startPunchBuilder() => new StartDefensibleAction(
      name: "StartPunch",
      commandTemplate: startPunchCommandTemplate,
      helpMessage: startPunchHelpMessage,
      applyStart: startPunchReportStart,
      isApplicable: (a, sim, w, enemy) =>
          (a.isStanding || a.isOffBalance) &&
          !enemy.isOnGround &&
          a.isBarehanded,
      mainSituationBuilder: (a, sim, w, enemy) =>
          createPunchSituation(w.randomInt(), a, enemy),
      defenseSituationBuilder: (a, sim, w, enemy, predetermination) =>
          createPunchDefenseSituation(
              w.randomInt(), a, enemy, predetermination),
      successChanceGetter: computeStartPunch,
      rerollable: true,
      rerollResource: Resource.stamina,
      rollReasonTemplate: "will <subject> hit <objectPronoun>?",
    );

void startPunchReportStart(Actor a, Simulation sim, WorldStateBuilder w,
    Storyline s, Actor enemy, Situation mainSituation) {
  s.add("<subject> {thrust<s>|swing<s>} <subject's> fist at <object>",
      subject: a,
      object: enemy,
      actionThread: mainSituation.id,
      isSupportiveActionInThread: true);
}
