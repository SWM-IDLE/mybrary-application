// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_by_interest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BooksByInterestModel _$BooksByInterestModelFromJson(
        Map<String, dynamic> json) =>
    BooksByInterestModel(
      userInterests: (json['userInterests'] as List<dynamic>?)
          ?.map((e) => UserInterests.fromJson(e as Map<String, dynamic>))
          .toList(),
      bookRecommendations: (json['bookRecommendations'] as List<dynamic>?)
          ?.map((e) => BooksModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BooksByInterestModelToJson(
        BooksByInterestModel instance) =>
    <String, dynamic>{
      'userInterests': instance.userInterests,
      'bookRecommendations': instance.bookRecommendations,
    };

UserInterests _$UserInterestsFromJson(Map<String, dynamic> json) =>
    UserInterests(
      name: json['name'] as String?,
      code: json['code'] as int?,
    );

Map<String, dynamic> _$UserInterestsToJson(UserInterests instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
    };
