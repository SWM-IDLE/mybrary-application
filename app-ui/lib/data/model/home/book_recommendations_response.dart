import 'package:mybrary/data/model/home/books_by_category_model.dart';
import 'package:mybrary/data/model/home/books_by_interest_model.dart';

class BookRecommendationsResponse {
  String status;
  String message;
  BookRecommendationsResponseData? data;

  BookRecommendationsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BookRecommendationsResponse.fromJson(Map<String, dynamic> json) {
    return BookRecommendationsResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? BookRecommendationsResponseData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BookRecommendationsResponseData {
  List<UserInterests>? userInterests;
  List<BooksModel>? bookRecommendations;

  BookRecommendationsResponseData({
    this.userInterests,
    this.bookRecommendations,
  });

  factory BookRecommendationsResponseData.fromJson(Map<String, dynamic> json) {
    return BookRecommendationsResponseData(
      userInterests: json['userInterests'] != null
          ? (json['userInterests'] as List)
              .map((i) => UserInterests.fromJson(i))
              .toList()
          : null,
      bookRecommendations: json['bookRecommendations'] != null
          ? (json['bookRecommendations'] as List)
              .map((i) => BooksModel.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userInterests != null) {
      data['userInterests'] = userInterests!.map((v) => v.toJson()).toList();
    }
    if (bookRecommendations != null) {
      data['bookRecommendations'] =
          bookRecommendations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookRecommendations {
  String? thumbnailUrl;
  String? isbn13;

  BookRecommendations({this.thumbnailUrl, this.isbn13});

  factory BookRecommendations.fromJson(Map<String, dynamic> json) {
    return BookRecommendations(
      thumbnailUrl: json['thumbnailUrl'],
      isbn13: json['isbn13'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumbnailUrl'] = thumbnailUrl;
    data['isbn13'] = isbn13;
    return data;
  }
}
