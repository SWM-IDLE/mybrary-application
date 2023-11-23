// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_book_search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiBookSearchResultModel _$MultiBookSearchResultModelFromJson(
        Map<String, dynamic> json) =>
    MultiBookSearchResultModel(
      title: json['title'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      isbn13: json['isbn13'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      publicationDate: json['publicationDate'] as String,
      starRating: (json['starRating'] as num).toDouble(),
    );

Map<String, dynamic> _$MultiBookSearchResultModelToJson(
        MultiBookSearchResultModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'author': instance.author,
      'isbn13': instance.isbn13,
      'thumbnailUrl': instance.thumbnailUrl,
      'publicationDate': instance.publicationDate,
      'starRating': instance.starRating,
    };
