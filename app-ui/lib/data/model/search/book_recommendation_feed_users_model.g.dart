// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_recommendation_feed_users_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookRecommendationFeedUsersModel _$BookRecommendationFeedUsersModelFromJson(
        Map<String, dynamic> json) =>
    BookRecommendationFeedUsersModel(
      recommendationFeeds: (json['recommendationFeeds'] as List<dynamic>)
          .map((e) => BookRecommendationFeedUsersInfoModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookRecommendationFeedUsersModelToJson(
        BookRecommendationFeedUsersModel instance) =>
    <String, dynamic>{
      'recommendationFeeds': instance.recommendationFeeds,
    };

BookRecommendationFeedUsersInfoModel
    _$BookRecommendationFeedUsersInfoModelFromJson(Map<String, dynamic> json) =>
        BookRecommendationFeedUsersInfoModel(
          content: json['content'] as String,
          recommendationTargetNames:
              (json['recommendationTargetNames'] as List<dynamic>)
                  .map((e) => e as String)
                  .toList(),
          userId: json['userId'] as String,
          nickname: json['nickname'] as String,
          profileImageUrl: json['profileImageUrl'] as String,
        );

Map<String, dynamic> _$BookRecommendationFeedUsersInfoModelToJson(
        BookRecommendationFeedUsersInfoModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'recommendationTargetNames': instance.recommendationTargetNames,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
    };
