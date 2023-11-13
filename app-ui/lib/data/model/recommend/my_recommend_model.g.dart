// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_recommend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyRecommendModel _$MyRecommendModelFromJson(Map<String, dynamic> json) =>
    MyRecommendModel(
      myBookId: json['myBookId'] as int,
      content: json['content'] as String,
      recommendationTargetNames:
          (json['recommendationTargetNames'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$MyRecommendModelToJson(MyRecommendModel instance) =>
    <String, dynamic>{
      'myBookId': instance.myBookId,
      'content': instance.content,
      'recommendationTargetNames': instance.recommendationTargetNames,
    };

MyRecommendPostModel _$MyRecommendPostModelFromJson(
        Map<String, dynamic> json) =>
    MyRecommendPostModel(
      recommendationFeedId: json['recommendationFeedId'] as int,
      content: json['content'] as String,
      recommendationTargetNames:
          (json['recommendationTargetNames'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$MyRecommendPostModelToJson(
        MyRecommendPostModel instance) =>
    <String, dynamic>{
      'recommendationFeedId': instance.recommendationFeedId,
      'content': instance.content,
      'recommendationTargetNames': instance.recommendationTargetNames,
    };

MyRecommendPostDataModel _$MyRecommendPostDataModelFromJson(
        Map<String, dynamic> json) =>
    MyRecommendPostDataModel(
      content: json['content'] as String,
      recommendationTargetNames:
          (json['recommendationTargetNames'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$MyRecommendPostDataModelToJson(
        MyRecommendPostDataModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'recommendationTargetNames': instance.recommendationTargetNames,
    };
