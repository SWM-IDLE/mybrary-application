// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_feed_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendFeedModel _$RecommendFeedModelFromJson(Map<String, dynamic> json) =>
    RecommendFeedModel(
      lastRecommendationFeedId: json['lastRecommendationFeedId'] as int,
      recommendationFeeds: (json['recommendationFeeds'] as List<dynamic>)
          .map(
              (e) => RecommendFeedDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecommendFeedModelToJson(RecommendFeedModel instance) =>
    <String, dynamic>{
      'lastRecommendationFeedId': instance.lastRecommendationFeedId,
      'recommendationFeeds': instance.recommendationFeeds,
    };

RecommendFeedDataModel _$RecommendFeedDataModelFromJson(
        Map<String, dynamic> json) =>
    RecommendFeedDataModel(
      content: json['content'] as String,
      recommendationTargetNames:
          (json['recommendationTargetNames'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      myBookId: json['myBookId'] as int,
      bookId: json['bookId'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      isbn13: json['isbn13'] as String,
      authors:
          (json['authors'] as List<dynamic>).map((e) => e as String).toList(),
      holderCount: json['holderCount'] as int,
      interestCount: json['interestCount'] as int,
      interested: json['interested'] as bool,
    );

Map<String, dynamic> _$RecommendFeedDataModelToJson(
        RecommendFeedDataModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'recommendationTargetNames': instance.recommendationTargetNames,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'myBookId': instance.myBookId,
      'bookId': instance.bookId,
      'title': instance.title,
      'thumbnailUrl': instance.thumbnailUrl,
      'isbn13': instance.isbn13,
      'authors': instance.authors,
      'holderCount': instance.holderCount,
      'interestCount': instance.interestCount,
      'interested': instance.interested,
    };
