import 'package:json_annotation/json_annotation.dart';

part 'books_params.g.dart';

@JsonSerializable()
class BooksParams {
  final String? type;
  final String? page;
  final int? categoryId;
  final String? start;
  final String? end;

  const BooksParams({
    this.type,
    this.page,
    this.categoryId,
    this.start,
    this.end,
  });

  factory BooksParams.fromJson(Map<String, dynamic> json) =>
      _$BooksParamsFromJson(json);

  Map<String, dynamic> toJson() => _$BooksParamsToJson(this);
}
