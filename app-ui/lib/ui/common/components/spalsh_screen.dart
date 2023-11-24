import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/utils/dios/auth_dio.dart';
import 'package:mybrary/utils/logics/future_utils.dart';
import 'package:mybrary/utils/logics/parse_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    checkForUpdateAlert();
  }

  void updateFcmToken() async {
    final dio = await authDio(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final updateFcmTokenResponse = await dio.post(
      'http://13.125.198.36:8080/api/v1/users/device-token',
      options: Options(
        headers: {'User-Id': prefs.getString('userId')},
      ),
      data: {
        'userDeviceToken': await getToken(),
      },
    );

    log('FCM 토큰 업데이트 응답값: $updateFcmTokenResponse');
  }

  void checkForUpdateAlert() async {
    FirebaseRemoteConfig remoteConfig = await getAppVersionConfig();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final lastUpdateCheck = prefs.getString('lastUpdateCheck');
    final nowDateTime = DateTime.now();

    String minAppVersion = remoteConfig.getString('min_version');
    String latestAppVersion = remoteConfig.getString('latest_version');
    String currAppVersion = packageInfo.version;

    if (parseAppVersion(currAppVersion) == parseAppVersion(latestAppVersion)) {
      _updateLastCheckTime(prefs);
      _notUpdate(prefs);
      return;
    }

    if (_isAfterLastUpdateCheckTime(lastUpdateCheck, nowDateTime)) {
      updateFcmToken();
      _updateLastCheckTime(prefs);

      if (parseAppVersion(minAppVersion) > parseAppVersion(currAppVersion)) {
        prefs.setBool('forceUpdate', true);
        return;
      }

      if (parseAppVersion(latestAppVersion) > parseAppVersion(currAppVersion)) {
        prefs.setBool('update', true);
        return;
      }

      _notUpdate(prefs);
    }
  }

  bool _isAfterLastUpdateCheckTime(
      String? lastUpdateCheck, DateTime nowDateTime) {
    return lastUpdateCheck == null ||
        nowDateTime.isAfter(
          DateTime.parse(lastUpdateCheck).add(
            const Duration(days: 1),
          ),
        );
  }

  void _updateLastCheckTime(SharedPreferences prefs) {
    prefs.setString('lastUpdateCheck', DateTime.now().toIso8601String());
  }

  void _notUpdate(SharedPreferences prefs) {
    prefs.setBool('update', false);
    prefs.setBool('forceUpdate', false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1.0;
      });
    });

    return DefaultLayout(
      backgroundColor: primaryColor,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: primaryColor,
        child: Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            child: SvgPicture.asset(
              'assets/svg/icon/mybrary_logo.svg',
              width: size.width * 0.13,
              height: size.width * 0.13,
            ),
          ),
        ),
      ),
    );
  }
}
