import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {
  final bool isIncome;
  const LoadTransactionsEvent({required this.isIncome});

  @override
  List<Object?> get props => [isIncome];
}

class CreateTransactionEvent extends TransactionEvent {
  final Transaction transaction;
  const CreateTransactionEvent({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransactionsEvent extends TransactionEvent {
  final int transactionId;
  const DeleteTransactionsEvent({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}
