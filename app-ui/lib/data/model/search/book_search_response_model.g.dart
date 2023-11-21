// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_search_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookSearchResponseModel _$BookSearchResponseModelFromJson(
        Map<String, dynamic> json) =>
    BookSearchResponseModel(
      bookSearchResult: (json['bookSearchResult'] as List<dynamic>?)
          ?.map(
              (e) => BookSearchResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookSearchResponseModelToJson(
        BookSearchResponseModel instance) =>
    <String, dynamic>{
      'bookSearchResult': instance.bookSearchResult,
    };

BookSearchResultModel _$BookSearchResultModelFromJson(
        Map<String, dynamic> json) =>
    BookSearchResultModel(
      title: json['title'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      isbn13: json['isbn13'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      publicationDate: json['publicationDate'] as String,
      starRating: (json['starRating'] as num).toDouble(),
    );

Map<String, dynamic> _$BookSearchResultModelToJson(
        BookSearchResultModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'author': instance.author,
      'isbn13': instance.isbn13,
      'thumbnailUrl': instance.thumbnailUrl,
      'publicationDate': instance.publicationDate,
      'starRating': instance.starRating,
    };
