import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';

class LoginInfo extends StatefulWidget {
  const LoginInfo({super.key});

  @override
  State<LoginInfo> createState() => _LoginInfoState();
}

class _LoginInfoState extends State<LoginInfo> {
  @override
  Widget build(BuildContext context) {
    return const SubPageLayout(
      appBarTitle: '로그인 정보',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '현재 로그인한 소셜 로그인 정보입니다.',
              style: commonSubRegularStyle,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              '이메일',
              style: commonSubMediumStyle,
            ),
          ],
        ),
      ),
    );
  }
}
