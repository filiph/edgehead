// GENERATED CODE - DO NOT MODIFY BY HAND

part of fractal_stories.items.weapon;

// **************************************************************************
// Generator: BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_returning_this
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first

Serializer<DamageCapability> _$damageCapabilitySerializer =
    new _$DamageCapabilitySerializer();

class _$DamageCapabilitySerializer
    implements StructuredSerializer<DamageCapability> {
  @override
  final Iterable<Type> types = const [DamageCapability, _$DamageCapability];
  @override
  final String wireName = 'DamageCapability';

  @override
  Iterable serialize(Serializers serializers, DamageCapability object,
      {FullType specifiedType: FullType.unspecified}) {
    final result = <Object>[
      'bluntDamage',
      serializers.serialize(object.bluntDamage,
          specifiedType: const FullType(int)),
      'length',
      serializers.serialize(object.length, specifiedType: const FullType(int)),
      'slashingDamage',
      serializers.serialize(object.slashingDamage,
          specifiedType: const FullType(int)),
      'thrustingDamage',
      serializers.serialize(object.thrustingDamage,
          specifiedType: const FullType(int)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(WeaponType)),
    ];

    return result;
  }

  @override
  DamageCapability deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType: FullType.unspecified}) {
    final result = new DamageCapabilityBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'bluntDamage':
          result.bluntDamage = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'length':
          result.length = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'slashingDamage':
          result.slashingDamage = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'thrustingDamage':
          result.thrustingDamage = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(WeaponType)) as WeaponType;
          break;
      }
    }

    return result.build();
  }
}

class _$DamageCapability extends DamageCapability {
  @override
  final int bluntDamage;
  @override
  final int length;
  @override
  final int slashingDamage;
  @override
  final int thrustingDamage;
  @override
  final WeaponType type;

  factory _$DamageCapability([void updates(DamageCapabilityBuilder b)]) =>
      (new DamageCapabilityBuilder()..update(updates)).build();

  _$DamageCapability._(
      {this.bluntDamage,
      this.length,
      this.slashingDamage,
      this.thrustingDamage,
      this.type})
      : super._() {
    if (bluntDamage == null) throw new ArgumentError.notNull('bluntDamage');
    if (length == null) throw new ArgumentError.notNull('length');
    if (slashingDamage == null)
      throw new ArgumentError.notNull('slashingDamage');
    if (thrustingDamage == null)
      throw new ArgumentError.notNull('thrustingDamage');
    if (type == null) throw new ArgumentError.notNull('type');
  }

  @override
  DamageCapability rebuild(void updates(DamageCapabilityBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  DamageCapabilityBuilder toBuilder() =>
      new DamageCapabilityBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! DamageCapability) return false;
    return bluntDamage == other.bluntDamage &&
        length == other.length &&
        slashingDamage == other.slashingDamage &&
        thrustingDamage == other.thrustingDamage &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, bluntDamage.hashCode), length.hashCode),
                slashingDamage.hashCode),
            thrustingDamage.hashCode),
        type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DamageCapability')
          ..add('bluntDamage', bluntDamage)
          ..add('length', length)
          ..add('slashingDamage', slashingDamage)
          ..add('thrustingDamage', thrustingDamage)
          ..add('type', type))
        .toString();
  }
}

class DamageCapabilityBuilder
    implements Builder<DamageCapability, DamageCapabilityBuilder> {
  _$DamageCapability _$v;

  int _bluntDamage;
  int get bluntDamage => _$this._bluntDamage;
  set bluntDamage(int bluntDamage) => _$this._bluntDamage = bluntDamage;

  int _length;
  int get length => _$this._length;
  set length(int length) => _$this._length = length;

  int _slashingDamage;
  int get slashingDamage => _$this._slashingDamage;
  set slashingDamage(int slashingDamage) =>
      _$this._slashingDamage = slashingDamage;

  int _thrustingDamage;
  int get thrustingDamage => _$this._thrustingDamage;
  set thrustingDamage(int thrustingDamage) =>
      _$this._thrustingDamage = thrustingDamage;

  WeaponType _type;
  WeaponType get type => _$this._type;
  set type(WeaponType type) => _$this._type = type;

  DamageCapabilityBuilder();

  DamageCapabilityBuilder get _$this {
    if (_$v != null) {
      _bluntDamage = _$v.bluntDamage;
      _length = _$v.length;
      _slashingDamage = _$v.slashingDamage;
      _thrustingDamage = _$v.thrustingDamage;
      _type = _$v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DamageCapability other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$DamageCapability;
  }

  @override
  void update(void updates(DamageCapabilityBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$DamageCapability build() {
    final _$result = _$v ??
        new _$DamageCapability._(
            bluntDamage: bluntDamage,
            length: length,
            slashingDamage: slashingDamage,
            thrustingDamage: thrustingDamage,
            type: type);
    replace(_$result);
    return _$result;
  }
}
