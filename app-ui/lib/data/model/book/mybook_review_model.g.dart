// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mybook_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyBookReviewModel _$MyBookReviewModelFromJson(Map<String, dynamic> json) =>
    MyBookReviewModel(
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => MyBookReviewDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyBookReviewModelToJson(MyBookReviewModel instance) =>
    <String, dynamic>{
      'reviews': instance.reviews,
    };

MyBookReviewDataModel _$MyBookReviewDataModelFromJson(
        Map<String, dynamic> json) =>
    MyBookReviewDataModel(
      reviewId: json['reviewId'] as int,
      myBookId: json['myBookId'] as int,
      bookTitle: json['bookTitle'] as String,
      bookIsbn13: json['bookIsbn13'] as String,
      bookThumbnailUrl: json['bookThumbnailUrl'] as String,
      content: json['content'] as String,
      starRating: (json['starRating'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      authors:
          (json['authors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MyBookReviewDataModelToJson(
        MyBookReviewDataModel instance) =>
    <String, dynamic>{
      'reviewId': instance.reviewId,
      'myBookId': instance.myBookId,
      'bookTitle': instance.bookTitle,
      'bookIsbn13': instance.bookIsbn13,
      'bookThumbnailUrl': instance.bookThumbnailUrl,
      'content': instance.content,
      'starRating': instance.starRating,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'authors': instance.authors,
    };
