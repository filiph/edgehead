import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/context.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/world_state.dart';

class Confuse extends EnemyTargetAction {
  static const int minimalEffectLength = 8;

  static const String className = "Confuse";

  @override
  final bool isAggressive = true;

  @override
  final bool isProactive = true;

  @override
  String helpMessage = "Channeling the terror of the Dead Prince into lesser "
      "minds is something you've been practicing. It makes the target rabid "
      "and disoriented. They might attack their own.";

  @override
  final bool rerollable = true;

  @override
  final Resource rerollResource = Resource.stamina;

  Confuse(Actor enemy) : super(enemy);

  @override
  String get commandTemplate => "confuse <object>";

  @override
  String get name => className;

  @override
  String get rollReasonTemplate => "will <subject> confuse <object>?";

  @override
  String applyFailure(ActionContext context) {
    Actor a = context.actor;
    Storyline s = context.outputStoryline;
    a.report(s, "<subject> touch<es> <subject's> temple");
    a.report(
        s,
        "<subject> tr<ies> to {channel|implant} {terror|confusion} "
        "into <object's> mind",
        object: enemy);
    a.report(s, "<subject> fail<s>", negative: true, but: true);
    return "${a.name} fails to confuse ${enemy.name}";
  }

  @override
  String applySuccess(ActionContext context) {
    Actor a = context.actor;
    WorldStateBuilder w = context.outputWorld;
    Storyline s = context.outputStoryline;
    a.report(s, "<subject> touch<es> <subject's> temple");
    a.report(
        s,
        "<subject> {channel<s>|implant<s>} {terror|confusion} "
        "into <object's> mind",
        object: enemy,
        positive: true);
    enemy.report(s, "<subject's> eyes go wide with terror", negative: true);
    w.updateActorById(enemy.id, (b) => b..isConfused = true);
    return "${a.name} confuses ${enemy.name}";
  }

  @override
  ReasonedSuccessChance getSuccessChance(
      Actor a, Simulation sim, WorldState world) {
    return new ReasonedSuccessChance<Object>(0.8);
  }

  @override
  bool isApplicable(Actor a, Simulation sim, WorldState world) =>
      a.isPlayer &&
      a.isStanding &&
      world.actors
              .where((o) => o.isAlive && o.team.isFriendWith(enemy.team))
              .length >=
          2 &&
      !enemy.isConfused;

  static EnemyTargetAction builder(Actor enemy) => new Confuse(enemy);
}
