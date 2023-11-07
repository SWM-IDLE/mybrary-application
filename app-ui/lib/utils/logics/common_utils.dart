import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/config.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/root_tab.dart';
import 'package:mybrary/ui/profile/user_profile/user_profile_screen.dart';
import 'package:mybrary/ui/search/search_detail/search_detail_screen.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Color? confirmButtonColor = greyF1F2F5,
  Color? confirmButtonText = commonBlackColor,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 46.0,
          decoration: BoxDecoration(
            color: isCancel ? greyF1F2F5 : confirmButtonColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: commonSubBoldStyle.copyWith(
                color: isCancel ? commonBlackColor : confirmButtonText,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void showCommonSnackBarMessage({
  required BuildContext context,
  required String snackBarText,
  Widget? snackBarAction,
}) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: isAndroid ? 22.0 : 16.0,
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
        duration: const Duration(
          seconds: 2,
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

Widget commonDivider({
  double? dividerHeight,
  double? dividerThickness,
  Color? dividerColor,
}) {
  return Divider(
    height: dividerHeight ?? 1,
    thickness: dividerThickness ?? 1,
    color: dividerColor ?? greyF1F2F5,
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

void moveToUserProfile({
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
          tapIndex: 4,
        ),
      ),
      (route) => false,
    );
  }
}

void moveToBookDetail({
  required BuildContext context,
  required String isbn13,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => SearchDetailScreen(isbn13: isbn13),
    ),
  );
}

Row commonSubTitle({
  required String title,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: commonSubTitleStyle,
      ),
      SizedBox(
        child: SvgPicture.asset(
          'assets/svg/icon/right_arrow.svg',
        ),
      ),
    ],
  );
}

void commonShowConfirmOrCancelDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String cancelButtonText,
  required void Function()? cancelButtonOnTap,
  required String confirmButtonText,
  required void Function()? confirmButtonOnTap,
  required Color confirmButtonColor,
  required Color confirmButtonTextColor,
}) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: commonSubBoldStyle,
          textAlign: TextAlign.center,
        ),
        content: Text(
          content,
          style: confirmButtonTextStyle,
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.all(16.0),
        actionsAlignment: MainAxisAlignment.center,
        buttonPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        actions: [
          Row(
            children: [
              confirmButton(
                onTap: () {
                  cancelButtonOnTap!();
                },
                buttonText: cancelButtonText,
                isCancel: true,
              ),
              confirmButton(
                onTap: () {
                  confirmButtonOnTap!();
                },
                buttonText: confirmButtonText,
                isCancel: false,
                confirmButtonColor: confirmButtonColor,
                confirmButtonText: confirmButtonTextColor,
              ),
            ],
          ),
        ],
      );
    },
  );
}

void commonShowConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmButtonText,
  required Color confirmButtonColor,
  required Color confirmButtonTextColor,
  required void Function()? confirmButtonOnTap,
}) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: commonSubBoldStyle,
        textAlign: TextAlign.center,
      ),
      content: Text(
        content,
        style: confirmButtonTextStyle,
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.all(16.0),
      actionsAlignment: MainAxisAlignment.center,
      buttonPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      actions: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: confirmButtonColor,
                foregroundColor: confirmButtonTextColor,
              ),
              onPressed: () {
                confirmButtonOnTap!();
              },
              child: Text(
                confirmButtonText,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<void> connectWebLink({
  required String webLink,
}) async {
  String url = webLink;
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_self',
    );
  }
}

void connectAppStoreLink() async {
  if (isAndroid) {
    await connectWebLink(
      webLink: androidAppLink,
    );
  }
  if (isIOS) {
    await connectWebLink(
      webLink: iosAppLink,
    );
  }
}
