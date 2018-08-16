// GENERATED CODE - DO NOT MODIFY BY HAND

part of stranded.room_roaming.room_roaming_situation;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first

Serializer<RoomRoamingSituation> _$roomRoamingSituationSerializer =
    new _$RoomRoamingSituationSerializer();

class _$RoomRoamingSituationSerializer
    implements StructuredSerializer<RoomRoamingSituation> {
  @override
  final Iterable<Type> types = const [
    RoomRoamingSituation,
    _$RoomRoamingSituation
  ];
  @override
  final String wireName = 'RoomRoamingSituation';

  @override
  Iterable serialize(Serializers serializers, RoomRoamingSituation object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'currentRoomName',
      serializers.serialize(object.currentRoomName,
          specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'monstersAlive',
      serializers.serialize(object.monstersAlive,
          specifiedType: const FullType(bool)),
      'time',
      serializers.serialize(object.time, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  RoomRoamingSituation deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RoomRoamingSituationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'currentRoomName':
          result.currentRoomName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'monstersAlive':
          result.monstersAlive = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
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

class _$RoomRoamingSituation extends RoomRoamingSituation {
  @override
  final String currentRoomName;
  @override
  final int id;
  @override
  final bool monstersAlive;
  @override
  final int time;

  factory _$RoomRoamingSituation(
          [void updates(RoomRoamingSituationBuilder b)]) =>
      (new RoomRoamingSituationBuilder()..update(updates)).build();

  _$RoomRoamingSituation._(
      {this.currentRoomName, this.id, this.monstersAlive, this.time})
      : super._() {
    if (currentRoomName == null)
      throw new BuiltValueNullFieldError(
          'RoomRoamingSituation', 'currentRoomName');
    if (id == null)
      throw new BuiltValueNullFieldError('RoomRoamingSituation', 'id');
    if (monstersAlive == null)
      throw new BuiltValueNullFieldError(
          'RoomRoamingSituation', 'monstersAlive');
    if (time == null)
      throw new BuiltValueNullFieldError('RoomRoamingSituation', 'time');
  }

  @override
  RoomRoamingSituation rebuild(void updates(RoomRoamingSituationBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  RoomRoamingSituationBuilder toBuilder() =>
      new RoomRoamingSituationBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! RoomRoamingSituation) return false;
    return currentRoomName == other.currentRoomName &&
        id == other.id &&
        monstersAlive == other.monstersAlive &&
        time == other.time;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, currentRoomName.hashCode), id.hashCode),
            monstersAlive.hashCode),
        time.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RoomRoamingSituation')
          ..add('currentRoomName', currentRoomName)
          ..add('id', id)
          ..add('monstersAlive', monstersAlive)
          ..add('time', time))
        .toString();
  }
}

class RoomRoamingSituationBuilder
    implements Builder<RoomRoamingSituation, RoomRoamingSituationBuilder> {
  _$RoomRoamingSituation _$v;

  String _currentRoomName;
  String get currentRoomName => _$this._currentRoomName;
  set currentRoomName(String currentRoomName) =>
      _$this._currentRoomName = currentRoomName;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  bool _monstersAlive;
  bool get monstersAlive => _$this._monstersAlive;
  set monstersAlive(bool monstersAlive) =>
      _$this._monstersAlive = monstersAlive;

  int _time;
  int get time => _$this._time;
  set time(int time) => _$this._time = time;

  RoomRoamingSituationBuilder();

  RoomRoamingSituationBuilder get _$this {
    if (_$v != null) {
      _currentRoomName = _$v.currentRoomName;
      _id = _$v.id;
      _monstersAlive = _$v.monstersAlive;
      _time = _$v.time;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoomRoamingSituation other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$RoomRoamingSituation;
  }

  @override
  void update(void updates(RoomRoamingSituationBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$RoomRoamingSituation build() {
    final _$result = _$v ??
        new _$RoomRoamingSituation._(
            currentRoomName: currentRoomName,
            id: id,
            monstersAlive: monstersAlive,
            time: time);
    replace(_$result);
    return _$result;
  }
}
