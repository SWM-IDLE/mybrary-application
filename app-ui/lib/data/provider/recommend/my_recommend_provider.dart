import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/recommend/my_recommend_model.dart';
import 'package:mybrary/data/repository/recommend_repository.dart';

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
  }) async {
    if (state is! CommonModel) {
      state = await repository.createRecommendFeed(
        userId: userId,
        body: body,
      );
    }

    if (state is! CommonModel) {
      return;
    }
  }
}
