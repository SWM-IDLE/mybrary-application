import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/book_list_by_category_response.dart';
import 'package:mybrary/data/model/home/book_recommendations_response.dart';
import 'package:mybrary/data/model/home/books_ranking_model.dart';
import 'package:mybrary/data/model/home/notification_model.dart';
import 'package:mybrary/data/model/home/today_registered_book_count_model.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/utils/dios/auth_dio.dart';

class HomeDataSource {
  Future<int> getTodayRegisteredBookCount(BuildContext context) async {
    final dio = await authDio(context);
    final getTodayRegisteredBookCountResponse = await dio.get(
      getApi(API.getTodayRegisteredBookCount),
    );

    log('오늘의 마이북 등록수 조회 응답값: $getTodayRegisteredBookCountResponse');
    final TodayRegisteredBookCountModel result = commonResponseResult(
      getTodayRegisteredBookCountResponse,
      () => TodayRegisteredBookCountModel.fromJson(
        getTodayRegisteredBookCountResponse.data['data'],
      ),
    );

    return result.count;
  }

  Future<BookListByCategoryResponseData> getBookListByCategory(
    BuildContext context,
    String type,
    int? page,
    int? categoryId,
  ) async {
    final dio = await authDio(context);
    final getBookListByCategoryResponse = await dio.get(
      '${getApi(API.getBookListByCategory)}?type=$type&page=${page ?? 1}&categoryId=${categoryId ?? 0}',
    );

    log('카테고리 도서 목록 조회 응답값: $getBookListByCategoryResponse');
    final BookListByCategoryResponse result = commonResponseResult(
      getBookListByCategoryResponse,
      () => BookListByCategoryResponse(
        status: getBookListByCategoryResponse.data['status'],
        message: getBookListByCategoryResponse.data['message'],
        data: BookListByCategoryResponseData.fromJson(
          getBookListByCategoryResponse.data['data'],
        ),
      ),
    );

    return result.data!;
  }

  Future<BookRecommendationsResponseData> getBookListByInterest(
    BuildContext context,
    String type,
    String userId,
    int? page,
  ) async {
    final dio = await authDio(context);
    final getBookListByInterestResponse = await dio.get(
      '${getApi(API.getBookListByInterest)}/$type&page=${page ?? 1}',
      options: Options(headers: {'User-Id': userId}),
    );

    log('관심사별 추천 도서 조회 응답값: $getBookListByInterestResponse');
    final BookRecommendationsResponse result = commonResponseResult(
      getBookListByInterestResponse,
      () => BookRecommendationsResponse(
        status: getBookListByInterestResponse.data['status'],
        message: getBookListByInterestResponse.data['message'],
        data: BookRecommendationsResponseData.fromJson(
          getBookListByInterestResponse.data['data'],
        ),
      ),
    );

    return result.data!;
  }

  Future<BooksRankingModel> getBooksByRanking(
    BuildContext context,
    String order,
    int limit,
  ) async {
    final dio = await authDio(context);
    final getBookListByInterestResponse = await dio.get(
      '${getApi(API.getBooksByRanking)}?order=$order&limit=$limit',
    );

    log('랭킹별 도서 조회 응답값: $getBookListByInterestResponse');
    final CommonModel result = commonResponseResult(
      getBookListByInterestResponse,
      () => CommonModel(
        status: getBookListByInterestResponse.data['status'],
        message: getBookListByInterestResponse.data['message'],
        data: BooksRankingModel.fromJson(
          getBookListByInterestResponse.data['data'],
        ),
      ),
    );

    return result.data!;
  }

  Future<NotificationModel> getNotificationList(
    BuildContext context,
    String userId,
  ) async {
    final dio = await authDio(context);
    final getNotificationListResponse = await dio.get(
      'http://13.125.198.36:8080/api/v1/notification/users/$userId',
    );

    log('알림 목록 응답값: $getNotificationListResponse');
    final CommonModel result = commonResponseResult(
      getNotificationListResponse,
      () => CommonModel(
        status: getNotificationListResponse.data['status'],
        message: getNotificationListResponse.data['message'],
        data: NotificationModel.fromJson(
          getNotificationListResponse.data['data'],
        ),
      ),
    );

    return result.data!;
  }
}
