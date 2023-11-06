import 'package:json_annotation/json_annotation.dart';

part 'my_recommend_feed_model.g.dart';

@JsonSerializable()
class MyRecommendFeedModel {
  final String content;
  final int recommendationFeedId;
  final int myBookId;
  final int bookId;
  final String title;
  final String thumbnailUrl;
  final String isbn13;
  final String createdAt;
  final List<String> recommendationTargetNames;

  MyRecommendFeedModel({
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

  factory MyRecommendFeedModel.fromJson(Map<String, dynamic> json) =>
      _$MyRecommendFeedModelFromJson(json);
}
