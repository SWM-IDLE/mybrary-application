import 'package:json_annotation/json_annotation.dart';

part 'common_model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
)
class CommonModel<T> {
  final String status;
  final String message;
  final T data;

  CommonModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CommonModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CommonModelFromJson(json, fromJsonT);
}
