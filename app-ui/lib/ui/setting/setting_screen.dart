import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/config.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/profile/profile_edit/profile_edit_screen.dart';
import 'package:mybrary/ui/setting/components/account_withdrawal.dart';
import 'package:mybrary/ui/setting/components/login_info.dart';
import 'package:mybrary/utils/logics/common_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const secureStorage = FlutterSecureStorage();

    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: commonWhiteColor,
        elevation: 0,
        title: const Text('설정'),
        titleTextStyle: appBarTitleStyle.copyWith(
          fontSize: 17.0,
        ),
        centerTitle: true,
        foregroundColor: commonBlackColor,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '설정',
                      style: settingTitleStyle,
                    ),
                    const SizedBox(height: 12.0),
                    _settingTab(
                      tabTitle: '프로필 편집',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfileEditScreen(),
                          ),
                        );
                      },
                    ),
                    _settingTab(
                      tabTitle: '로그인 정보',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginInfo(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                    const Text(
                      '서비스 안내',
                      style: settingTitleStyle,
                    ),
                    const SizedBox(height: 12.0),
                    _settingTab(
                      tabTitle: '공지사항 / 업데이트 소식',
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(noticeAndUpdateLink),
                        );
                      },
                    ),
                    _settingTab(
                      tabTitle: '마이브러리 가이드',
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(mybraryGuideLink),
                        );
                      },
                    ),
                    _settingTab(
                      tabTitle: '1:1 문의하기',
                      onTap: () async {
                        await connectWebLink(
                          webLink: inquiryLink,
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                    const Text(
                      '법적 고지 및 정책',
                      style: settingTitleStyle,
                    ),
                    const SizedBox(height: 12.0),
                    _settingTab(
                      tabTitle: '마이브러리 이용약관',
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(mybraryTermsLink),
                        );
                      },
                    ),
                    _settingTab(
                      tabTitle: '개인정보 처리방침',
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(mybraryPrivacyLink),
                        );
                      },
                    ),
                    _settingTab(
                      tabTitle: '오픈소스 라이선스',
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(openSourceLicenseLink),
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                    const Text(
                      '기타',
                      style: settingTitleStyle,
                    ),
                    const SizedBox(height: 12.0),
                    _settingTab(
                      tabTitle: '리뷰로 응원하기',
                      onTap: () => connectAppStoreLink(),
                    ),
                    _settingTab(
                      tabTitle: '로그아웃',
                      onTap: () async {
                        await _showLogoutAlert(
                          context,
                          secureStorage,
                        );
                      },
                    ),
                    const SizedBox(height: 12.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AccountWithdrawal(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        child: const Text(
                          '탈퇴하기',
                          style: settingTitleStyle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _showLogoutAlert(
      BuildContext context, FlutterSecureStorage secureStorage) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '로그아웃',
            style: commonSubBoldStyle,
            textAlign: TextAlign.center,
          ),
          content: const Text(
            '정말 로그아웃 하시겠습니까?',
            style: confirmButtonTextStyle,
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.only(
            top: 24.0,
            bottom: 16.0,
          ),
          actionsAlignment: MainAxisAlignment.center,
          buttonPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          actions: [
            Row(
              children: [
                confirmButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  buttonText: '취소',
                  isCancel: true,
                ),
                confirmButton(
                  onTap: () async {
                    await secureStorage.deleteAll();

                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/signin',
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  buttonText: '로그아웃',
                  isCancel: false,
                  confirmButtonColor: commonRedColor,
                  confirmButtonText: commonWhiteColor,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Container _settingTab({
    required String tabTitle,
    required GestureTapCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 16.0,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              tabTitle,
              style: settingSubTitleStyle,
            ),
            SvgPicture.asset(
              'assets/svg/icon/profile_menu_arrow.svg',
            ),
          ],
        ),
      ),
    );
  }
}
