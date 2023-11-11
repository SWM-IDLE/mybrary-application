import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/recommend/my_recommend_model.dart';
import 'package:mybrary/data/model/recommend/recommend_feed_model.dart';
import 'package:mybrary/data/repository/recommend_repository.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

final recommendFeedProvider = StateProvider<RecommendFeedModel?>((ref) {
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
        if (cursor == null) {
          state = await repository.getRecommendFeedList(
            userId: userId,
            cursor: cursor,
            limit: limit,
          );
        }
      }

      if (cursor != null) {
        final feedList = await repository.getRecommendFeedList(
          userId: userId,
          cursor: cursor,
          limit: limit,
        );

        final currentState = state;

        if (currentState is CommonModel) {
          if (currentState.data is RecommendFeedModel) {
            final appendedData = RecommendFeedModel(
              lastRecommendationFeedId: feedList.data!.lastRecommendationFeedId,
              recommendationFeeds: [
                ...(currentState.data as RecommendFeedModel)
                    .recommendationFeeds,
                ...feedList.data!.recommendationFeeds,
              ],
            );

            state = CommonModel(
              status: feedList.status,
              message: feedList.message,
              data: appendedData,
            );
          }
        }
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
      commonLoadingAlert(
        context: context,
        loadingAction: () async {
          showCommonSnackBarMessage(
            context: context,
            snackBarText: '추천 피드가 등록되었어요 :)',
          );
          Navigator.pop(context);
          Navigator.pop(context, true);
        },
      );
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
  }) {
    try {
      commonLoadingAlert(
        context: context,
        loadingAction: () async {
          await repository.updateRecommendFeed(
            userId: userId,
            recommendationFeedId: recommendationFeedId,
            body: body,
            context: context,
          );

          if (!mounted) return;

          showCommonSnackBarMessage(
            context: context,
            snackBarText: '추천 피드가 수정되었어요 :)',
          );
          Navigator.pop(context);
          Navigator.pop(context, true);
        },
      );
    } on DioException catch (err) {
      throw Exception(err);
    }
  }

  void deleteRecommendFeed({
    required String userId,
    required int recommendationFeedId,
    required BuildContext context,
    required void Function() afterSuccessDelete,
  }) async {
    try {
      commonLoadingAlert(
        context: context,
        loadingAction: () async {
          await repository.deleteRecommendFeed(
            userId: userId,
            recommendationFeedId: recommendationFeedId,
            context: context,
          );

          if (!mounted) return;

          Navigator.pop(context);

          showCommonSnackBarMessage(
            context: context,
            snackBarText: '추천 피드가 삭제되었어요 !',
          );

          afterSuccessDelete();
        },
      );
    } on DioException catch (err) {
      throw Exception(err);
    }
  }
}
