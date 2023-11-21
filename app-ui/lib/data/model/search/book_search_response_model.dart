import 'package:json_annotation/json_annotation.dart';

part 'book_search_response_model.g.dart';

@JsonSerializable()
class BookSearchResponseModel {
  List<BookSearchResultModel>? bookSearchResult;

  BookSearchResponseModel({
    required this.bookSearchResult,
  });

  factory BookSearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BookSearchResponseModelFromJson(json);
}

@JsonSerializable()
class BookSearchResultModel {
  final String title;
  final String description;
  final String author;
  final String isbn13;
  final String thumbnailUrl;
  final String publicationDate;
  final double starRating;

  BookSearchResultModel({
    required this.title,
    required this.description,
    required this.author,
    required this.isbn13,
    required this.thumbnailUrl,
    required this.publicationDate,
    required this.starRating,
  });

  factory BookSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$BookSearchResultModelFromJson(json);
}
