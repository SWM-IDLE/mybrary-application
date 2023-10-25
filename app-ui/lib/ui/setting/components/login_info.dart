import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/provider/profile/profile_email_provider.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';

class LoginInfo extends ConsumerStatefulWidget {
  const LoginInfo({super.key});

  @override
  ConsumerState<LoginInfo> createState() => _LoginInfoState();
}

class _LoginInfoState extends ConsumerState<LoginInfo> {
  @override
  void initState() {
    super.initState();

    ref.read(profileProvider.notifier).getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    final profileEmail = ref.watch(profileEmailProvider);

    if (profileEmail == null) {
      return const SubPageLayout(
        appBarTitle: '로그인 정보',
        child: CircularLoading(),
      );
    }

    return SubPageLayout(
      appBarTitle: '로그인 정보',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '현재 로그인한 소셜 로그인 정보입니다.',
              style: commonSubRegularStyle,
            ),
            const SizedBox(height: 16.0),
            const Text(
              '이메일',
              style: commonSubMediumStyle,
            ),
            const SizedBox(height: 12.0),
            Text(
              profileEmail.email,
              style: commonSubRegularStyle,
            ),
          ],
        ),
      ),
    );
  }
}
