import 'package:json_annotation/json_annotation.dart';

part 'common_model.g.dart';

abstract class CommonResponseBase {}

class CommonResponseError extends CommonResponseBase {
  final String errorCode;
  final String errorMessage;

  CommonResponseError({
    required this.errorCode,
    required this.errorMessage,
  });
}

class CommonResponseLoading extends CommonResponseBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class CommonModel<T> extends CommonResponseBase {
  final String status;
  final String message;
  final T? data;

  CommonModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CommonModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$CommonModelFromJson(json, fromJsonT);
}

class CommonResponseRefetching<T> extends CommonModel<T> {
  CommonResponseRefetching({
    required super.status,
    required super.message,
    required super.data,
  });
}

class CommonResponseFetchingMore<T> extends CommonModel<T> {
  CommonResponseFetchingMore({
    required super.status,
    required super.message,
    required super.data,
  });
}
