import 'package:json_annotation/json_annotation.dart';

part 'my_recommend_model.g.dart';

@JsonSerializable()
class MyRecommendModel {
  final int myBookId;
  final String content;
  final List<String> recommendationTargetNames;

  MyRecommendModel({
    required this.myBookId,
    required this.content,
    required this.recommendationTargetNames,
  });

  factory MyRecommendModel.fromJson(Map<String, dynamic> json) =>
      _$MyRecommendModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyRecommendModelToJson(this);
}

@JsonSerializable()
class MyRecommendPostModel {
  final int recommendationFeedId;
  final String content;
  final List<String> recommendationTargetNames;

  MyRecommendPostModel({
    required this.recommendationFeedId,
    required this.content,
    required this.recommendationTargetNames,
  });

  factory MyRecommendPostModel.fromJson(Map<String, dynamic> json) =>
      _$MyRecommendPostModelFromJson(json);
}

@JsonSerializable()
class MyRecommendPostDataModel {
  final String content;
  final List<String> recommendationTargetNames;

  MyRecommendPostDataModel({
    required this.content,
    required this.recommendationTargetNames,
  });

  factory MyRecommendPostDataModel.fromJson(Map<String, dynamic> json) =>
      _$MyRecommendPostDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyRecommendPostDataModelToJson(this);
}
