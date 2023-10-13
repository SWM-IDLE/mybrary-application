import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/utils/logics/future_utils.dart';

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
      () async {
        FirebaseRemoteConfig remoteConfig = await getAppVersionConfig();

        String minAppVersion = remoteConfig.getString('min_version');
        String latestAppVersion = remoteConfig.getString('latest_version');
      },
    );
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
