import 'dart:convert';
import '../../../core/network_service.dart';
import '../domain/entities/transaction.dart';

class TransactionRemoteDataSource {
  final NetworkService networkService;

  TransactionRemoteDataSource({required this.networkService});

  Future<List<Transaction>> getTransactionsByPeriod({
    required int accountId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final path = '/transactions/account/$accountId/period';
    final query = {
      'startDate': startDate.toIso8601String().substring(0, 10),
      'endDate': endDate.toIso8601String().substring(0, 10),
    };
    final data = await networkService.get<List<dynamic>>(path, query: query);
    return data.map((json) => _transactionFromJson(json)).toList();
  }

  Future<void> addTransaction(Transaction transaction) async {
    final path = '/transactions';
    final data = _transactionToJson(transaction);
    print('POST /transactions: $data');
    try {
      await networkService.post(path, data: data);
      print('Транзакция успешно отправлена!');
    } catch (e) {
      print('Ошибка при отправке транзакции: $e');
      rethrow;
    }
  }

  // --- JSON helpers ---
  Transaction _transactionFromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      account: AccountBrief(
        id: json['account']['id'],
        name: json['account']['name'],
        balance: double.tryParse(json['account']['balance'].toString()) ?? 0.0,
        currency: json['account']['currency'],
      ),
      category: Category(
        id: json['category']['id'],
        name: json['category']['name'],
        emoji: json['category']['emoji'],
        isIncome: json['category']['isIncome'],
      ),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      transactionDate: DateTime.parse(json['transactionDate']),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> _transactionToJson(Transaction transaction) {
    return {
      'accountId': transaction.account.id,
      'categoryId': transaction.category.id,
      'amount': transaction.amount.toStringAsFixed(2),
      'transactionDate': transaction.transactionDate.toIso8601String(),
      'comment': transaction.comment,
    };
  }
}
