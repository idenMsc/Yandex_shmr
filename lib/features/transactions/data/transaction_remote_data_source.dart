import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/entities/transaction.dart';

class TransactionRemoteDataSource {
  final String baseUrl;
  final String token;

  TransactionRemoteDataSource({required this.baseUrl, required this.token});

  Future<List<Transaction>> getTransactionsByPeriod({
    required int accountId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final url = Uri.parse(
        '$baseUrl/transactions/account/$accountId/period?startDate=${startDate.toIso8601String().substring(0, 10)}&endDate=${endDate.toIso8601String().substring(0, 10)}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => _transactionFromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    final url = Uri.parse('$baseUrl/transactions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(_transactionToJson(transaction)),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add transaction');
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
