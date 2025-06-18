import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:shmr_25/core/error/failures.dart';
import 'package:shmr_25/core/usecases/usecase.dart';


class GetTransactionByRange implements UseCase<List<Transaction>, DateTimeRange> {

  final TransactionRepository repository;

  GetTransactionByRange(this.repository);



}