import 'package:json_annotation/json_annotation.dart';

part 'book_recommendation_feed_users_model.g.dart';

@JsonSerializable()
class BookRecommendationFeedUsersModel {
  final List<BookRecommendationFeedUsersInfoModel> recommendationFeeds;

  BookRecommendationFeedUsersModel({
    required this.recommendationFeeds,
  });

  factory BookRecommendationFeedUsersModel.fromJson(
          Map<String, dynamic> json) =>
      _$BookRecommendationFeedUsersModelFromJson(json);
}

@JsonSerializable()
class BookRecommendationFeedUsersInfoModel {
  final String content;
  final List<String> recommendationTargetNames;
  final String userId;
  final String nickname;
  final String profileImageUrl;

  BookRecommendationFeedUsersInfoModel({
    required this.content,
    required this.recommendationTargetNames,
    required this.userId,
    required this.nickname,
    required this.profileImageUrl,
  });

  factory BookRecommendationFeedUsersInfoModel.fromJson(
          Map<String, dynamic> json) =>
      _$BookRecommendationFeedUsersInfoModelFromJson(json);
}
