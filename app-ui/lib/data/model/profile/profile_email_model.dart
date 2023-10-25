import 'package:json_annotation/json_annotation.dart';

part 'profile_email_model.g.dart';

@JsonSerializable()
class ProfileEmailModel {
  final String email;

  ProfileEmailModel({
    required this.email,
  });

  factory ProfileEmailModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileEmailModelFromJson(json);
}
