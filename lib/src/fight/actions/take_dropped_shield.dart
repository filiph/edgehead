import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/context.dart';
import 'package:edgehead/fractal_stories/item.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/src/fight/fight_situation.dart';

class TakeDroppedShield extends ItemAction {
  static const String className = "TakeDroppedShield";

  @override
  final bool isProactive = true;

  TakeDroppedShield(Item item) : super(item);

  @override
  String get commandTemplate => "pick up <object>";

  @override
  String get helpMessage => "A shield makes a huge difference in battle.";

  @override
  bool get isAggressive => false;

  @override
  String get name => className;

  @override
  bool get rerollable => false;

  @override
  Resource get rerollResource => null;

  @override
  String applyFailure(ActionContext context) {
    throw new UnimplementedError();
  }

  @override
  String applySuccess(ActionContext context) {
    assert(item.isShield);
    Actor a = context.actor;
    WorldStateBuilder w = context.outputWorld;
    Storyline s = context.outputStoryline;
    final situation = w.currentSituation as FightSituation;
    w.replaceSituationById(
        situation.id,
        situation.rebuild(
            (FightSituationBuilder b) => b..droppedItems.remove(item)));
    w.updateActorById(a.id, (b) {
      b.currentShield = item.toBuilder();
    });
    a.report(s, "<subject> pick<s> <object> up", object: item);
    return "${a.name} picks up ${item.name}";
  }

  @override
  String getRollReason(Actor a, Simulation sim, WorldState w) =>
      throw new UnimplementedError();

  @override
  num getSuccessChance(Actor a, Simulation sim, WorldState w) => 1.0;

  @override
  bool isApplicable(Actor a, Simulation sim, WorldState w) {
    if (!item.isShield) return false;
    if (!a.canWield) return false;
    if (a.currentShield != null) return false;
    return true;
  }

  static ItemAction builder(Item item) => new TakeDroppedShield(item);
}
