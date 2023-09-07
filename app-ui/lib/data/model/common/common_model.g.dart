// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonModel<T> _$CommonModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    CommonModel<T>(
      status: json['status'] as String,
      message: json['message'] as String,
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$CommonModelToJson<T>(
  CommonModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': toJsonT(instance.data),
    };
