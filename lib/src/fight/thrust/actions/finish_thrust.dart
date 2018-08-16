import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/anatomy/body_part.dart';
import 'package:edgehead/fractal_stories/anatomy/deal_thrusting_damage.dart';
import 'package:edgehead/fractal_stories/anatomy/weapon_assault_result.dart';
import 'package:edgehead/fractal_stories/context.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/src/fight/common/attacker_situation.dart';
import 'package:edgehead/src/fight/common/recently_forced_to_ground.dart';
import 'package:edgehead/src/fight/humanoid_pain_or_death.dart';
import 'package:edgehead/src/fight/thrust/thrust_situation.dart';
import 'package:edgehead/writers_helpers.dart' show brianaId, orcthorn;

class FinishThrust extends OtherActorAction {
  static final FinishThrust singleton = new FinishThrust();

  static const String className = "FinishThrust";

  @override
  final String helpMessage = null;

  @override
  final bool isAggressive = true;

  @override
  final bool isProactive = true;

  @override
  final bool isImplicit = true;

  @override
  final bool rerollable = true;

  @override
  final Resource rerollResource = Resource.stamina;

  @override
  String get commandTemplate => null;

  @override
  String get name => className;

  @override
  String get rollReasonTemplate => "(WARNING should not be user-visible)";

  @override
  String applyFailure(ActionContext context, Actor enemy) {
    throw new UnimplementedError();
  }

  @override
  String applySuccess(ActionContext context, Actor enemy) {
    Actor a = context.actor;
    Simulation sim = context.simulation;
    WorldStateBuilder w = context.outputWorld;
    Storyline s = context.outputStoryline;
    final damage = a.currentWeapon.damageCapability.slashingDamage;
    final situation = context.world.currentSituation as AttackerSituation;
    assert(situation.name == thrustSituationName);
    assert(situation.attackDirection != AttackDirection.fromLeft ||
        situation.attackDirection != AttackDirection.fromRight);

    final result = _executeAtDesignation(
        a, enemy, situation.attackDirection.toBodyPartDesignation());

    w.actors.removeWhere((actor) => actor.id == enemy.id);
    w.actors.add(result.actor);
    final thread = getThreadId(sim, w, thrustSituationName);
    // TODO: revert kill if it's briana.
    bool killed = !result.actor.isAlive && result.actor.id != brianaId;
    if (!killed) {
      a.report(
          s,
          "<subject> {pierce<s>|stab<s>|bore<s> through} <object's> "
          "${result.touchedPart.randomDesignation}",
          object: result.actor,
          positive: true,
          actionThread: thread);
      if (result.fell) {
        result.actor.report(s, "<subject> fall<s> {|down|to the ground}",
            negative: true, actionThread: thread);
        w.recordCustom(fellToGroundCustomEventName, actor: result.actor);
      }
      reportPain(context, result.actor, damage);
    } else {
      a.report(
          s,
          "<subject> {pierce<s>|stab<s>|bore<s> through|impale<s>} "
          "<object's> "
          "${result.touchedPart.randomDesignation}",
          object: result.actor,
          positive: true,
          actionThread: thread);
      if (a.currentWeapon.name == orcthorn.name && enemy.name.contains('orc')) {
        a.currentWeapon.report(
            s, "<subject> slit<s> through the flesh like it isn't there.",
            wholeSentence: true);
      }
      killHumanoid(context, result.actor);
    }
    return "${a.name} thrusts${killed ? ' (and kills)' : ''} ${enemy.name}";
  }

  @override
  ReasonedSuccessChance getSuccessChance(
          Actor a, Simulation sim, WorldState w, Actor enemy) =>
      ReasonedSuccessChance.sureSuccess;

  @override
  bool isApplicable(Actor a, Simulation sim, WorldState w, Actor enemy) =>
      a.currentWeapon.damageCapability.isThrusting;

  WeaponAssaultResult _executeAtDesignation(
      Actor attacker, Actor enemy, BodyPartDesignation designation) {
    return executeThrustingHit(enemy, attacker.currentWeapon, designation);
  }
}
