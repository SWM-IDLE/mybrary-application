import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/recommend/recommend_feed_model.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/utils/dios/auth_dio.dart';

class RecommendDataSource {
  Future<RecommendFeedModel?> getBookSearchResponse({
    required BuildContext context,
    required String userId,
    int? cursor,
    int? limit = 10,
  }) async {
    final dio = await authDio(context);
    final getResponse = await dio.get(
      '$bookServiceUrl/recommendation-feeds?cursor=$cursor&limit=$limit',
      options: Options(headers: {'User-Id': userId}),
    );

    log('추천 피드 조회 응답값: $getResponse');
    final CommonModel<RecommendFeedModel> result = commonResponseResult(
      getResponse,
      () => CommonModel<RecommendFeedModel>(
        status: getResponse.data['status'],
        message: getResponse.data['message'],
        data: RecommendFeedModel.fromJson(
          getResponse.data['data'],
        ),
      ),
    );

    return result.data;
  }
}
