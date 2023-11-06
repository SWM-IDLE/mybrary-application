// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_recommend_feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyRecommendFeedModel _$MyRecommendFeedModelFromJson(
        Map<String, dynamic> json) =>
    MyRecommendFeedModel(
      recommendationFeeds: (json['recommendationFeeds'] as List<dynamic>)
          .map((e) =>
              MyRecommendFeedDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MyRecommendFeedModelToJson(
        MyRecommendFeedModel instance) =>
    <String, dynamic>{
      'recommendationFeeds': instance.recommendationFeeds,
    };

MyRecommendFeedDataModel _$MyRecommendFeedDataModelFromJson(
        Map<String, dynamic> json) =>
    MyRecommendFeedDataModel(
      content: json['content'] as String,
      recommendationFeedId: json['recommendationFeedId'] as int,
      myBookId: json['myBookId'] as int,
      bookId: json['bookId'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      isbn13: json['isbn13'] as String,
      createdAt: json['createdAt'] as String,
      recommendationTargetNames:
          (json['recommendationTargetNames'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$MyRecommendFeedDataModelToJson(
        MyRecommendFeedDataModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'recommendationFeedId': instance.recommendationFeedId,
      'myBookId': instance.myBookId,
      'bookId': instance.bookId,
      'title': instance.title,
      'thumbnailUrl': instance.thumbnailUrl,
      'isbn13': instance.isbn13,
      'createdAt': instance.createdAt,
      'recommendationTargetNames': instance.recommendationTargetNames,
    };
