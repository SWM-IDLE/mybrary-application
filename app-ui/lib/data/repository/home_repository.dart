import 'package:flutter/material.dart';
import 'package:mybrary/data/datasource/home/home_datasource.dart';
import 'package:mybrary/data/model/home/book_list_by_category_response.dart';
import 'package:mybrary/data/model/home/book_recommendations_response.dart';
import 'package:mybrary/data/model/home/books_ranking_model.dart';
import 'package:mybrary/data/model/home/notification_model.dart';

class HomeRepository {
  final HomeDataSource _homeDataSource = HomeDataSource();

  Future<int> getTodayRegisteredBookCount({
    required BuildContext context,
  }) {
    return _homeDataSource.getTodayRegisteredBookCount(context);
  }

  Future<BookListByCategoryResponseData> getBookListByCategory({
    required BuildContext context,
    required String type,
    int? page,
    int? categoryId,
  }) async {
    return _homeDataSource.getBookListByCategory(
      context,
      type,
      page,
      categoryId,
    );
  }

  Future<BookRecommendationsResponseData> getBookListByInterest({
    required BuildContext context,
    required String type,
    required String userId,
    int? page,
  }) async {
    return _homeDataSource.getBookListByInterest(context, type, userId, page);
  }

  Future<BooksRankingModel> getBooksByRanking({
    required BuildContext context,
    required String order,
    required int limit,
  }) async {
    return await _homeDataSource.getBooksByRanking(context, order, limit);
  }

  Future<NotificationModel> getNotificationList({
    required BuildContext context,
    required String userId,
  }) async {
    return await _homeDataSource.getNotificationList(context, userId);
  }
}
