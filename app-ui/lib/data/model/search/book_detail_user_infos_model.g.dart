// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_detail_user_infos_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDetailUserInfosModel _$BookDetailUserInfosModelFromJson(
        Map<String, dynamic> json) =>
    BookDetailUserInfosModel(
      userInfos: (json['userInfos'] as List<dynamic>)
          .map((e) => UserInfosModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookDetailUserInfosModelToJson(
        BookDetailUserInfosModel instance) =>
    <String, dynamic>{
      'userInfos': instance.userInfos,
    };

UserInfosModel _$UserInfosModelFromJson(Map<String, dynamic> json) =>
    UserInfosModel(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
    );

Map<String, dynamic> _$UserInfosModelToJson(UserInfosModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
    };
