import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/today_registered_book_count_model.dart';
import 'package:mybrary/data/repository/home_new_repository.dart';

final homeBookCountListProvider =
    Provider<TodayRegisteredBookListModel?>((ref) {
  final state = ref.watch(homeBookServiceProvider);

  if (state is! CommonModel) {
    return null;
  }

  return state.data;
});

final homeBookServiceProvider =
    StateNotifierProvider<HomeBookCountListStateNotifier, CommonResponseBase>(
        (ref) {
  final repo = ref.watch(homeBookServiceRepositoryProvider);

  final notifier = HomeBookCountListStateNotifier(
    repository: repo,
  );

  return notifier;
});

class HomeBookCountListStateNotifier extends StateNotifier<CommonResponseBase> {
  final HomeNewRepository repository;

  HomeBookCountListStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void getTodayRegisteredBookList() async {
    if (state is! CommonModel) {
      state = await repository.getTodayRegisteredBookList();
    }

    if (state is! CommonModel) {
      return;
    }
  }
}
