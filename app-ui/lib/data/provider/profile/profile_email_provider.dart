import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/profile/profile_email_model.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/data/repository/profile_new_repository.dart';

final profileEmailProvider = Provider<ProfileEmailModel?>((ref) {
  final state = ref.watch(profileProvider);

  if (state is! CommonModel) {
    return null;
  }

  return state.data;
});

final profileProvider =
    StateNotifierProvider<ProfileEmailStateNotifier, CommonResponseBase>((ref) {
  final repo = ref.watch(profileRepositoryProvider);

  final notifier = ProfileEmailStateNotifier(
    repository: repo,
  );

  return notifier;
});

class ProfileEmailStateNotifier extends StateNotifier<CommonResponseBase> {
  final ProfileNewRepository repository;

  ProfileEmailStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void getUserEmail() async {
    if (state is! CommonModel) {
      state = await repository.getUserEmail(userId: UserState.userId);
    }

    if (state is! CommonModel) {
      return;
    }
  }
}
