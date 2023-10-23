import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/style.dart';

class HomeRecommendBooksHeader extends StatelessWidget {
  const HomeRecommendBooksHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          top: 16.0,
          bottom: 12.0,
        ),
        child: Row(
          children: [
            Text(
              '추천 도서, ',
              style: commonSubBoldStyle,
            ),
            Text(
              '이건 어때요?',
              style: commonMainRegularStyle,
            ),
          ],
        ),
      ),
    );
  }
}
