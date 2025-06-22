import 'package:freezed_annotation/freezed_annotation.dart';
import 'stat_item_model.dart';

part 'account_response_model.freezed.dart';
part 'account_response_model.g.dart';

@freezed
class AccountResponseModel with _$AccountResponseModel {
  const factory AccountResponseModel({
    required int id,
    required String name,
    required String balance,
    required String currency,
    required List<StatItemModel> incomeStats,
    required List<StatItemModel> expenseStats,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountResponseModel;

  factory AccountResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AccountResponseModelFromJson(json);
}