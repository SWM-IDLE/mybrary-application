import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/today_registered_book_count_model.dart';
import 'package:mybrary/data/repository/home_new_repository.dart';

final todayRegisteredBookCountProvider =
    Provider<TodayRegisteredBookCountModel?>((ref) {
  final state = ref.watch(homeProvider);

  if (state is! CommonModel) {
    return null;
  }

  return state.data;
});

final homeProvider =
    StateNotifierProvider<HomeStateNotifier, CommonResponseBase>((ref) {
  final repo = ref.watch(homeRepositoryProvider);

  final notifier = HomeStateNotifier(
    repository: repo,
  );

  return notifier;
});

class HomeStateNotifier extends StateNotifier<CommonResponseBase> {
  final HomeNewRepository repository;

  HomeStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void getTodayRegisteredBookCount() async {
    if (state is! CommonModel) {
      state = await repository.getTodayRegisteredBookCount();
    }

    await repository.getTodayRegisteredBookCount();
  }
}
