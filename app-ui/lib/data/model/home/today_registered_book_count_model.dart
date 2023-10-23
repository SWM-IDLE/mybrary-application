import 'package:json_annotation/json_annotation.dart';

part 'today_registered_book_count_model.g.dart';

@JsonSerializable()
class TodayRegisteredBookCountModel {
  final int count;

  TodayRegisteredBookCountModel({
    required this.count,
  });

  factory TodayRegisteredBookCountModel.fromJson(Map<String, dynamic> json) =>
      _$TodayRegisteredBookCountModelFromJson(json);
}

@JsonSerializable()
class TodayRegisteredBookListModel {
  final int totalCount;
  final List<MyBookRegisteredListModel> myBookRegisteredList;

  TodayRegisteredBookListModel({
    required this.totalCount,
    required this.myBookRegisteredList,
  });

  factory TodayRegisteredBookListModel.fromJson(Map<String, dynamic> json) =>
      _$TodayRegisteredBookListModelFromJson(json);
}

@JsonSerializable()
class MyBookRegisteredListModel {
  final String userId;
  final String nickname;
  final String profileImageUrl;
  final String title;
  final String thumbnailUrl;
  final String isbn13;
  final String? registeredAt;

  MyBookRegisteredListModel({
    required this.userId,
    required this.nickname,
    required this.profileImageUrl,
    required this.title,
    required this.thumbnailUrl,
    required this.isbn13,
    required this.registeredAt,
  });

  factory MyBookRegisteredListModel.fromJson(Map<String, dynamic> json) =>
      _$MyBookRegisteredListModelFromJson(json);
}
