import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/utils/logics/future_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

    Future.delayed(
      const Duration(seconds: 1),
      () => checkForUpdate(),
    );
  }

  void checkForUpdate() async {
    FirebaseRemoteConfig remoteConfig = await getAppVersionConfig();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String minAppVersion = remoteConfig.getString('min_version');
    String latestAppVersion = remoteConfig.getString('latest_version');
    String currAppVersion = packageInfo.version;

    print(minAppVersion);
    print(latestAppVersion);
    print(currAppVersion);
    print(int.parse(latestAppVersion.split('.').join()));
    print(int.parse(currAppVersion.split('.').join()));

    if (!mounted) return;

    if (int.parse(latestAppVersion.split('.').join()) >
        int.parse(currAppVersion.split('.').join())) {
      UserState.localStorage.setBool('update', true);
      return;
    }

    if (int.parse(minAppVersion.split('.').join()) >
        int.parse(currAppVersion.split('.').join())) {
      UserState.localStorage.setBool('forceUpdate', true);
      return;
    }
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
