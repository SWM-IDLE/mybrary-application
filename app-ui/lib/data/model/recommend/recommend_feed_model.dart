import 'package:json_annotation/json_annotation.dart';

part 'recommend_feed_model.g.dart';

@JsonSerializable()
class RecommendFeedModel {
  final int lastRecommendationFeedId;
  final List<RecommendFeedDataModel> recommendationFeeds;

  RecommendFeedModel({
    required this.lastRecommendationFeedId,
    required this.recommendationFeeds,
  });

  factory RecommendFeedModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendFeedModelFromJson(json);
}

@JsonSerializable()
class RecommendFeedDataModel {
  final String content;
  final List<String> recommendationTargetNames;
  final String userId;
  final String nickname;
  final String profileImageUrl;
  final int myBookId;
  final int bookId;
  final int recommendationFeedId;
  final String title;
  final String thumbnailUrl;
  final String isbn13;
  final List<String> authors;
  final int holderCount;
  final int interestCount;
  final bool interested;

  RecommendFeedDataModel({
    required this.content,
    required this.recommendationTargetNames,
    required this.userId,
    required this.nickname,
    required this.profileImageUrl,
    required this.myBookId,
    required this.bookId,
    required this.recommendationFeedId,
    required this.title,
    required this.thumbnailUrl,
    required this.isbn13,
    required this.authors,
    required this.holderCount,
    required this.interestCount,
    required this.interested,
  });

  factory RecommendFeedDataModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendFeedDataModelFromJson(json);
}
