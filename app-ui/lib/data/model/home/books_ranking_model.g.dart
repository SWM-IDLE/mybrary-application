// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_ranking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooksRankingModel _$BooksRankingModelFromJson(Map<String, dynamic> json) =>
    BooksRankingModel(
      books: (json['books'] as List<dynamic>)
          .map((e) => BookRankingDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BooksRankingModelToJson(BooksRankingModel instance) =>
    <String, dynamic>{
      'books': instance.books,
    };

BookRankingDataModel _$BookRankingDataModelFromJson(
        Map<String, dynamic> json) =>
    BookRankingDataModel(
      title: json['title'] as String,
      isbn13: json['isbn13'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      holderCount: json['holderCount'] as int,
      readCount: json['readCount'] as int,
      interestCount: json['interestCount'] as int,
      recommendationFeedCount: json['recommendationFeedCount'] as int,
      starRating: (json['starRating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
    );

Map<String, dynamic> _$BookRankingDataModelToJson(
        BookRankingDataModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'isbn13': instance.isbn13,
      'thumbnailUrl': instance.thumbnailUrl,
      'holderCount': instance.holderCount,
      'readCount': instance.readCount,
      'interestCount': instance.interestCount,
      'recommendationFeedCount': instance.recommendationFeedCount,
      'starRating': instance.starRating,
      'reviewCount': instance.reviewCount,
    };
