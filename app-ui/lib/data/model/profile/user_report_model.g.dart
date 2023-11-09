// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReportModel _$UserReportModelFromJson(Map<String, dynamic> json) =>
    UserReportModel(
      reportedUserId: json['reportedUserId'] as String,
      reportedReason: json['reportedReason'] as String,
    );

Map<String, dynamic> _$UserReportModelToJson(UserReportModel instance) =>
    <String, dynamic>{
      'reportedUserId': instance.reportedUserId,
      'reportedReason': instance.reportedReason,
    };
