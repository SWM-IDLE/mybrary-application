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
