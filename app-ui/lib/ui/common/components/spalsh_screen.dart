import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
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

    checkForUpdate();
  }

  void checkForUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastUpdateCheck = prefs.getString('lastUpdateCheck');
    final nowDateTime = DateTime.now();

    if (lastUpdateCheck == null ||
        nowDateTime.isAfter(
          DateTime.parse(lastUpdateCheck).add(
            const Duration(minutes: 1),
          ),
        )) {
      checkForUpdateAndShowUpdateAlert();
    }
  }

  void checkForUpdateAndShowUpdateAlert() async {
    FirebaseRemoteConfig remoteConfig = await getAppVersionConfig();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String minAppVersion = remoteConfig.getString('min_version');
    String latestAppVersion = remoteConfig.getString('latest_version');
    String currAppVersion = packageInfo.version;

    print('앱 최소 버전: $minAppVersion');
    print('앱 최신 버전: $latestAppVersion');
    print('앱 현재 버전: $currAppVersion');

    prefs.setString('lastUpdateCheck', DateTime.now().toIso8601String());

    if (parseAppVersion(currAppVersion) == parseAppVersion(latestAppVersion)) {
      UserState.localStorage.setBool('update', false);
      UserState.localStorage.setBool('forceUpdate', false);
      return;
    }

    if (parseAppVersion(minAppVersion) > parseAppVersion(currAppVersion)) {
      UserState.localStorage.setBool('forceUpdate', true);
      return;
    }

    if (parseAppVersion(latestAppVersion) > parseAppVersion(currAppVersion)) {
      UserState.localStorage.setBool('update', true);
      return;
    }

    UserState.localStorage.setBool('update', false);
    UserState.localStorage.setBool('forceUpdate', false);
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
      child: Stack(
        children: [
          Container(
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
        ],
      ),
    );
  }
}
