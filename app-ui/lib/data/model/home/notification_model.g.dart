// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      messages: (json['messages'] as List<dynamic>)
          .map((e) => NotificationDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'messages': instance.messages,
    };

NotificationDataModel _$NotificationDataModelFromJson(
        Map<String, dynamic> json) =>
    NotificationDataModel(
      userId: json['userId'] as String,
      message: json['message'] as String,
      sourceUserId: json['sourceUserId'] as String,
      type: json['type'] as String,
      publishedAt: json['publishedAt'] as String,
    );

Map<String, dynamic> _$NotificationDataModelToJson(
        NotificationDataModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'message': instance.message,
      'sourceUserId': instance.sourceUserId,
      'type': instance.type,
      'publishedAt': instance.publishedAt,
    };
