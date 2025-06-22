import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/entities/account.dart';

class AccountRemoteDataSource {
  final String baseUrl;
  final String token;

  AccountRemoteDataSource({required this.baseUrl, required this.token});

  Future<List<Account>> getAccounts() async {
    final url = Uri.parse('$baseUrl/accounts');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => _accountFromJson(json)).toList();
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  Account _accountFromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
      currency: json['currency'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
