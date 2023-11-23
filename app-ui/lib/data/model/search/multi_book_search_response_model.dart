import 'package:json_annotation/json_annotation.dart';

part 'multi_book_search_response_model.g.dart';

class MultiBookSearchResponse {
  String status;
  String message;
  List<dynamic> data;

  MultiBookSearchResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MultiBookSearchResponse.fromJson(Map<String, dynamic> json) {
    return MultiBookSearchResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}

@JsonSerializable()
class MultiBookSearchResultModel {
  final String title;
  final String description;
  final String author;
  final String isbn13;
  final String thumbnailUrl;
  final String publicationDate;
  final double starRating;

  MultiBookSearchResultModel({
    required this.title,
    required this.description,
    required this.author,
    required this.isbn13,
    required this.thumbnailUrl,
    required this.publicationDate,
    required this.starRating,
  });

  factory MultiBookSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$MultiBookSearchResultModelFromJson(json);
}
