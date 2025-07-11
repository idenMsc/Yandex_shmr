import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/transactions/domain/entities/transaction.dart';

enum SyncActionType { create, update, delete }

class SyncOperation {
  final SyncActionType type;
  final Transaction transaction;
  final DateTime createdAt;

  SyncOperation({
    required this.type,
    required this.transaction,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'transaction': _transactionToJson(transaction),
        'createdAt': createdAt.toIso8601String(),
      };

  static SyncOperation fromJson(Map<String, dynamic> json) {
    return SyncOperation(
      type:
          SyncActionType.values.firstWhere((e) => e.toString() == json['type']),
      transaction: _transactionFromJson(json['transaction']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

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

  static Transaction _transactionFromJson(Map<String, dynamic> json) {
    return Transaction(
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

  // Для уникальности: id транзакции + тип действия
  String get uniqueKey => '${type.name}_${transaction.id}';
}

class BackupRepository {
  static const _key = 'transaction_backup_queue';

  Future<List<SyncOperation>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((e) => SyncOperation.fromJson(jsonDecode(e))).toList();
  }

  Future<void> addOrReplace(SyncOperation op) async {
    final list = await getAll();
    // Удаляем дубликаты по uniqueKey
    final filtered = list.where((e) => e.uniqueKey != op.uniqueKey).toList();
    filtered.add(op);
    await _save(filtered);
  }

  Future<void> removeByUniqueKey(String uniqueKey) async {
    final list = await getAll();
    final filtered = list.where((e) => e.uniqueKey != uniqueKey).toList();
    await _save(filtered);
  }

  Future<void> removeManyByUniqueKeys(List<String> keys) async {
    final list = await getAll();
    final filtered = list.where((e) => !keys.contains(e.uniqueKey)).toList();
    await _save(filtered);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> _save(List<SyncOperation> ops) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = ops.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }
}
