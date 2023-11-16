import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/search/search_book_list/search_book_list.dart';

class SearchPopularKeyword extends StatefulWidget {
  final TextEditingController bookSearchKeywordController;

  const SearchPopularKeyword({
    required this.bookSearchKeywordController,
    super.key,
  });

  @override
  State<SearchPopularKeyword> createState() => _SearchPopularKeywordState();
}

class _SearchPopularKeywordState extends State<SearchPopularKeyword> {
  List<String> popularSearchKeyword = [
    '쇼펜하우어',
    '세이노',
    '트렌드',
    '역행자',
    '히가시노 게이고',
    '단 한 사람',
    '1%를 읽는 힘',
    '더 마인드',
  ];

  @override
  void initState() {
    super.initState();

    shufflePopularSearchKeyword();
  }

  void shufflePopularSearchKeyword() {
    final random = Random();
    setState(() {
      popularSearchKeyword.shuffle(random);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '인기 검색어',
            style: commonSubBoldStyle.copyWith(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(
              popularSearchKeyword.length,
              (index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchBookList(
                        searchKeyword: popularSearchKeyword[index],
                      ),
                    ),
                  ).then(
                    (value) => widget.bookSearchKeywordController.clear(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: greyBCBCBC,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    popularSearchKeyword[index],
                    style: popularKeywordTextStyle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
