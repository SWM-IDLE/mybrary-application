import 'package:json_annotation/json_annotation.dart';

part 'user_report_model.g.dart';

@JsonSerializable()
class UserReportModel {
  final String reportedUserId;
  final String reportedReason;

  UserReportModel({
    required this.reportedUserId,
    required this.reportedReason,
  });

  factory UserReportModel.fromJson(Map<String, dynamic> json) =>
      _$UserReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserReportModelToJson(this);
}
