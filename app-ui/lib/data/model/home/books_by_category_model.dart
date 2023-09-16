import 'package:json_annotation/json_annotation.dart';

part 'books_by_category_model.g.dart';

@JsonSerializable()
class BooksByCategoryModel {
  final List<BooksModel> books;

  BooksByCategoryModel({
    required this.books,
  });

  factory BooksByCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$BooksByCategoryModelFromJson(json);
}

@JsonSerializable()
class BooksModel {
  final String thumbnailUrl;
  final String isbn13;

  BooksModel({
    required this.thumbnailUrl,
    required this.isbn13,
  });

  factory BooksModel.fromJson(Map<String, dynamic> json) =>
      _$BooksModelFromJson(json);

  Map<String, dynamic> toJson() => _$BooksModelToJson(this);
}
