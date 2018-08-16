// GENERATED CODE - DO NOT MODIFY BY HAND

part of egamebook.element.lose;

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

Serializer<LoseGame> _$loseGameSerializer = new _$LoseGameSerializer();

class _$LoseGameSerializer implements StructuredSerializer<LoseGame> {
  @override
  final Iterable<Type> types = const [LoseGame, _$LoseGame];
  @override
  final String wireName = 'LoseGame';

  @override
  Iterable serialize(Serializers serializers, LoseGame object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'markdownText',
      serializers.serialize(object.markdownText,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  LoseGame deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LoseGameBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'markdownText':
          result.markdownText = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$LoseGame extends LoseGame {
  @override
  final String markdownText;

  factory _$LoseGame([void updates(LoseGameBuilder b)]) =>
      (new LoseGameBuilder()..update(updates)).build();

  _$LoseGame._({this.markdownText}) : super._() {
    if (markdownText == null)
      throw new BuiltValueNullFieldError('LoseGame', 'markdownText');
  }

  @override
  LoseGame rebuild(void updates(LoseGameBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  LoseGameBuilder toBuilder() => new LoseGameBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! LoseGame) return false;
    return markdownText == other.markdownText;
  }

  @override
  int get hashCode {
    return $jf($jc(0, markdownText.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoseGame')
          ..add('markdownText', markdownText))
        .toString();
  }
}

class LoseGameBuilder implements Builder<LoseGame, LoseGameBuilder> {
  _$LoseGame _$v;

  String _markdownText;
  String get markdownText => _$this._markdownText;
  set markdownText(String markdownText) => _$this._markdownText = markdownText;

  LoseGameBuilder();

  LoseGameBuilder get _$this {
    if (_$v != null) {
      _markdownText = _$v.markdownText;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoseGame other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$LoseGame;
  }

  @override
  void update(void updates(LoseGameBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$LoseGame build() {
    final _$result = _$v ?? new _$LoseGame._(markdownText: markdownText);
    replace(_$result);
    return _$result;
  }
}
