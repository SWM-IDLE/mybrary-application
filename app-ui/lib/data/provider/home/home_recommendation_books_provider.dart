import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/books_params.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/books_by_interest_model.dart';
import 'package:mybrary/data/repository/home_new_repository.dart';

final homeRecommendationBooksProvider = Provider<BooksByInterestModel?>((ref) {
  final state = ref.watch(recommendationBooksProvider);

  if (state is! CommonModel) {
    return null;
  }

  return state.data;
});

final recommendationBooksProvider = StateNotifierProvider<
    HomeRecommendationBooksStateNotifier, CommonResponseBase>((ref) {
  final repo = ref.watch(homeUserServiceRepositoryProvider);

  final notifier = HomeRecommendationBooksStateNotifier(
    repository: repo,
  );

  return notifier;
});

class HomeRecommendationBooksStateNotifier
    extends StateNotifier<CommonResponseBase> {
  final HomeNewRepository repository;

  HomeRecommendationBooksStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void getBooksByFirstInterests() async {
    if (state is! CommonModel) {
      state = await repository.getBooksByInterest(type: 'Bestseller');
    }

    if (state is! CommonModel) {
      return;
    }
  }

  void getBooksByInterests({
    int? categoryId,
  }) async {
    if (state is! CommonModel) {
      state = await repository.getBooksByCategory(
        booksParams: BooksParams(
          type: 'Bestseller',
          categoryId: categoryId,
        ),
      );
    }

    if (state is! CommonModel) {
      return;
    }
  }
}
