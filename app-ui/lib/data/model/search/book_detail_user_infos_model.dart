import 'package:json_annotation/json_annotation.dart';

part 'book_detail_user_infos_model.g.dart';

@JsonSerializable()
class BookDetailUserInfosModel {
  final List<UserInfosModel> userInfos;

  BookDetailUserInfosModel({
    required this.userInfos,
  });

  factory BookDetailUserInfosModel.fromJson(Map<String, dynamic> json) =>
      _$BookDetailUserInfosModelFromJson(json);
}

@JsonSerializable()
class UserInfosModel {
  final String userId;
  final String nickname;
  final String profileImageUrl;

  UserInfosModel({
    required this.userId,
    required this.nickname,
    required this.profileImageUrl,
  });

  factory UserInfosModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfosModelFromJson(json);
}
