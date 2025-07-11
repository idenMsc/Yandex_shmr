import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/transactions/data/transaction_remote_data_source.dart';
import '../../features/transactions/domain/entities/transaction.dart';

/// Тип действия для differential sync
enum SyncActionType { create, update, delete }

/// Операция для бэкапа
class SyncOperation {
  final SyncActionType type;
  final Transaction transaction;
  SyncOperation({required this.type, required this.transaction});

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'transaction': _transactionToJson(transaction),
      };

  static SyncOperation fromJson(Map<String, dynamic> json) => SyncOperation(
        type: SyncActionType.values.firstWhere((e) => e.name == json['type']),
        transaction: _transactionFromJson(json['transaction']),
      );

  static Map<String, dynamic> _transactionToJson(Transaction t) => {
        'id': t.id,
        'account': {
          'id': t.account.id,
          'name': t.account.name,
          'balance': t.account.balance,
          'currency': t.account.currency,
        },
        'category': {
          'id': t.category.id,
          'name': t.category.name,
          'emoji': t.category.emoji,
          'isIncome': t.category.isIncome,
        },
        'amount': t.amount,
        'transactionDate': t.transactionDate.toIso8601String(),
        'comment': t.comment,
        'createdAt': t.createdAt.toIso8601String(),
        'updatedAt': t.updatedAt.toIso8601String(),
      };

  static Transaction _transactionFromJson(Map<String, dynamic> json) =>
      Transaction(
        id: json['id'],
        account: AccountBrief(
          id: json['account']['id'],
          name: json['account']['name'],
          balance: (json['account']['balance'] as num).toDouble(),
          currency: json['account']['currency'],
        ),
        category: Category(
          id: json['category']['id'],
          name: json['category']['name'],
          emoji: json['category']['emoji'],
          isIncome: json['category']['isIncome'],
        ),
        amount: (json['amount'] as num).toDouble(),
        transactionDate: DateTime.parse(json['transactionDate']),
        comment: json['comment'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}

/// SyncService: differential sync + backup
class SyncService {
  static const _backupKey = 'transaction_sync_backup';
  final SharedPreferences prefs;
  final TransactionRemoteDataSource remoteDataSource;

  SyncService({required this.prefs, required this.remoteDataSource});

  /// Добавить операцию в backup
  Future<void> addToBackup(SyncOperation op) async {
    final list = await _getBackupList();
    // Удаляем дубликаты по id и типу
    list.removeWhere(
        (e) => e.transaction.id == op.transaction.id && e.type == op.type);
    list.add(op);
    await _saveBackupList(list);
  }

  /// Синхронизировать все операции из backup
  Future<void> sync() async {
    final list = await _getBackupList();
    final List<SyncOperation> synced = [];
    for (final op in list) {
      try {
        if (op.type == SyncActionType.create) {
          await remoteDataSource.addTransaction(op.transaction);
        } else if (op.type == SyncActionType.update) {
          // await remoteDataSource.updateTransaction(op.transaction); // реализуй если есть
        } else if (op.type == SyncActionType.delete) {
          // await remoteDataSource.deleteTransaction(op.transaction.id); // реализуй если есть
        }
        synced.add(op);
      } catch (_) {
        // Если не удалось — оставляем в backup
      }
    }
    // Удаляем успешно синхронизированные
    final newList = (await _getBackupList())
      ..removeWhere((e) => synced.contains(e));
    await _saveBackupList(newList);
  }

  /// Получить backup-операции
  Future<List<SyncOperation>> _getBackupList() async {
    final raw = prefs.getStringList(_backupKey) ?? [];
    return raw.map((e) => SyncOperation.fromJson(json.decode(e))).toList();
  }

  /// Сохранить backup-операции
  Future<void> _saveBackupList(List<SyncOperation> list) async {
    final raw = list.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_backupKey, raw);
  }
}
