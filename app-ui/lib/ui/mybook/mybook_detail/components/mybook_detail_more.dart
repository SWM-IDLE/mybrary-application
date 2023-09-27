import 'package:flutter/material.dart';
import 'package:mybrary/ui/search/search_detail/search_detail_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

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
              commonSubTitle(
                title: '도서 상세보기',
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
