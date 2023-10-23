import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/style.dart';

class UserCount extends StatelessWidget {
  final int userCount;

  const UserCount({
    required this.userCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '총 $userCount명',
              style: commonSubBoldStyle.copyWith(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
