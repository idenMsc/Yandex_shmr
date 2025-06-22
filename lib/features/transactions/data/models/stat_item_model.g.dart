// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatItemModelImpl _$$StatItemModelImplFromJson(Map<String, dynamic> json) =>
    _$StatItemModelImpl(
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      emoji: json['emoji'] as String,
      amount: json['amount'] as String,
    );

Map<String, dynamic> _$$StatItemModelImplToJson(_$StatItemModelImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'emoji': instance.emoji,
      'amount': instance.amount,
    };
