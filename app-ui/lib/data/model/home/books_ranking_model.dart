import 'package:json_annotation/json_annotation.dart';

part 'books_ranking_model.g.dart';

@JsonSerializable()
class BooksRankingModel {
  final List<BookRankingDataModel> books;

  BooksRankingModel({
    required this.books,
  });

  factory BooksRankingModel.fromJson(Map<String, dynamic> json) =>
      _$BooksRankingModelFromJson(json);
}

@JsonSerializable()
class BookRankingDataModel {
  final String title;
  final String isbn13;
  final String thumbnailUrl;
  final int holderCount;
  final int readCount;
  final int interestCount;
  final int recommendationFeedCount;
  final double starRating;
  final int reviewCount;

  BookRankingDataModel({
    required this.title,
    required this.isbn13,
    required this.thumbnailUrl,
    required this.holderCount,
    required this.readCount,
    required this.interestCount,
    required this.recommendationFeedCount,
    required this.starRating,
    required this.reviewCount,
  });

  factory BookRankingDataModel.fromJson(Map<String, dynamic> json) =>
      _$BookRankingDataModelFromJson(json);
}
