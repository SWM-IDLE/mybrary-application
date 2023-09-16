import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/style.dart';

class HomeIntro extends StatelessWidget {
  const HomeIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: const Text(
          '안녕하세요, 마이브러리에 오신 것을 환영합니다!\n마이북을 등록하고 나만의 도서관을 만들어보세요 📚',
          overflow: TextOverflow.ellipsis,
          style: mainIntroTextStyle,
        ),
      ),
    );
  }
}
