library stranded.context;

import 'package:edgehead/ecs/pubsub.dart';
import 'package:edgehead/fractal_stories/action.dart';
import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/storyline/storyline.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:meta/meta.dart';

/// This is all the context an action needs to apply itself. It is provided
/// to [Action.applySuccess] and [Action.applyFailure] (and [ApplyFunction]s
/// in general).
///
/// [outputStoryline] should only be used to
/// add new reports ([Storyline.add] and [Actor.report]). [pubSub] should
/// only be used to publish events.
///
/// [actor] is the perpetrator of the action. The [target] is the entity that
/// the action is directed to. It can be `null`.
@immutable
class ActionContext extends ApplicabilityContext {
  /// This is the object which should be mutated in order to provide the
  /// result of the action.
  final WorldStateBuilder outputWorld;

  /// This is set to the current action as that action is being applied.
  ///
  /// This is so that, for example, descriptions of Rooms can access this
  /// information and provide text according to how the Room is being reached.
  final Action currentAction;

  /// This is the output of [Action.getSuccessChance]. It is possible to
  /// check this for reasons that we can report in [Action.applySuccess]
  /// or [Action.applyFailure].
  final ReasonedSuccessChance successChance;

  final PubSub pubSub;

  final Storyline outputStoryline;

  const ActionContext(
      this.currentAction,
      Actor actor,
      Simulation simulation,
      WorldState world,
      this.pubSub,
      this.outputWorld,
      this.outputStoryline,
      this.successChance,
      {Object target})
      : super(actor, simulation, world, target: target);
}

/// This is all the context an action (or rule) needs to see if it's applicable.
///
/// In contrast to [ActionContext], this class doesn't have any "output"
/// members, and is completely, recursively immutable.
@immutable
class ApplicabilityContext {
  final Actor actor;

  final Simulation simulation;

  final WorldState world;

  final Object target;

  const ApplicabilityContext(this.actor, this.simulation, this.world,
      {this.target});
}
