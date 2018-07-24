// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.fight.attacker_situation;

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

const AttackDirection _$fromLeft = const AttackDirection._('fromLeft');
const AttackDirection _$fromRight = const AttackDirection._('fromRight');
const AttackDirection _$primaryArm = const AttackDirection._('primaryArm');
const AttackDirection _$secondaryArm = const AttackDirection._('secondaryArm');
const AttackDirection _$neck = const AttackDirection._('neck');
const AttackDirection _$leftLeg = const AttackDirection._('leftLeg');
const AttackDirection _$rightLeg = const AttackDirection._('rightLeg');
const AttackDirection _$leftEye = const AttackDirection._('leftEye');
const AttackDirection _$rightEye = const AttackDirection._('rightEye');
const AttackDirection _$torso = const AttackDirection._('torso');
const AttackDirection _$head = const AttackDirection._('head');
const AttackDirection _$unspecified = const AttackDirection._('unspecified');

AttackDirection _$valueOfAttackDirection(String name) {
  switch (name) {
    case 'fromLeft':
      return _$fromLeft;
    case 'fromRight':
      return _$fromRight;
    case 'primaryArm':
      return _$primaryArm;
    case 'secondaryArm':
      return _$secondaryArm;
    case 'neck':
      return _$neck;
    case 'leftLeg':
      return _$leftLeg;
    case 'rightLeg':
      return _$rightLeg;
    case 'leftEye':
      return _$leftEye;
    case 'rightEye':
      return _$rightEye;
    case 'torso':
      return _$torso;
    case 'head':
      return _$head;
    case 'unspecified':
      return _$unspecified;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AttackDirection> _$attackDirectionValues =
    new BuiltSet<AttackDirection>(const <AttackDirection>[
  _$fromLeft,
  _$fromRight,
  _$primaryArm,
  _$secondaryArm,
  _$neck,
  _$leftLeg,
  _$rightLeg,
  _$leftEye,
  _$rightEye,
  _$torso,
  _$head,
  _$unspecified,
]);

Serializer<AttackDirection> _$attackDirectionSerializer =
    new _$AttackDirectionSerializer();
Serializer<AttackerSituation> _$attackerSituationSerializer =
    new _$AttackerSituationSerializer();

class _$AttackDirectionSerializer
    implements PrimitiveSerializer<AttackDirection> {
  @override
  final Iterable<Type> types = const <Type>[AttackDirection];
  @override
  final String wireName = 'AttackDirection';

  @override
  Object serialize(Serializers serializers, AttackDirection object,
          {FullType specifiedType: FullType.unspecified}) =>
      object.name;

  @override
  AttackDirection deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType: FullType.unspecified}) =>
      AttackDirection.valueOf(serialized as String);
}

class _$AttackerSituationSerializer
    implements StructuredSerializer<AttackerSituation> {
  @override
  final Iterable<Type> types = const [AttackerSituation, _$AttackerSituation];
  @override
  final String wireName = 'AttackerSituation';

  @override
  Iterable serialize(Serializers serializers, AttackerSituation object,
      {FullType specifiedType: FullType.unspecified}) {
    final result = <Object>[
      'attackDirection',
      serializers.serialize(object.attackDirection,
          specifiedType: const FullType(AttackDirection)),
      'attacker',
      serializers.serialize(object.attacker,
          specifiedType: const FullType(int)),
      'builtEnemyTargetActionGenerators',
      serializers.serialize(object.builtEnemyTargetActionGenerators,
          specifiedType: const FullType(
              BuiltList, const [const FullType(EnemyTargetActionBuilder)])),
      'builtOtherActorActionGenerators',
      serializers.serialize(object.builtOtherActorActionGenerators,
          specifiedType: const FullType(
              BuiltList, const [const FullType(OtherActorActionBuilder)])),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'target',
      serializers.serialize(object.target, specifiedType: const FullType(int)),
      'time',
      serializers.serialize(object.time, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  AttackerSituation deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType: FullType.unspecified}) {
    final result = new AttackerSituationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'attackDirection':
          result.attackDirection = serializers.deserialize(value,
                  specifiedType: const FullType(AttackDirection))
              as AttackDirection;
          break;
        case 'attacker':
          result.attacker = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'builtEnemyTargetActionGenerators':
          result.builtEnemyTargetActionGenerators.replace(
              serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(EnemyTargetActionBuilder)
                  ])) as BuiltList<EnemyTargetActionBuilder>);
          break;
        case 'builtOtherActorActionGenerators':
          result.builtOtherActorActionGenerators.replace(
              serializers.deserialize(value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(OtherActorActionBuilder)
                  ])) as BuiltList<OtherActorActionBuilder>);
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'target':
          result.target = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'time':
          result.time = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$AttackerSituation extends AttackerSituation {
  @override
  final AttackDirection attackDirection;
  @override
  final int attacker;
  @override
  final BuiltList<EnemyTargetActionBuilder> builtEnemyTargetActionGenerators;
  @override
  final BuiltList<OtherActorActionBuilder> builtOtherActorActionGenerators;
  @override
  final int id;
  @override
  final String name;
  @override
  final int target;
  @override
  final int time;

  factory _$AttackerSituation([void updates(AttackerSituationBuilder b)]) =>
      (new AttackerSituationBuilder()..update(updates)).build();

  _$AttackerSituation._(
      {this.attackDirection,
      this.attacker,
      this.builtEnemyTargetActionGenerators,
      this.builtOtherActorActionGenerators,
      this.id,
      this.name,
      this.target,
      this.time})
      : super._() {
    if (attackDirection == null)
      throw new ArgumentError.notNull('attackDirection');
    if (attacker == null) throw new ArgumentError.notNull('attacker');
    if (builtEnemyTargetActionGenerators == null)
      throw new ArgumentError.notNull('builtEnemyTargetActionGenerators');
    if (builtOtherActorActionGenerators == null)
      throw new ArgumentError.notNull('builtOtherActorActionGenerators');
    if (id == null) throw new ArgumentError.notNull('id');
    if (name == null) throw new ArgumentError.notNull('name');
    if (target == null) throw new ArgumentError.notNull('target');
    if (time == null) throw new ArgumentError.notNull('time');
  }

  @override
  AttackerSituation rebuild(void updates(AttackerSituationBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  AttackerSituationBuilder toBuilder() =>
      new AttackerSituationBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! AttackerSituation) return false;
    return attackDirection == other.attackDirection &&
        attacker == other.attacker &&
        builtEnemyTargetActionGenerators ==
            other.builtEnemyTargetActionGenerators &&
        builtOtherActorActionGenerators ==
            other.builtOtherActorActionGenerators &&
        id == other.id &&
        name == other.name &&
        target == other.target &&
        time == other.time;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc(0, attackDirection.hashCode),
                                attacker.hashCode),
                            builtEnemyTargetActionGenerators.hashCode),
                        builtOtherActorActionGenerators.hashCode),
                    id.hashCode),
                name.hashCode),
            target.hashCode),
        time.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AttackerSituation')
          ..add('attackDirection', attackDirection)
          ..add('attacker', attacker)
          ..add('builtEnemyTargetActionGenerators',
              builtEnemyTargetActionGenerators)
          ..add('builtOtherActorActionGenerators',
              builtOtherActorActionGenerators)
          ..add('id', id)
          ..add('name', name)
          ..add('target', target)
          ..add('time', time))
        .toString();
  }
}

class AttackerSituationBuilder
    implements Builder<AttackerSituation, AttackerSituationBuilder> {
  _$AttackerSituation _$v;

  AttackDirection _attackDirection;
  AttackDirection get attackDirection => _$this._attackDirection;
  set attackDirection(AttackDirection attackDirection) =>
      _$this._attackDirection = attackDirection;

  int _attacker;
  int get attacker => _$this._attacker;
  set attacker(int attacker) => _$this._attacker = attacker;

  ListBuilder<EnemyTargetActionBuilder> _builtEnemyTargetActionGenerators;
  ListBuilder<EnemyTargetActionBuilder> get builtEnemyTargetActionGenerators =>
      _$this._builtEnemyTargetActionGenerators ??=
          new ListBuilder<EnemyTargetActionBuilder>();
  set builtEnemyTargetActionGenerators(
          ListBuilder<EnemyTargetActionBuilder>
              builtEnemyTargetActionGenerators) =>
      _$this._builtEnemyTargetActionGenerators =
          builtEnemyTargetActionGenerators;

  ListBuilder<OtherActorActionBuilder> _builtOtherActorActionGenerators;
  ListBuilder<OtherActorActionBuilder> get builtOtherActorActionGenerators =>
      _$this._builtOtherActorActionGenerators ??=
          new ListBuilder<OtherActorActionBuilder>();
  set builtOtherActorActionGenerators(
          ListBuilder<OtherActorActionBuilder>
              builtOtherActorActionGenerators) =>
      _$this._builtOtherActorActionGenerators = builtOtherActorActionGenerators;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _target;
  int get target => _$this._target;
  set target(int target) => _$this._target = target;

  int _time;
  int get time => _$this._time;
  set time(int time) => _$this._time = time;

  AttackerSituationBuilder();

  AttackerSituationBuilder get _$this {
    if (_$v != null) {
      _attackDirection = _$v.attackDirection;
      _attacker = _$v.attacker;
      _builtEnemyTargetActionGenerators =
          _$v.builtEnemyTargetActionGenerators?.toBuilder();
      _builtOtherActorActionGenerators =
          _$v.builtOtherActorActionGenerators?.toBuilder();
      _id = _$v.id;
      _name = _$v.name;
      _target = _$v.target;
      _time = _$v.time;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttackerSituation other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$AttackerSituation;
  }

  @override
  void update(void updates(AttackerSituationBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$AttackerSituation build() {
    final _$result = _$v ??
        new _$AttackerSituation._(
            attackDirection: attackDirection,
            attacker: attacker,
            builtEnemyTargetActionGenerators:
                builtEnemyTargetActionGenerators?.build(),
            builtOtherActorActionGenerators:
                builtOtherActorActionGenerators?.build(),
            id: id,
            name: name,
            target: target,
            time: time);
    replace(_$result);
    return _$result;
  }
}
