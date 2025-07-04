part of '../database.dart';

@DataClassName('OperationDbModel')
class OperationTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get apiId => integer().nullable()();

  IntColumn get walletId => integer()();
  IntColumn get groupId => integer()();

  TextColumn get amount => text()();
  DateTimeColumn get operationDate => dateTime()();
  TextColumn get comment => text().nullable()();
}
