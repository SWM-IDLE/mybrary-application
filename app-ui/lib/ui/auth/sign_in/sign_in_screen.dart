import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/data/provider/home/home_bestseller_provider.dart';
import 'package:mybrary/data/provider/home/home_provider.dart';
import 'package:mybrary/data/provider/home/home_recommendation_books_provider.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_post_provider.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/config.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/auth/components/logo.dart';
import 'package:mybrary/ui/auth/components/oauth_button.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/common/layout/root_tab.dart';
import 'package:mybrary/utils/logics/parse_utils.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      systemDarkUiOverlayStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/logo/login_background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: DefaultLayout(
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Logo(
                  logoText: '도서의 가치를 발견할\n당신만의 도서관\n마이브러리',
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isIOS)
                          OAuthButton(
                            btnText: 'Apple로 로그인',
                            oauthType: 'apple',
                            btnBackgroundColor: commonBlackColor,
                            onTap: () => onTapOAuthLoginButton(API.appleLogin),
                          ),
                        const SizedBox(height: 10.0),
                        OAuthButton(
                          btnText: 'Google로 로그인',
                          oauthType: 'google',
                          btnBackgroundColor: greyF1F2F5,
                          onTap: () => onTapOAuthLoginButton(API.googleLogin),
                        ),
                        const SizedBox(height: 10.0),
                        OAuthButton(
                          btnText: '네이버로 로그인',
                          oauthType: 'naver',
                          btnBackgroundColor: naverLoginColor,
                          onTap: () => onTapOAuthLoginButton(API.naverLogin),
                        ),
                        const SizedBox(height: 10.0),
                        OAuthButton(
                          btnText: '카카오로 로그인',
                          oauthType: 'kakao',
                          btnBackgroundColor: kakaoLoginColor,
                          onTap: () => onTapOAuthLoginButton(API.kakaoLogin),
                        ),
                        const SizedBox(height: 70.0),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapOAuthLoginButton(API api) {
    signInOAuth(getApi(api));
  }

  Future<void> signInOAuth(String api) async {
    const secureStorage = FlutterSecureStorage();

    try {
      final url = Uri.parse('$api?redirect_url=$mybraryUrlScheme');

      final result = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: mybraryUrlScheme,
      );

      final accessToken =
          Uri.parse(result).queryParameters[accessTokenHeaderKey];
      final refreshToken =
          Uri.parse(result).queryParameters[refreshTokenHeaderKey];

      if (accessToken == null || refreshToken == null) {
        return showSignInFailDialog();
      }

      final jwtPayload = parseJwt(accessToken);

      await secureStorage.write(key: accessTokenKey, value: accessToken);
      await secureStorage.write(key: refreshTokenKey, value: refreshToken);

      if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
        UserState.localStorage.setString('userId', jwtPayload['loginId']);
        ref.refresh(homeProvider.notifier).getTodayRegisteredBookCount();
        ref.refresh(bestSellerProvider.notifier).getBooksByBestSeller();
        ref
            .refresh(recommendationBooksProvider.notifier)
            .getBooksByFirstInterests();
        ref
            .refresh(myRecommendProvider.notifier)
            .getRecommendFeedList(userId: jwtPayload['loginId']);
        ref
            .refresh(recommendProvider.notifier)
            .getMyRecommendPostList(userId: jwtPayload['loginId']);

        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const RootTab(),
          ),
          (route) => false,
        );
      }
    } on PlatformException catch (e) {
      log(e.toString());
      showSignInFailDialog();
    }
  }

  void showSignInFailDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            "마이브러리",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        content: const IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 8.0,
              children: [
                Text(
                  "잠시 후 다시 시도해주세요.",
                  style: commonSubMediumStyle,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "로그인 중에 오류가 발생하였습니다.\n지속적으로 발생할 경우,\n고객센터로 문의해주세요.",
                  style: commonSubRegularStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        contentPadding: const EdgeInsets.all(10),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              child: const Text(
                '확인',
                style: TextStyle(
                  color: commonWhiteColor,
                ),
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
