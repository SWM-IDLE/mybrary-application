import 'package:json_annotation/json_annotation.dart';
import 'package:mybrary/data/model/home/books_by_category_model.dart';

part 'books_by_interest_model.g.dart';

@JsonSerializable()
class BooksByInterestModel {
  final List<UserInterests>? userInterests;
  final List<BooksModel>? bookRecommendations;

  BooksByInterestModel({
    required this.userInterests,
    required this.bookRecommendations,
  });

  factory BooksByInterestModel.fromJson(Map<String, dynamic> json) =>
      _$BooksByInterestModelFromJson(json);
}

@JsonSerializable()
class UserInterests {
  final String? name;
  final int? code;

  UserInterests({
    this.name,
    this.code,
  });

  factory UserInterests.fromJson(Map<String, dynamic> json) =>
      _$UserInterestsFromJson(json);

  Map<String, dynamic> toJson() => _$UserInterestsToJson(this);
}
