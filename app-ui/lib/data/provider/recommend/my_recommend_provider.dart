import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/recommend/my_recommend_model.dart';
import 'package:mybrary/data/repository/recommend_repository.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

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
    } on DioException catch (err) {
      if (err.response!.data.toString().contains('RF-04')) {
        if (!mounted) return;
        showCommonSnackBarMessage(
          context: context,
          snackBarText: '해당 도서로 작성한 추천 피드가 존재합니다.',
        );
      }
    }
  }
}
