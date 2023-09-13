import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/books_by_category_model.dart';
import 'package:mybrary/data/repository/home_new_repository.dart';

final homeBestSellerProvider = Provider<BooksByCategoryModel?>((ref) {
  final state = ref.watch(bestSellerProvider);

  if (state is! CommonModel) {
    return null;
  }

  return state.data;
});

final bestSellerProvider =
    StateNotifierProvider<HomeBestSellerStateNotifier, CommonResponseBase>(
        (ref) {
  final repo = ref.watch(homeRepositoryProvider);

  final notifier = HomeBestSellerStateNotifier(
    repository: repo,
  );

  return notifier;
});

class HomeBestSellerStateNotifier extends StateNotifier<CommonResponseBase> {
  final HomeNewRepository repository;

  HomeBestSellerStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void getBooksByBestSeller() async {
    if (state is! CommonModel) {
      state = await repository.getBooksByCategory();
    }

    await repository.getBooksByCategory();
  }
}
