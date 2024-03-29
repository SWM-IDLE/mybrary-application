// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_by_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooksByCategoryModel _$BooksByCategoryModelFromJson(
        Map<String, dynamic> json) =>
    BooksByCategoryModel(
      books: (json['books'] as List<dynamic>)
          .map((e) => BooksModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BooksByCategoryModelToJson(
        BooksByCategoryModel instance) =>
    <String, dynamic>{
      'books': instance.books,
    };

BooksModel _$BooksModelFromJson(Map<String, dynamic> json) => BooksModel(
      title: json['title'] as String?,
      authors: json['authors'] as String?,
      aladinStarRating: (json['aladinStarRating'] as num?)?.toDouble(),
      thumbnailUrl: json['thumbnailUrl'] as String,
      isbn13: json['isbn13'] as String,
    );

Map<String, dynamic> _$BooksModelToJson(BooksModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'authors': instance.authors,
      'aladinStarRating': instance.aladinStarRating,
      'thumbnailUrl': instance.thumbnailUrl,
      'isbn13': instance.isbn13,
    };
