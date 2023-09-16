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
