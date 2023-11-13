import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/search/book_recommendation_feed_users_model.dart';
import 'package:mybrary/data/repository/search_new_repository.dart';

final searchRecommendationFeedUsersInfoProvider =
    Provider<BookRecommendationFeedUsersModel?>((ref) {
  final state = ref.watch(searchRecommendationFeedUsersProvider);

  if (state is! CommonModel) {
    return null;
  }

  return state.data;
});

final searchRecommendationFeedUsersProvider = StateNotifierProvider<
    SearchRecommendationFeedUsersStateNotifier, CommonResponseBase>((ref) {
  final repo = ref.watch(searchBookServiceRepositoryProvider);

  final notifier = SearchRecommendationFeedUsersStateNotifier(
    repository: repo,
  );

  return notifier;
});

class SearchRecommendationFeedUsersStateNotifier
    extends StateNotifier<CommonResponseBase> {
  final SearchNewRepository repository;

  SearchRecommendationFeedUsersStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void getRecommendationFeedsUserInfos(String isbn13) async {
    if (state is! CommonModel) {
      state = await repository.getRecommendationFeedsUserInfos(isbn13: isbn13);
    }

    if (state is! CommonModel) {
      return;
    }
  }
}
