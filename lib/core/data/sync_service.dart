import 'dart:convert';
import 'package:dio/dio.dart';
import '../../features/transactions/domain/entities/transaction.dart';
import 'backup_repository.dart';

/// SyncService: differential sync + backup
class SyncService {
  final Dio _dio;
  final BackupRepository _backupRepository;

  SyncService(this._dio, this._backupRepository);

  /// Sync all pending operations with the server
  Future<bool> syncPendingOperations() async {
    try {
      final pendingOperations = await _backupRepository.getAll();

      if (pendingOperations.isEmpty) {
        print('[SyncService] No pending operations to sync');
        return true;
      }

      print(
          '[SyncService] Syncing ${pendingOperations.length} pending operations');

      for (final operation in pendingOperations) {
        final success = await _syncOperation(operation);
        if (success) {
          await _backupRepository.removeByUniqueKey(operation.uniqueKey);
          print(
              '[SyncService] Successfully synced operation ${operation.uniqueKey}');
        } else {
          print(
              '[SyncService] Failed to sync operation ${operation.uniqueKey}');
        }
      }

      return true;
    } catch (e) {
      print('[SyncService] Error during sync: $e');
      return false;
    }
  }

  /// Sync a single operation with the server
  Future<bool> _syncOperation(SyncOperation operation) async {
    try {
      switch (operation.type) {
        case SyncActionType.create:
          return await _syncCreateOperation(operation);
        case SyncActionType.update:
          return await _syncUpdateOperation(operation);
        case SyncActionType.delete:
          return await _syncDeleteOperation(operation);
      }
    } catch (e) {
      print(
          '[SyncService] Error syncing operation ${operation.transaction.id}: $e');
      return false;
    }
  }

  /// Sync a create operation
  Future<bool> _syncCreateOperation(SyncOperation operation) async {
    try {
      final transactionData = _transactionToJson(operation.transaction);

      final response = await _dio.post(
        '/transactions',
        data: transactionData,
      );

      return response.statusCode == 201;
    } catch (e) {
      print('[SyncService] Error in create sync: $e');
      return false;
    }
  }

  /// Sync an update operation
  Future<bool> _syncUpdateOperation(SyncOperation operation) async {
    try {
      final transactionData = _transactionToJson(operation.transaction);

      final response = await _dio.put(
        '/transactions/${operation.transaction.id}',
        data: transactionData,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('[SyncService] Error in update sync: $e');
      return false;
    }
  }

  /// Sync a delete operation
  Future<bool> _syncDeleteOperation(SyncOperation operation) async {
    try {
      final response = await _dio.delete(
        '/transactions/${operation.transaction.id}',
      );

      return response.statusCode == 204;
    } catch (e) {
      print('[SyncService] Error in delete sync: $e');
      return false;
    }
  }

  /// Convert transaction to JSON for API
  Map<String, dynamic> _transactionToJson(Transaction t) => {
        'id': t.id,
        'accountId': t.account.id,
        'categoryId': t.category.id,
        'amount': t.amount,
        'transactionDate': t.transactionDate.toIso8601String(),
        'comment': t.comment,
      };
}
