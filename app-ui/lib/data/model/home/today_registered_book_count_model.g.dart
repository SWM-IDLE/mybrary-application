// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_registered_book_count_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayRegisteredBookCountModel _$TodayRegisteredBookCountModelFromJson(
        Map<String, dynamic> json) =>
    TodayRegisteredBookCountModel(
      count: json['count'] as int,
    );

Map<String, dynamic> _$TodayRegisteredBookCountModelToJson(
        TodayRegisteredBookCountModel instance) =>
    <String, dynamic>{
      'count': instance.count,
    };

TodayRegisteredBookListModel _$TodayRegisteredBookListModelFromJson(
        Map<String, dynamic> json) =>
    TodayRegisteredBookListModel(
      totalCount: json['totalCount'] as int,
      myBookRegisteredList: (json['myBookRegisteredList'] as List<dynamic>)
          .map((e) =>
              MyBookRegisteredListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TodayRegisteredBookListModelToJson(
        TodayRegisteredBookListModel instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'myBookRegisteredList': instance.myBookRegisteredList,
    };

MyBookRegisteredListModel _$MyBookRegisteredListModelFromJson(
        Map<String, dynamic> json) =>
    MyBookRegisteredListModel(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      isbn13: json['isbn13'] as String,
      registeredAt: json['registeredAt'] as String?,
    );

Map<String, dynamic> _$MyBookRegisteredListModelToJson(
        MyBookRegisteredListModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'title': instance.title,
      'thumbnailUrl': instance.thumbnailUrl,
      'isbn13': instance.isbn13,
      'registeredAt': instance.registeredAt,
    };
