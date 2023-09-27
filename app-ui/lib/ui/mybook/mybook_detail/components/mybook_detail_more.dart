import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/search/search_detail/search_detail_screen.dart';

class MyBookDetailMore extends StatelessWidget {
  final String isbn13;

  const MyBookDetailMore({
    required this.isbn13,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SearchDetailScreen(isbn13: isbn13),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '도서 상세보기',
                    style: commonSubTitleStyle,
                  ),
                  SizedBox(
                    child: SvgPicture.asset(
                      'assets/svg/icon/right_arrow.svg',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
