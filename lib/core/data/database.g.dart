// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WalletTableTable extends WalletTable
    with TableInfo<$WalletTableTable, WalletDbModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _apiIdMeta = const VerificationMeta('apiId');
  @override
  late final GeneratedColumn<int> apiId = GeneratedColumn<int>(
      'api_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balanceMeta =
      const VerificationMeta('balance');
  @override
  late final GeneratedColumn<String> balance = GeneratedColumn<String>(
      'balance', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, apiId, userId, name, balance, currency];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_table';
  @override
  VerificationContext validateIntegrity(Insertable<WalletDbModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('api_id')) {
      context.handle(
          _apiIdMeta, apiId.isAcceptableOrUnknown(data['api_id']!, _apiIdMeta));
    } else if (isInserting) {
      context.missing(_apiIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta,
          balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletDbModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletDbModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      apiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}api_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      balance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}balance'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
    );
  }

  @override
  $WalletTableTable createAlias(String alias) {
    return $WalletTableTable(attachedDatabase, alias);
  }
}

class WalletDbModel extends DataClass implements Insertable<WalletDbModel> {
  final int id;
  final int apiId;
  final int userId;
  final String name;
  final String balance;
  final String currency;
  const WalletDbModel(
      {required this.id,
      required this.apiId,
      required this.userId,
      required this.name,
      required this.balance,
      required this.currency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['api_id'] = Variable<int>(apiId);
    map['user_id'] = Variable<int>(userId);
    map['name'] = Variable<String>(name);
    map['balance'] = Variable<String>(balance);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  WalletTableCompanion toCompanion(bool nullToAbsent) {
    return WalletTableCompanion(
      id: Value(id),
      apiId: Value(apiId),
      userId: Value(userId),
      name: Value(name),
      balance: Value(balance),
      currency: Value(currency),
    );
  }

  factory WalletDbModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletDbModel(
      id: serializer.fromJson<int>(json['id']),
      apiId: serializer.fromJson<int>(json['apiId']),
      userId: serializer.fromJson<int>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      balance: serializer.fromJson<String>(json['balance']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apiId': serializer.toJson<int>(apiId),
      'userId': serializer.toJson<int>(userId),
      'name': serializer.toJson<String>(name),
      'balance': serializer.toJson<String>(balance),
      'currency': serializer.toJson<String>(currency),
    };
  }

  WalletDbModel copyWith(
          {int? id,
          int? apiId,
          int? userId,
          String? name,
          String? balance,
          String? currency}) =>
      WalletDbModel(
        id: id ?? this.id,
        apiId: apiId ?? this.apiId,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        balance: balance ?? this.balance,
        currency: currency ?? this.currency,
      );
  WalletDbModel copyWithCompanion(WalletTableCompanion data) {
    return WalletDbModel(
      id: data.id.present ? data.id.value : this.id,
      apiId: data.apiId.present ? data.apiId.value : this.apiId,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      balance: data.balance.present ? data.balance.value : this.balance,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletDbModel(')
          ..write('id: $id, ')
          ..write('apiId: $apiId, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, apiId, userId, name, balance, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletDbModel &&
          other.id == this.id &&
          other.apiId == this.apiId &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.balance == this.balance &&
          other.currency == this.currency);
}

class WalletTableCompanion extends UpdateCompanion<WalletDbModel> {
  final Value<int> id;
  final Value<int> apiId;
  final Value<int> userId;
  final Value<String> name;
  final Value<String> balance;
  final Value<String> currency;
  const WalletTableCompanion({
    this.id = const Value.absent(),
    this.apiId = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
  });
  WalletTableCompanion.insert({
    this.id = const Value.absent(),
    required int apiId,
    required int userId,
    required String name,
    required String balance,
    required String currency,
  })  : apiId = Value(apiId),
        userId = Value(userId),
        name = Value(name),
        balance = Value(balance),
        currency = Value(currency);
  static Insertable<WalletDbModel> custom({
    Expression<int>? id,
    Expression<int>? apiId,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<String>? balance,
    Expression<String>? currency,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apiId != null) 'api_id': apiId,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
    });
  }

  WalletTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? apiId,
      Value<int>? userId,
      Value<String>? name,
      Value<String>? balance,
      Value<String>? currency}) {
    return WalletTableCompanion(
      id: id ?? this.id,
      apiId: apiId ?? this.apiId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apiId.present) {
      map['api_id'] = Variable<int>(apiId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (balance.present) {
      map['balance'] = Variable<String>(balance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletTableCompanion(')
          ..write('id: $id, ')
          ..write('apiId: $apiId, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }
}

class $OperationTableTable extends OperationTable
    with TableInfo<$OperationTableTable, OperationDbModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OperationTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _apiIdMeta = const VerificationMeta('apiId');
  @override
  late final GeneratedColumn<int> apiId = GeneratedColumn<int>(
      'api_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _walletIdMeta =
      const VerificationMeta('walletId');
  @override
  late final GeneratedColumn<int> walletId = GeneratedColumn<int>(
      'wallet_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
      'amount', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationDateMeta =
      const VerificationMeta('operationDate');
  @override
  late final GeneratedColumn<DateTime> operationDate =
      GeneratedColumn<DateTime>('operation_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, apiId, walletId, groupId, amount, operationDate, comment];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operation_table';
  @override
  VerificationContext validateIntegrity(Insertable<OperationDbModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('api_id')) {
      context.handle(
          _apiIdMeta, apiId.isAcceptableOrUnknown(data['api_id']!, _apiIdMeta));
    }
    if (data.containsKey('wallet_id')) {
      context.handle(_walletIdMeta,
          walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta));
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('operation_date')) {
      context.handle(
          _operationDateMeta,
          operationDate.isAcceptableOrUnknown(
              data['operation_date']!, _operationDateMeta));
    } else if (isInserting) {
      context.missing(_operationDateMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OperationDbModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OperationDbModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      apiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}api_id']),
      walletId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wallet_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}amount'])!,
      operationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}operation_date'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
    );
  }

  @override
  $OperationTableTable createAlias(String alias) {
    return $OperationTableTable(attachedDatabase, alias);
  }
}

class OperationDbModel extends DataClass
    implements Insertable<OperationDbModel> {
  final int id;
  final int? apiId;
  final int walletId;
  final int groupId;
  final String amount;
  final DateTime operationDate;
  final String? comment;
  const OperationDbModel(
      {required this.id,
      this.apiId,
      required this.walletId,
      required this.groupId,
      required this.amount,
      required this.operationDate,
      this.comment});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || apiId != null) {
      map['api_id'] = Variable<int>(apiId);
    }
    map['wallet_id'] = Variable<int>(walletId);
    map['group_id'] = Variable<int>(groupId);
    map['amount'] = Variable<String>(amount);
    map['operation_date'] = Variable<DateTime>(operationDate);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  OperationTableCompanion toCompanion(bool nullToAbsent) {
    return OperationTableCompanion(
      id: Value(id),
      apiId:
          apiId == null && nullToAbsent ? const Value.absent() : Value(apiId),
      walletId: Value(walletId),
      groupId: Value(groupId),
      amount: Value(amount),
      operationDate: Value(operationDate),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory OperationDbModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OperationDbModel(
      id: serializer.fromJson<int>(json['id']),
      apiId: serializer.fromJson<int?>(json['apiId']),
      walletId: serializer.fromJson<int>(json['walletId']),
      groupId: serializer.fromJson<int>(json['groupId']),
      amount: serializer.fromJson<String>(json['amount']),
      operationDate: serializer.fromJson<DateTime>(json['operationDate']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apiId': serializer.toJson<int?>(apiId),
      'walletId': serializer.toJson<int>(walletId),
      'groupId': serializer.toJson<int>(groupId),
      'amount': serializer.toJson<String>(amount),
      'operationDate': serializer.toJson<DateTime>(operationDate),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  OperationDbModel copyWith(
          {int? id,
          Value<int?> apiId = const Value.absent(),
          int? walletId,
          int? groupId,
          String? amount,
          DateTime? operationDate,
          Value<String?> comment = const Value.absent()}) =>
      OperationDbModel(
        id: id ?? this.id,
        apiId: apiId.present ? apiId.value : this.apiId,
        walletId: walletId ?? this.walletId,
        groupId: groupId ?? this.groupId,
        amount: amount ?? this.amount,
        operationDate: operationDate ?? this.operationDate,
        comment: comment.present ? comment.value : this.comment,
      );
  OperationDbModel copyWithCompanion(OperationTableCompanion data) {
    return OperationDbModel(
      id: data.id.present ? data.id.value : this.id,
      apiId: data.apiId.present ? data.apiId.value : this.apiId,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      amount: data.amount.present ? data.amount.value : this.amount,
      operationDate: data.operationDate.present
          ? data.operationDate.value
          : this.operationDate,
      comment: data.comment.present ? data.comment.value : this.comment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OperationDbModel(')
          ..write('id: $id, ')
          ..write('apiId: $apiId, ')
          ..write('walletId: $walletId, ')
          ..write('groupId: $groupId, ')
          ..write('amount: $amount, ')
          ..write('operationDate: $operationDate, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, apiId, walletId, groupId, amount, operationDate, comment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OperationDbModel &&
          other.id == this.id &&
          other.apiId == this.apiId &&
          other.walletId == this.walletId &&
          other.groupId == this.groupId &&
          other.amount == this.amount &&
          other.operationDate == this.operationDate &&
          other.comment == this.comment);
}

class OperationTableCompanion extends UpdateCompanion<OperationDbModel> {
  final Value<int> id;
  final Value<int?> apiId;
  final Value<int> walletId;
  final Value<int> groupId;
  final Value<String> amount;
  final Value<DateTime> operationDate;
  final Value<String?> comment;
  const OperationTableCompanion({
    this.id = const Value.absent(),
    this.apiId = const Value.absent(),
    this.walletId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.amount = const Value.absent(),
    this.operationDate = const Value.absent(),
    this.comment = const Value.absent(),
  });
  OperationTableCompanion.insert({
    this.id = const Value.absent(),
    this.apiId = const Value.absent(),
    required int walletId,
    required int groupId,
    required String amount,
    required DateTime operationDate,
    this.comment = const Value.absent(),
  })  : walletId = Value(walletId),
        groupId = Value(groupId),
        amount = Value(amount),
        operationDate = Value(operationDate);
  static Insertable<OperationDbModel> custom({
    Expression<int>? id,
    Expression<int>? apiId,
    Expression<int>? walletId,
    Expression<int>? groupId,
    Expression<String>? amount,
    Expression<DateTime>? operationDate,
    Expression<String>? comment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apiId != null) 'api_id': apiId,
      if (walletId != null) 'wallet_id': walletId,
      if (groupId != null) 'group_id': groupId,
      if (amount != null) 'amount': amount,
      if (operationDate != null) 'operation_date': operationDate,
      if (comment != null) 'comment': comment,
    });
  }

  OperationTableCompanion copyWith(
      {Value<int>? id,
      Value<int?>? apiId,
      Value<int>? walletId,
      Value<int>? groupId,
      Value<String>? amount,
      Value<DateTime>? operationDate,
      Value<String?>? comment}) {
    return OperationTableCompanion(
      id: id ?? this.id,
      apiId: apiId ?? this.apiId,
      walletId: walletId ?? this.walletId,
      groupId: groupId ?? this.groupId,
      amount: amount ?? this.amount,
      operationDate: operationDate ?? this.operationDate,
      comment: comment ?? this.comment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apiId.present) {
      map['api_id'] = Variable<int>(apiId.value);
    }
    if (walletId.present) {
      map['wallet_id'] = Variable<int>(walletId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (operationDate.present) {
      map['operation_date'] = Variable<DateTime>(operationDate.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OperationTableCompanion(')
          ..write('id: $id, ')
          ..write('apiId: $apiId, ')
          ..write('walletId: $walletId, ')
          ..write('groupId: $groupId, ')
          ..write('amount: $amount, ')
          ..write('operationDate: $operationDate, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }
}

class $GroupTableTable extends GroupTable
    with TableInfo<$GroupTableTable, GroupDbModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _apiIdMeta = const VerificationMeta('apiId');
  @override
  late final GeneratedColumn<int> apiId = GeneratedColumn<int>(
      'api_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isIncomeMeta =
      const VerificationMeta('isIncome');
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
      'is_income', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_income" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, apiId, name, emoji, isIncome];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_table';
  @override
  VerificationContext validateIntegrity(Insertable<GroupDbModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('api_id')) {
      context.handle(
          _apiIdMeta, apiId.isAcceptableOrUnknown(data['api_id']!, _apiIdMeta));
    } else if (isInserting) {
      context.missing(_apiIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(_isIncomeMeta,
          isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta));
    } else if (isInserting) {
      context.missing(_isIncomeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupDbModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupDbModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      apiId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}api_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      isIncome: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_income'])!,
    );
  }

  @override
  $GroupTableTable createAlias(String alias) {
    return $GroupTableTable(attachedDatabase, alias);
  }
}

class GroupDbModel extends DataClass implements Insertable<GroupDbModel> {
  final int id;
  final int apiId;
  final String name;
  final String emoji;
  final bool isIncome;
  const GroupDbModel(
      {required this.id,
      required this.apiId,
      required this.name,
      required this.emoji,
      required this.isIncome});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['api_id'] = Variable<int>(apiId);
    map['name'] = Variable<String>(name);
    map['emoji'] = Variable<String>(emoji);
    map['is_income'] = Variable<bool>(isIncome);
    return map;
  }

  GroupTableCompanion toCompanion(bool nullToAbsent) {
    return GroupTableCompanion(
      id: Value(id),
      apiId: Value(apiId),
      name: Value(name),
      emoji: Value(emoji),
      isIncome: Value(isIncome),
    );
  }

  factory GroupDbModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupDbModel(
      id: serializer.fromJson<int>(json['id']),
      apiId: serializer.fromJson<int>(json['apiId']),
      name: serializer.fromJson<String>(json['name']),
      emoji: serializer.fromJson<String>(json['emoji']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'apiId': serializer.toJson<int>(apiId),
      'name': serializer.toJson<String>(name),
      'emoji': serializer.toJson<String>(emoji),
      'isIncome': serializer.toJson<bool>(isIncome),
    };
  }

  GroupDbModel copyWith(
          {int? id, int? apiId, String? name, String? emoji, bool? isIncome}) =>
      GroupDbModel(
        id: id ?? this.id,
        apiId: apiId ?? this.apiId,
        name: name ?? this.name,
        emoji: emoji ?? this.emoji,
        isIncome: isIncome ?? this.isIncome,
      );
  GroupDbModel copyWithCompanion(GroupTableCompanion data) {
    return GroupDbModel(
      id: data.id.present ? data.id.value : this.id,
      apiId: data.apiId.present ? data.apiId.value : this.apiId,
      name: data.name.present ? data.name.value : this.name,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupDbModel(')
          ..write('id: $id, ')
          ..write('apiId: $apiId, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('isIncome: $isIncome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, apiId, name, emoji, isIncome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupDbModel &&
          other.id == this.id &&
          other.apiId == this.apiId &&
          other.name == this.name &&
          other.emoji == this.emoji &&
          other.isIncome == this.isIncome);
}

class GroupTableCompanion extends UpdateCompanion<GroupDbModel> {
  final Value<int> id;
  final Value<int> apiId;
  final Value<String> name;
  final Value<String> emoji;
  final Value<bool> isIncome;
  const GroupTableCompanion({
    this.id = const Value.absent(),
    this.apiId = const Value.absent(),
    this.name = const Value.absent(),
    this.emoji = const Value.absent(),
    this.isIncome = const Value.absent(),
  });
  GroupTableCompanion.insert({
    this.id = const Value.absent(),
    required int apiId,
    required String name,
    required String emoji,
    required bool isIncome,
  })  : apiId = Value(apiId),
        name = Value(name),
        emoji = Value(emoji),
        isIncome = Value(isIncome);
  static Insertable<GroupDbModel> custom({
    Expression<int>? id,
    Expression<int>? apiId,
    Expression<String>? name,
    Expression<String>? emoji,
    Expression<bool>? isIncome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (apiId != null) 'api_id': apiId,
      if (name != null) 'name': name,
      if (emoji != null) 'emoji': emoji,
      if (isIncome != null) 'is_income': isIncome,
    });
  }

  GroupTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? apiId,
      Value<String>? name,
      Value<String>? emoji,
      Value<bool>? isIncome}) {
    return GroupTableCompanion(
      id: id ?? this.id,
      apiId: apiId ?? this.apiId,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      isIncome: isIncome ?? this.isIncome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (apiId.present) {
      map['api_id'] = Variable<int>(apiId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupTableCompanion(')
          ..write('id: $id, ')
          ..write('apiId: $apiId, ')
          ..write('name: $name, ')
          ..write('emoji: $emoji, ')
          ..write('isIncome: $isIncome')
          ..write(')'))
        .toString();
  }
}

abstract class _$FinanceDatabase extends GeneratedDatabase {
  _$FinanceDatabase(QueryExecutor e) : super(e);
  $FinanceDatabaseManager get managers => $FinanceDatabaseManager(this);
  late final $WalletTableTable walletTable = $WalletTableTable(this);
  late final $OperationTableTable operationTable = $OperationTableTable(this);
  late final $GroupTableTable groupTable = $GroupTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [walletTable, operationTable, groupTable];
}

typedef $$WalletTableTableCreateCompanionBuilder = WalletTableCompanion
    Function({
  Value<int> id,
  required int apiId,
  required int userId,
  required String name,
  required String balance,
  required String currency,
});
typedef $$WalletTableTableUpdateCompanionBuilder = WalletTableCompanion
    Function({
  Value<int> id,
  Value<int> apiId,
  Value<int> userId,
  Value<String> name,
  Value<String> balance,
  Value<String> currency,
});

class $$WalletTableTableFilterComposer
    extends Composer<_$FinanceDatabase, $WalletTableTable> {
  $$WalletTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get apiId => $composableBuilder(
      column: $table.apiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));
}

class $$WalletTableTableOrderingComposer
    extends Composer<_$FinanceDatabase, $WalletTableTable> {
  $$WalletTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get apiId => $composableBuilder(
      column: $table.apiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get balance => $composableBuilder(
      column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));
}

class $$WalletTableTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $WalletTableTable> {
  $$WalletTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get apiId =>
      $composableBuilder(column: $table.apiId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);
}

class $$WalletTableTableTableManager extends RootTableManager<
    _$FinanceDatabase,
    $WalletTableTable,
    WalletDbModel,
    $$WalletTableTableFilterComposer,
    $$WalletTableTableOrderingComposer,
    $$WalletTableTableAnnotationComposer,
    $$WalletTableTableCreateCompanionBuilder,
    $$WalletTableTableUpdateCompanionBuilder,
    (
      WalletDbModel,
      BaseReferences<_$FinanceDatabase, $WalletTableTable, WalletDbModel>
    ),
    WalletDbModel,
    PrefetchHooks Function()> {
  $$WalletTableTableTableManager(_$FinanceDatabase db, $WalletTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> apiId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> balance = const Value.absent(),
            Value<String> currency = const Value.absent(),
          }) =>
              WalletTableCompanion(
            id: id,
            apiId: apiId,
            userId: userId,
            name: name,
            balance: balance,
            currency: currency,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int apiId,
            required int userId,
            required String name,
            required String balance,
            required String currency,
          }) =>
              WalletTableCompanion.insert(
            id: id,
            apiId: apiId,
            userId: userId,
            name: name,
            balance: balance,
            currency: currency,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WalletTableTableProcessedTableManager = ProcessedTableManager<
    _$FinanceDatabase,
    $WalletTableTable,
    WalletDbModel,
    $$WalletTableTableFilterComposer,
    $$WalletTableTableOrderingComposer,
    $$WalletTableTableAnnotationComposer,
    $$WalletTableTableCreateCompanionBuilder,
    $$WalletTableTableUpdateCompanionBuilder,
    (
      WalletDbModel,
      BaseReferences<_$FinanceDatabase, $WalletTableTable, WalletDbModel>
    ),
    WalletDbModel,
    PrefetchHooks Function()>;
typedef $$OperationTableTableCreateCompanionBuilder = OperationTableCompanion
    Function({
  Value<int> id,
  Value<int?> apiId,
  required int walletId,
  required int groupId,
  required String amount,
  required DateTime operationDate,
  Value<String?> comment,
});
typedef $$OperationTableTableUpdateCompanionBuilder = OperationTableCompanion
    Function({
  Value<int> id,
  Value<int?> apiId,
  Value<int> walletId,
  Value<int> groupId,
  Value<String> amount,
  Value<DateTime> operationDate,
  Value<String?> comment,
});

class $$OperationTableTableFilterComposer
    extends Composer<_$FinanceDatabase, $OperationTableTable> {
  $$OperationTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get apiId => $composableBuilder(
      column: $table.apiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get walletId => $composableBuilder(
      column: $table.walletId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get operationDate => $composableBuilder(
      column: $table.operationDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnFilters(column));
}

class $$OperationTableTableOrderingComposer
    extends Composer<_$FinanceDatabase, $OperationTableTable> {
  $$OperationTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get apiId => $composableBuilder(
      column: $table.apiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get walletId => $composableBuilder(
      column: $table.walletId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get operationDate => $composableBuilder(
      column: $table.operationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get comment => $composableBuilder(
      column: $table.comment, builder: (column) => ColumnOrderings(column));
}

class $$OperationTableTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $OperationTableTable> {
  $$OperationTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get apiId =>
      $composableBuilder(column: $table.apiId, builder: (column) => column);

  GeneratedColumn<int> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<int> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get operationDate => $composableBuilder(
      column: $table.operationDate, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);
}

class $$OperationTableTableTableManager extends RootTableManager<
    _$FinanceDatabase,
    $OperationTableTable,
    OperationDbModel,
    $$OperationTableTableFilterComposer,
    $$OperationTableTableOrderingComposer,
    $$OperationTableTableAnnotationComposer,
    $$OperationTableTableCreateCompanionBuilder,
    $$OperationTableTableUpdateCompanionBuilder,
    (
      OperationDbModel,
      BaseReferences<_$FinanceDatabase, $OperationTableTable, OperationDbModel>
    ),
    OperationDbModel,
    PrefetchHooks Function()> {
  $$OperationTableTableTableManager(
      _$FinanceDatabase db, $OperationTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OperationTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OperationTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OperationTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> apiId = const Value.absent(),
            Value<int> walletId = const Value.absent(),
            Value<int> groupId = const Value.absent(),
            Value<String> amount = const Value.absent(),
            Value<DateTime> operationDate = const Value.absent(),
            Value<String?> comment = const Value.absent(),
          }) =>
              OperationTableCompanion(
            id: id,
            apiId: apiId,
            walletId: walletId,
            groupId: groupId,
            amount: amount,
            operationDate: operationDate,
            comment: comment,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> apiId = const Value.absent(),
            required int walletId,
            required int groupId,
            required String amount,
            required DateTime operationDate,
            Value<String?> comment = const Value.absent(),
          }) =>
              OperationTableCompanion.insert(
            id: id,
            apiId: apiId,
            walletId: walletId,
            groupId: groupId,
            amount: amount,
            operationDate: operationDate,
            comment: comment,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OperationTableTableProcessedTableManager = ProcessedTableManager<
    _$FinanceDatabase,
    $OperationTableTable,
    OperationDbModel,
    $$OperationTableTableFilterComposer,
    $$OperationTableTableOrderingComposer,
    $$OperationTableTableAnnotationComposer,
    $$OperationTableTableCreateCompanionBuilder,
    $$OperationTableTableUpdateCompanionBuilder,
    (
      OperationDbModel,
      BaseReferences<_$FinanceDatabase, $OperationTableTable, OperationDbModel>
    ),
    OperationDbModel,
    PrefetchHooks Function()>;
typedef $$GroupTableTableCreateCompanionBuilder = GroupTableCompanion Function({
  Value<int> id,
  required int apiId,
  required String name,
  required String emoji,
  required bool isIncome,
});
typedef $$GroupTableTableUpdateCompanionBuilder = GroupTableCompanion Function({
  Value<int> id,
  Value<int> apiId,
  Value<String> name,
  Value<String> emoji,
  Value<bool> isIncome,
});

class $$GroupTableTableFilterComposer
    extends Composer<_$FinanceDatabase, $GroupTableTable> {
  $$GroupTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get apiId => $composableBuilder(
      column: $table.apiId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnFilters(column));
}

class $$GroupTableTableOrderingComposer
    extends Composer<_$FinanceDatabase, $GroupTableTable> {
  $$GroupTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get apiId => $composableBuilder(
      column: $table.apiId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnOrderings(column));
}

class $$GroupTableTableAnnotationComposer
    extends Composer<_$FinanceDatabase, $GroupTableTable> {
  $$GroupTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get apiId =>
      $composableBuilder(column: $table.apiId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);
}

class $$GroupTableTableTableManager extends RootTableManager<
    _$FinanceDatabase,
    $GroupTableTable,
    GroupDbModel,
    $$GroupTableTableFilterComposer,
    $$GroupTableTableOrderingComposer,
    $$GroupTableTableAnnotationComposer,
    $$GroupTableTableCreateCompanionBuilder,
    $$GroupTableTableUpdateCompanionBuilder,
    (
      GroupDbModel,
      BaseReferences<_$FinanceDatabase, $GroupTableTable, GroupDbModel>
    ),
    GroupDbModel,
    PrefetchHooks Function()> {
  $$GroupTableTableTableManager(_$FinanceDatabase db, $GroupTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> apiId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<bool> isIncome = const Value.absent(),
          }) =>
              GroupTableCompanion(
            id: id,
            apiId: apiId,
            name: name,
            emoji: emoji,
            isIncome: isIncome,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int apiId,
            required String name,
            required String emoji,
            required bool isIncome,
          }) =>
              GroupTableCompanion.insert(
            id: id,
            apiId: apiId,
            name: name,
            emoji: emoji,
            isIncome: isIncome,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GroupTableTableProcessedTableManager = ProcessedTableManager<
    _$FinanceDatabase,
    $GroupTableTable,
    GroupDbModel,
    $$GroupTableTableFilterComposer,
    $$GroupTableTableOrderingComposer,
    $$GroupTableTableAnnotationComposer,
    $$GroupTableTableCreateCompanionBuilder,
    $$GroupTableTableUpdateCompanionBuilder,
    (
      GroupDbModel,
      BaseReferences<_$FinanceDatabase, $GroupTableTable, GroupDbModel>
    ),
    GroupDbModel,
    PrefetchHooks Function()>;

class $FinanceDatabaseManager {
  final _$FinanceDatabase _db;
  $FinanceDatabaseManager(this._db);
  $$WalletTableTableTableManager get walletTable =>
      $$WalletTableTableTableManager(_db, _db.walletTable);
  $$OperationTableTableTableManager get operationTable =>
      $$OperationTableTableTableManager(_db, _db.operationTable);
  $$GroupTableTableTableManager get groupTable =>
      $$GroupTableTableTableManager(_db, _db.groupTable);
}
