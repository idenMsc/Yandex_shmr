import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network_service.dart';
import '../domain/entities/account.dart';

class AccountRemoteDataSource {
  final NetworkService networkService;

  AccountRemoteDataSource({required this.networkService});

  Future<List<Account>> getAccounts() async {
    final path = '/accounts';
    print('AccountRemoteDataSource.getAccounts: запрашиваем $path');
    try {
      final data = await networkService.get<List<dynamic>>(path);
      print(
          'AccountRemoteDataSource.getAccounts: получено  [32m${data.length} [0m счетов');
      final accounts = data.map((json) => _accountFromJson(json)).toList();
      for (final account in accounts) {
        print(
            'Счет: ID=${account.id}, name=${account.name}, balance=${account.balance}');
      }
      await _saveToCache(accounts);
      return accounts;
    } catch (e) {
      print(
          'AccountRemoteDataSource.getAccounts: ошибка сети, пробуем из кэша ($e)');
      final cached = await _loadFromCache();
      if (cached.isNotEmpty) {
        print(
            'AccountRemoteDataSource.getAccounts: возвращаем счета из кэша (${cached.length})');
        return cached;
      } else {
        print('AccountRemoteDataSource.getAccounts: кэш пустой, rethrow');
        rethrow;
      }
    }
  }

  Future<void> _saveToCache(List<Account> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList =
        accounts.map((a) => jsonEncode(_accountToJson(a))).toList();
    await prefs.setStringList('accounts_cache', jsonList);
  }

  Future<List<Account>> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('accounts_cache') ?? [];
    return jsonList.map((j) => _accountFromJson(jsonDecode(j))).toList();
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

  Map<String, dynamic> _accountToJson(Account a) => {
        'id': a.id,
        'userId': a.userId,
        'name': a.name,
        'balance': a.balance,
        'currency': a.currency,
        'createdAt': a.createdAt.toIso8601String(),
        'updatedAt': a.updatedAt.toIso8601String(),
      };
}
