import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/storyline/randomly.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/world.dart';
import 'package:edgehead/src/fight/common/recently_forced_to_ground.dart';

class StandUp extends Action {
  static final StandUp singleton = new StandUp();

  static const String className = "StandUp";

  @override
  final String helpMessage = null;

  @override
  final bool isAggressive = false;

  @override
  final bool isProactive = true;

  @override
  final bool rerollable = true;

  @override
  final Resource rerollResource = Resource.stamina;

  @override
  String get command => "Stand up.";

  @override
  String get name => className;

  @override
  String applyFailure(_) {
    throw new UnimplementedError();
  }

  @override
  String applySuccess(ActionContext context) {
    Actor a = context.actor;
    WorldState w = context.world;
    Storyline s = context.storyline;
    a.report(
        s,
        "<subject> {rise<s>|stand<s> up|get<s> to <subject's> feet|"
        "get<s> up|pick<s> <subjectPronounSelf> up}");
    Randomly.run(
        () => a.report(
            s, "<subject> {stagger<s>|sway<s>} back before finding balance"),
        () => a.report(s, "<subject> stead<ies> <subjectPronounSelf>"));
    w.updateActorById(a.id, (b) => b.pose = Pose.standing);
    return "${a.name} stands up";
  }

  @override
  String getRollReason(Actor a, WorldState w) =>
      "Will ${a.pronoun.nominative} stand up?";

  @override
  num getSuccessChance(Actor actor, WorldState world) => 1.0;

  @override
  bool isApplicable(Actor a, WorldState world) {
    if (!a.isOnGround) return false;
    // If this actor just fell, do not let him stand up.
    if (recentlyForcedToGround(a, world)) return false;
    return true;
  }
}
