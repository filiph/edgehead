library stranded.room;

import 'package:edgehead/fractal_stories/actor.dart';
import 'package:edgehead/fractal_stories/context.dart';
import 'package:edgehead/fractal_stories/item.dart';
import 'package:edgehead/fractal_stories/shared_constants.dart';
import 'package:edgehead/fractal_stories/simulation.dart';
import 'package:edgehead/fractal_stories/world_state.dart';
import 'package:edgehead/ruleset/ruleset.dart';
import 'package:edgehead/src/fight/fight_situation.dart';
import 'package:edgehead/src/room_roaming/room_roaming_situation.dart';
import 'package:meta/meta.dart';

/// Describer that doesn't output any text at all.
final RoomDescriber emptyRoomDescription = (c) {};

/// This is the magic [Room] that, when reached, makes
/// the room roaming situation stop.
final Room endOfRoam = new Room(
    endOfRoamName, emptyRoomDescription, emptyRoomDescription, null, null);

/// This generator creates a [FightSituation].
///
/// TODO: remove the dependency on [FightSituation] and [RoomRoamingSituation]
///       or pull out Room into RoomRoaming instead of having it here.
typedef FightSituation FightGenerator(Simulation sim, WorldStateBuilder world,
    RoomRoamingSituation roomRoamingSituation, Iterable<Actor> party);

typedef Iterable<Item> ItemGenerator(Simulation sim, WorldState world);

/// A function that should use [s] to report on what the player sees when
/// entering the room.
///
/// The function can modify the [WorldState] if need be (for example, for
/// counting purposes - "how many times did we see that artifact?").
typedef void RoomDescriber(ActionContext context);

// TODO: add noItemsInRoom and noMonstersInRoom to be used instead of `null`
//       similar to emptyRoomDescription

/// Rooms are mostly closed-off places that don't allow free roaming.
///
/// In that, they differ from [Location], which is a place on a map that
/// allows the player to go to any other location on that map.
@immutable
class Room {
  final String name;

  /// Fully describes the room according to current state of the world when
  /// the actor first sees it.
  ///
  /// When this is `null`, then [describe] is used for the first
  /// visit as well for all other visits.
  final RoomDescriber firstDescribe;

  /// Describes the room with a short blurb, after player has already visited
  /// it at least once.
  ///
  /// When this is `null` and the player visits the room more than once,
  /// an [AssertionError] is thrown.
  final RoomDescriber describe;

  /// Optionally, a [Room] can have a parent room. In that case, this room
  /// is a specialized version (variant) of the parent.
  ///
  /// For example, a forge can have a variant after it has burned down. The
  /// `burned_down_forge` variant would specify `forge` as its parent, and
  /// would have a [prerequisite] that checks if the forge has burned down.
  ///
  /// [parent] is specified as a String. It must correspond to the parent's
  /// [Room.name].
  final String parent;

  /// If present, and if [Prerequisite.isSatisfiedBy] evaluates to
  /// `true`, then this room will override its [parent] room.
  ///
  /// For [Prerequisite.hash], use [Room.name.hashCode].
  final Prerequisite prerequisite;

  /// A function that builds the fight situation in the Room when player arrives
  /// for the first time.
  ///
  /// It's a function instead of a constant because we want to only
  /// initialize the fight situation and the monsters when we get to them
  /// (so that they don't take memory and CPU) and sometimes we might like
  /// varying fights according to current [Simulation].
  final FightGenerator fightGenerator;

  /// A function that creates items that are in the Room when player arrives
  /// for the first time.
  ///
  /// It's a function instead of a constant list because we want to only
  /// initialize items when we get to them (so that they don't take memory
  /// and CPU) and sometimes we might like varying items according to
  /// current [Simulation].
  final ItemGenerator itemGenerator;

  final String groundMaterial;

  /// Creates a new room. [name], [describe] and [exits] cannot be `null`.
  Room(this.name, this.firstDescribe, this.describe, this.fightGenerator,
      this.itemGenerator,
      {this.groundMaterial: "ground", this.parent, this.prerequisite}) {
    assert(name != null);
    assert(
        describe != null || firstDescribe != null,
        "You must provide at least one description of the room. "
        "Ideally, you also provide both the first description and the regular "
        "one.");
  }

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) => other is Room && other.name == name;

  @override
  String toString() => "Room<$name>";
}
