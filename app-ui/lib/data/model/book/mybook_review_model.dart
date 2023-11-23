import 'package:json_annotation/json_annotation.dart';

part 'mybook_review_model.g.dart';

@JsonSerializable()
class MyBookReviewModel {
  final List<MyBookReviewDataModel> reviews;

  MyBookReviewModel({
    required this.reviews,
  });

  factory MyBookReviewModel.fromJson(Map<String, dynamic> json) =>
      _$MyBookReviewModelFromJson(json);
}

@JsonSerializable()
class MyBookReviewDataModel {
  final int reviewId;
  final int myBookId;
  final String bookTitle;
  final String bookIsbn13;
  final String bookThumbnailUrl;
  final String content;
  final double starRating;
  final String createdAt;
  final String updatedAt;
  final List<String> authors;

  MyBookReviewDataModel({
    required this.reviewId,
    required this.myBookId,
    required this.bookTitle,
    required this.bookIsbn13,
    required this.bookThumbnailUrl,
    required this.content,
    required this.starRating,
    required this.createdAt,
    required this.updatedAt,
    required this.authors,
  });

  factory MyBookReviewDataModel.fromJson(Map<String, dynamic> json) =>
      _$MyBookReviewDataModelFromJson(json);
}
