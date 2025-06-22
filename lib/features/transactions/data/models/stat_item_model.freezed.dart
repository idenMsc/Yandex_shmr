// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stat_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StatItemModel _$StatItemModelFromJson(Map<String, dynamic> json) {
  return _StatItemModel.fromJson(json);
}

/// @nodoc
mixin _$StatItemModel {
  int get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get emoji => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;

  /// Serializes this StatItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatItemModelCopyWith<StatItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatItemModelCopyWith<$Res> {
  factory $StatItemModelCopyWith(
          StatItemModel value, $Res Function(StatItemModel) then) =
      _$StatItemModelCopyWithImpl<$Res, StatItemModel>;
  @useResult
  $Res call({int categoryId, String categoryName, String emoji, String amount});
}

/// @nodoc
class _$StatItemModelCopyWithImpl<$Res, $Val extends StatItemModel>
    implements $StatItemModelCopyWith<$Res> {
  _$StatItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? emoji = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatItemModelImplCopyWith<$Res>
    implements $StatItemModelCopyWith<$Res> {
  factory _$$StatItemModelImplCopyWith(
          _$StatItemModelImpl value, $Res Function(_$StatItemModelImpl) then) =
      __$$StatItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int categoryId, String categoryName, String emoji, String amount});
}

/// @nodoc
class __$$StatItemModelImplCopyWithImpl<$Res>
    extends _$StatItemModelCopyWithImpl<$Res, _$StatItemModelImpl>
    implements _$$StatItemModelImplCopyWith<$Res> {
  __$$StatItemModelImplCopyWithImpl(
      _$StatItemModelImpl _value, $Res Function(_$StatItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StatItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? categoryName = null,
    Object? emoji = null,
    Object? amount = null,
  }) {
    return _then(_$StatItemModelImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatItemModelImpl implements _StatItemModel {
  const _$StatItemModelImpl(
      {required this.categoryId,
      required this.categoryName,
      required this.emoji,
      required this.amount});

  factory _$StatItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatItemModelImplFromJson(json);

  @override
  final int categoryId;
  @override
  final String categoryName;
  @override
  final String emoji;
  @override
  final String amount;

  @override
  String toString() {
    return 'StatItemModel(categoryId: $categoryId, categoryName: $categoryName, emoji: $emoji, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatItemModelImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryId, categoryName, emoji, amount);

  /// Create a copy of StatItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatItemModelImplCopyWith<_$StatItemModelImpl> get copyWith =>
      __$$StatItemModelImplCopyWithImpl<_$StatItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatItemModelImplToJson(
      this,
    );
  }
}

abstract class _StatItemModel implements StatItemModel {
  const factory _StatItemModel(
      {required final int categoryId,
      required final String categoryName,
      required final String emoji,
      required final String amount}) = _$StatItemModelImpl;

  factory _StatItemModel.fromJson(Map<String, dynamic> json) =
      _$StatItemModelImpl.fromJson;

  @override
  int get categoryId;
  @override
  String get categoryName;
  @override
  String get emoji;
  @override
  String get amount;

  /// Create a copy of StatItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatItemModelImplCopyWith<_$StatItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
