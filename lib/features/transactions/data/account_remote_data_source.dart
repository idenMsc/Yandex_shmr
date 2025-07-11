import 'dart:convert';
import '../../../core/network_service.dart';
import '../domain/entities/account.dart';

class AccountRemoteDataSource {
  final NetworkService networkService;

  AccountRemoteDataSource({required this.networkService});

  Future<List<Account>> getAccounts() async {
    final path = '/accounts';
    print('AccountRemoteDataSource.getAccounts: запрашиваем $path');
    final data = await networkService.get<List<dynamic>>(path);
    print(
        'AccountRemoteDataSource.getAccounts: получено ${data.length} счетов');
    final accounts = data.map((json) => _accountFromJson(json)).toList();
    for (final account in accounts) {
      print(
          'Счет: ID=${account.id}, name=${account.name}, balance=${account.balance}');
    }
    return accounts;
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
