// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccountResponseModel _$AccountResponseModelFromJson(Map<String, dynamic> json) {
  return _AccountResponseModel.fromJson(json);
}

/// @nodoc
mixin _$AccountResponseModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  List<StatItemModel> get incomeStats => throw _privateConstructorUsedError;
  List<StatItemModel> get expenseStats => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AccountResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountResponseModelCopyWith<AccountResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountResponseModelCopyWith<$Res> {
  factory $AccountResponseModelCopyWith(AccountResponseModel value,
          $Res Function(AccountResponseModel) then) =
      _$AccountResponseModelCopyWithImpl<$Res, AccountResponseModel>;
  @useResult
  $Res call(
      {int id,
      String name,
      String balance,
      String currency,
      List<StatItemModel> incomeStats,
      List<StatItemModel> expenseStats,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$AccountResponseModelCopyWithImpl<$Res,
        $Val extends AccountResponseModel>
    implements $AccountResponseModelCopyWith<$Res> {
  _$AccountResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? balance = null,
    Object? currency = null,
    Object? incomeStats = null,
    Object? expenseStats = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      incomeStats: null == incomeStats
          ? _value.incomeStats
          : incomeStats // ignore: cast_nullable_to_non_nullable
              as List<StatItemModel>,
      expenseStats: null == expenseStats
          ? _value.expenseStats
          : expenseStats // ignore: cast_nullable_to_non_nullable
              as List<StatItemModel>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountResponseModelImplCopyWith<$Res>
    implements $AccountResponseModelCopyWith<$Res> {
  factory _$$AccountResponseModelImplCopyWith(_$AccountResponseModelImpl value,
          $Res Function(_$AccountResponseModelImpl) then) =
      __$$AccountResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String balance,
      String currency,
      List<StatItemModel> incomeStats,
      List<StatItemModel> expenseStats,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$AccountResponseModelImplCopyWithImpl<$Res>
    extends _$AccountResponseModelCopyWithImpl<$Res, _$AccountResponseModelImpl>
    implements _$$AccountResponseModelImplCopyWith<$Res> {
  __$$AccountResponseModelImplCopyWithImpl(_$AccountResponseModelImpl _value,
      $Res Function(_$AccountResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? balance = null,
    Object? currency = null,
    Object? incomeStats = null,
    Object? expenseStats = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AccountResponseModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      incomeStats: null == incomeStats
          ? _value._incomeStats
          : incomeStats // ignore: cast_nullable_to_non_nullable
              as List<StatItemModel>,
      expenseStats: null == expenseStats
          ? _value._expenseStats
          : expenseStats // ignore: cast_nullable_to_non_nullable
              as List<StatItemModel>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountResponseModelImpl implements _AccountResponseModel {
  const _$AccountResponseModelImpl(
      {required this.id,
      required this.name,
      required this.balance,
      required this.currency,
      required final List<StatItemModel> incomeStats,
      required final List<StatItemModel> expenseStats,
      required this.createdAt,
      required this.updatedAt})
      : _incomeStats = incomeStats,
        _expenseStats = expenseStats;

  factory _$AccountResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountResponseModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String balance;
  @override
  final String currency;
  final List<StatItemModel> _incomeStats;
  @override
  List<StatItemModel> get incomeStats {
    if (_incomeStats is EqualUnmodifiableListView) return _incomeStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incomeStats);
  }

  final List<StatItemModel> _expenseStats;
  @override
  List<StatItemModel> get expenseStats {
    if (_expenseStats is EqualUnmodifiableListView) return _expenseStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenseStats);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AccountResponseModel(id: $id, name: $name, balance: $balance, currency: $currency, incomeStats: $incomeStats, expenseStats: $expenseStats, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountResponseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality()
                .equals(other._incomeStats, _incomeStats) &&
            const DeepCollectionEquality()
                .equals(other._expenseStats, _expenseStats) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      balance,
      currency,
      const DeepCollectionEquality().hash(_incomeStats),
      const DeepCollectionEquality().hash(_expenseStats),
      createdAt,
      updatedAt);

  /// Create a copy of AccountResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountResponseModelImplCopyWith<_$AccountResponseModelImpl>
      get copyWith =>
          __$$AccountResponseModelImplCopyWithImpl<_$AccountResponseModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountResponseModelImplToJson(
      this,
    );
  }
}

abstract class _AccountResponseModel implements AccountResponseModel {
  const factory _AccountResponseModel(
      {required final int id,
      required final String name,
      required final String balance,
      required final String currency,
      required final List<StatItemModel> incomeStats,
      required final List<StatItemModel> expenseStats,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$AccountResponseModelImpl;

  factory _AccountResponseModel.fromJson(Map<String, dynamic> json) =
      _$AccountResponseModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get balance;
  @override
  String get currency;
  @override
  List<StatItemModel> get incomeStats;
  @override
  List<StatItemModel> get expenseStats;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of AccountResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountResponseModelImplCopyWith<_$AccountResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
