import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/recommend/my_recommend_feed_model.dart';
import 'package:mybrary/data/repository/recommend_repository.dart';

final myRecommendFeedProvider = Provider<MyRecommendFeedModel?>((ref) {
  final state = ref.watch(recommendProvider);

  if (state is! CommonModel) {
    return null;
  }

  return state.data;
});

final recommendProvider =
    StateNotifierProvider<MyRecommendPostStateNotifier, CommonResponseBase>(
        (ref) {
  final repo = ref.watch(recommendRepositoryProvider);

  final notifier = MyRecommendPostStateNotifier(
    repository: repo,
  );

  return notifier;
});

class MyRecommendPostStateNotifier extends StateNotifier<CommonResponseBase> {
  final RecommendRepository repository;

  MyRecommendPostStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void getMyRecommendPostList({
    required String userId,
  }) async {
    try {
      if (state is! CommonModel) {
        state = await repository.getMyRecommendPostList(
          userId: userId,
        );
      }
    } on DioException catch (err) {
      throw Exception(err);
    }
  }
}
