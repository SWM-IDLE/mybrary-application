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
