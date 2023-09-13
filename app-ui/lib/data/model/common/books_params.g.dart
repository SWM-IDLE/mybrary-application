// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooksParams _$BooksParamsFromJson(Map<String, dynamic> json) => BooksParams(
      type: json['type'] as String,
      page: json['page'] as String?,
      categoryId: json['categoryId'] as String?,
    );

Map<String, dynamic> _$BooksParamsToJson(BooksParams instance) =>
    <String, dynamic>{
      'type': instance.type,
      'page': instance.page,
      'categoryId': instance.categoryId,
    };
