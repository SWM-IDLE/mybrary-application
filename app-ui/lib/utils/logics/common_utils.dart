import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/root_tab.dart';
import 'package:mybrary/ui/profile/user_profile/user_profile_screen.dart';

Widget loadingIndicator() {
  return CircularProgressIndicator(
    backgroundColor: primaryColor.withOpacity(0.2),
    valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
  );
}

Widget buildErrorPage({String? message}) {
  return Center(
    child: SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, color: grey777777),
          const SizedBox(height: 16.0),
          Text(
            message ?? '정보를 가져올 수 없습니다.\n인터넷 연결 상태를 확인해주세요.',
            textAlign: TextAlign.center,
            style: const TextStyle(height: 1.2, color: grey777777),
          ),
        ],
      ),
    ),
  );
}

SliverAppBar commonSliverAppBar({
  required String appBarTitle,
  List<Widget>? appBarActions,
}) {
  return SliverAppBar(
    elevation: 0,
    title: Text(appBarTitle),
    titleTextStyle: appBarTitleStyle.copyWith(
      fontSize: 16.0,
    ),
    pinned: true,
    centerTitle: true,
    backgroundColor: commonWhiteColor,
    foregroundColor: commonBlackColor,
    actions: appBarActions,
  );
}

Future<dynamic> showFollowButtonMessage({
  required BuildContext context,
  required String message,
}) {
  return showDialog(
    context: context,
    barrierColor: commonBlackColor.withOpacity(0.1),
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          width: 76.0,
          height: 38.0,
          decoration: BoxDecoration(
            color: grey262626.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              message,
              style: commonSubRegularStyle.copyWith(
                color: commonWhiteColor,
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget confirmButton({
  required GestureTapCallback? onTap,
  required String buttonText,
  required bool isCancel,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 46.0,
          decoration: BoxDecoration(
            color: isCancel ? greyF1F2F5 : commonRedColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: commonSubBoldStyle.copyWith(
                color: isCancel ? commonBlackColor : commonWhiteColor,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void showInterestBookMessage({
  required BuildContext context,
  required String snackBarText,
  Widget? snackBarAction,
}) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: Platform.isAndroid ? 22.0 : 16.0,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              snackBarText,
              style: commonSnackBarMessageStyle.copyWith(fontSize: 14.0),
            ),
            snackBarAction ?? const SizedBox(),
          ],
        ),
        duration: Duration(
          seconds: snackBarAction == null ? 1 : 2,
        ),
      ),
    );
  }
}

void commonBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  showModalBottomSheet(
    shape: bottomSheetStyle,
    backgroundColor: Colors.white,
    context: context,
    builder: (_) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28.0,
          ),
          child: child,
        ),
      );
    },
  );
}

Widget commonDivider() {
  return const Divider(
    height: 1,
    thickness: 1,
    color: greyF1F2F5,
  );
}

Widget commonSliverDivider() {
  return const SliverToBoxAdapter(
    child: Divider(
      height: 1,
      thickness: 1,
      color: greyF1F2F5,
    ),
  );
}

void nextToUserProfile({
  required BuildContext context,
  required String myUserId,
  required String userId,
  required String nickname,
}) {
  if (myUserId != userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UserProfileScreen(
          userId: userId,
          nickname: nickname,
        ),
      ),
    );
  }
  if (myUserId == userId) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const RootTab(
          tapIndex: 3,
        ),
      ),
      (route) => false,
    );
  }
}
