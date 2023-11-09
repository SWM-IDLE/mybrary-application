import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/profile/user_report_model.dart';
import 'package:mybrary/data/repository/profile_new_repository.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

final userReportProvider =
    StateNotifierProvider<UserReportStateNotifier, CommonResponseBase>((ref) {
  final repo = ref.watch(profileRepositoryProvider);

  final notifier = UserReportStateNotifier(
    repository: repo,
  );

  return notifier;
});

class UserReportStateNotifier extends StateNotifier<CommonResponseBase> {
  final ProfileNewRepository repository;

  UserReportStateNotifier({
    required this.repository,
  }) : super(CommonResponseLoading());

  void createUserReport({
    required String userId,
    required UserReportModel body,
    required BuildContext context,
  }) async {
    try {
      await repository.createUserReport(
        context: context,
        userId: userId,
        body: body,
      );

      if (!mounted) return;
      commonLoadingAlert(
        context: context,
        loadingAction: () async {
          showCommonSnackBarMessage(
            context: context,
            snackBarText: '신고가 정상적으로 접수되었습니다.',
          );
          Navigator.pop(context);
        },
      );
    } on DioException catch (err) {
      log(err.toString());
      throw Exception('신고 접수에 실패했습니다.');
    }
  }
}
