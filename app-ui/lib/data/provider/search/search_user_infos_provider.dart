import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/search/book_detail_user_infos_model.dart';
import 'package:mybrary/data/repository/search_new_repository.dart';

final searchUserInfoListProvider = Provider<BookDetailUserInfosModel?>((ref) {
  final state = ref.watch(searchUserInfosProvider);

  if (state is! CommonModel) {
    return null;
  }

  return state.data;
});

final searchUserInfosProvider =
    StateNotifierProvider<SearchUserInfosStateNotifier, CommonResponseBase>(
        (ref) {
  final repo = ref.watch(searchBookServiceRepositoryProvider);

  final notifier = SearchUserInfosStateNotifier(
    repository: repo,
  );

  return notifier;
});

class SearchUserInfosStateNotifier extends StateNotifier<CommonResponseBase> {
  final SearchNewRepository repository;

  SearchUserInfosStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void getInterestBookUserInfos(String isbn13) async {
    if (state is! CommonModel) {
      state = await repository.getInterestBookUserInfos(isbn13: isbn13);
    }

    if (state is! CommonModel) {
      return;
    }
  }

  void getReadCompleteBookUserInfos(String isbn13) async {
    if (state is! CommonModel) {
      state = await repository.getReadCompleteBookUserInfos(isbn13: isbn13);
    }

    if (state is! CommonModel) {
      return;
    }
  }

  void getMyBookUserInfos(String isbn13) async {
    if (state is! CommonModel) {
      state = await repository.getMyBookUserInfos(isbn13: isbn13);
    }

    if (state is! CommonModel) {
      return;
    }
  }

  void getRecommendationFeedsUserInfos(String isbn13) async {
    if (state is! CommonModel) {
      state = await repository.getRecommendationFeedsUserInfos(isbn13: isbn13);
    }

    if (state is! CommonModel) {
      return;
    }
  }
}
