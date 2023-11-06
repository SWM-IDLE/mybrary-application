import 'package:json_annotation/json_annotation.dart';

part 'my_recommend_feed_model.g.dart';

@JsonSerializable()
class MyRecommendFeedModel {
  final List<MyRecommendFeedDataModel> recommendationFeeds;

  MyRecommendFeedModel({
    required this.recommendationFeeds,
  });

  factory MyRecommendFeedModel.fromJson(Map<String, dynamic> json) =>
      _$MyRecommendFeedModelFromJson(json);
}

@JsonSerializable()
class MyRecommendFeedDataModel {
  final String content;
  final int recommendationFeedId;
  final int myBookId;
  final int bookId;
  final String title;
  final String thumbnailUrl;
  final String isbn13;
  final String createdAt;
  final List<String> recommendationTargetNames;

  MyRecommendFeedDataModel({
    required this.content,
    required this.recommendationFeedId,
    required this.myBookId,
    required this.bookId,
    required this.title,
    required this.thumbnailUrl,
    required this.isbn13,
    required this.createdAt,
    required this.recommendationTargetNames,
  });

  factory MyRecommendFeedDataModel.fromJson(Map<String, dynamic> json) =>
      _$MyRecommendFeedDataModelFromJson(json);
}
