part of '../database.dart';

@DataClassName('WalletDbModel')
class WalletTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get apiId => integer()();
  IntColumn get userId => integer()();

  TextColumn get name => text()();
  TextColumn get balance => text()();
  TextColumn get currency => text()();
}
