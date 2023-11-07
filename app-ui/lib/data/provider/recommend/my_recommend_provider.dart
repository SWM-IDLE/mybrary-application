import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/recommend/my_recommend_model.dart';
import 'package:mybrary/data/model/recommend/recommend_feed_model.dart';
import 'package:mybrary/data/repository/recommend_repository.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

final recommendFeedProvider = Provider<RecommendFeedModel?>((ref) {
  final state = ref.watch(myRecommendProvider);

  if (state is! CommonModel) {
    return null;
  }

  return state.data;
});

final myRecommendProvider =
    StateNotifierProvider<MyRecommendStateNotifier, CommonResponseBase>((ref) {
  final repo = ref.watch(recommendRepositoryProvider);

  final notifier = MyRecommendStateNotifier(
    repository: repo,
  );

  return notifier;
});

class MyRecommendStateNotifier extends StateNotifier<CommonResponseBase> {
  final RecommendRepository repository;

  MyRecommendStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void getRecommendFeedList({
    required String userId,
    int? cursor,
    int? limit,
  }) async {
    try {
      if (state is! CommonModel) {
        state = await repository.getRecommendFeedList(
          userId: userId,
          cursor: cursor,
          limit: limit,
        );
      }
    } on DioException catch (err) {
      throw Exception(err);
    }
  }

  void createRecommendFeed({
    required String userId,
    required MyRecommendModel body,
    required BuildContext context,
  }) async {
    try {
      await repository.createRecommendFeed(
        context: context,
        userId: userId,
        body: body,
      );
      if (!mounted) return;
      Future.delayed(const Duration(seconds: 1), () {
        showCommonSnackBarMessage(
          context: context,
          snackBarText: '추천 피드가 등록되었어요 :)',
        );
        Navigator.pop(context, true);
      });
    } on DioException catch (err) {
      if (err.response!.data.toString().contains('RF-04')) {
        showCommonSnackBarMessage(
          context: context,
          snackBarText: '해당 도서로 작성한 추천 피드가 존재해요 !',
        );
      }
    }
  }

  void updateRecommendFeed({
    required String userId,
    required int recommendationFeedId,
    required MyRecommendPostDataModel body,
    required BuildContext context,
  }) async {
    try {
      await repository.updateRecommendFeed(
        userId: userId,
        recommendationFeedId: recommendationFeedId,
        body: body,
        context: context,
      );
      if (!mounted) return;
      Future.delayed(const Duration(seconds: 1), () {
        showCommonSnackBarMessage(
          context: context,
          snackBarText: '추천 피드가 수정되었어요 :)',
        );
        Navigator.pop(context, true);
      });
    } on DioException catch (err) {
      throw Exception(err);
    }
  }

  void deleteRecommendFeed({
    required String userId,
    required int recommendationFeedId,
    required BuildContext context,
  }) async {
    try {
      await repository.deleteRecommendFeed(
        userId: userId,
        recommendationFeedId: recommendationFeedId,
        context: context,
      );
      if (!mounted) return;
      Future.delayed(const Duration(seconds: 1), () {
        showCommonSnackBarMessage(
          context: context,
          snackBarText: '추천 피드가 삭제되었어요 !',
        );
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      });
    } on DioException catch (err) {
      throw Exception(err);
    }
  }
}
