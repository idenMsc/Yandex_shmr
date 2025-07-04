part of '../database.dart';

@DataClassName('GroupDbModel')
class GroupTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get apiId => integer()();

  TextColumn get name => text()();
  TextColumn get emoji => text()();
  BoolColumn get isIncome => boolean()();
}
