library stranded.item;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:edgehead/fractal_stories/items/damage_capability.dart';
import 'package:edgehead/fractal_stories/items/weapon_type.dart';

import 'storyline/storyline.dart';
import 'team.dart';

part 'item.g.dart';

abstract class Item extends Object
    with EntityBehavior
    implements Built<Item, ItemBuilder>, Entity {
  static Serializer<Item> get serializer => _$itemSerializer;

  /// Create a generic item.
  ///
  /// For weapons, use [Item.weapon] instead.
  factory Item(int id,
          {String name,
          bool nameIsProperNoun: false,
          DamageCapabilityBuilder damageCapability}) =>
      new _$Item((b) => b
        ..id = id
        ..damageCapability = damageCapability
        ..name = name
        ..nameIsProperNoun = nameIsProperNoun);

  factory Item.weapon(int id, WeaponType type,
      {String name,
      bool nameIsProperNoun: false,
      int slashingDamage,
      int thrustingDamage}) {
    final damageCapability = new DamageCapability(type,
        slashingDamage: slashingDamage, thrustingDamage: thrustingDamage);
    return new Item(id,
        name: name ?? type.name,
        nameIsProperNoun: nameIsProperNoun,
        damageCapability: damageCapability.toBuilder());
  }

  Item._();

  @nullable
  DamageCapability get damageCapability;

  String get description => throw new UnimplementedError();

  @override
  int get id;

  @override
  bool get isActive => true;

  @override
  bool get isAlive => false;

  @override
  bool get isPlayer => false;

  bool get isShield =>
      damageCapability != null && damageCapability.type == WeaponType.shield;

  bool get isWeapon => damageCapability != null;

  @override
  String get name;

  @override
  bool get nameIsProperNoun;

  @override
  Pronoun get pronoun => Pronoun.IT;

  @override
  Team get team => neutralTeam;

  /// Intrinsic value of the item.
  ///
  /// This is a heuristic for deciding which item is worth more, in general.
  /// It is not a monetary value.
  ///
  /// Bonus point is added when the item is named ([nameIsProperNoun]
  /// is `true`), such us "Excalibur".
  int get value {
    int score = 0;
    if (nameIsProperNoun) score += 1;
    if (isShield) score += 1;
    if (damageCapability != null) {
      score += damageCapability.length;
      score += damageCapability.slashingDamage;
      score += damageCapability.thrustingDamage;
      score += damageCapability.bluntDamage;
    }
    return score;
  }
}
