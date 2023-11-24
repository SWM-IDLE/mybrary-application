import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final List<NotificationDataModel> messages;

  NotificationModel({
    required this.messages,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

@JsonSerializable()
class NotificationDataModel {
  final String userId;
  final String message;
  final String sourceUserId;
  final String type;
  final String publishedAt;

  NotificationDataModel({
    required this.userId,
    required this.message,
    required this.sourceUserId,
    required this.type,
    required this.publishedAt,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataModelFromJson(json);
}
