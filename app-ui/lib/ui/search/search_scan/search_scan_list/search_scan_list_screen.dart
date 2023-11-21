import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:mybrary/data/model/search/book_search_response_model.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/utils/logics/book_utils.dart';

List<BookSearchResultModel> testData = [
  BookSearchResultModel.fromJson({
    "title": "자바의 정석",
    "description": "자바의 정석 3판",
    "author": "남궁성",
    "isbn13": "9788980782970",
    "thumbnailUrl":
        "https://bookthumb-phinf.pstatic.net/cover/150/077/15007773.jpg?type=m1&udate=20180726",
    "publicationDate": "2008-08-01",
    "starRating": 0
  }),
  BookSearchResultModel.fromJson({
    "title": "자바의 정석",
    "description": "자바의 정석 3판",
    "author": "남궁성",
    "isbn13": "9788980782970",
    "thumbnailUrl":
        "https://bookthumb-phinf.pstatic.net/cover/150/077/15007773.jpg?type=m1&udate=20180726",
    "publicationDate": "2008-08-01",
    "starRating": 0
  }),
  BookSearchResultModel.fromJson({
    "title": "자바의 정석",
    "description": "자바의 정석 3판",
    "author": "남궁성",
    "isbn13": "9788980782970",
    "thumbnailUrl":
        "https://bookthumb-phinf.pstatic.net/cover/150/077/15007773.jpg?type=m1&udate=20180726",
    "publicationDate": "2008-08-01",
    "starRating": 0
  }),
  BookSearchResultModel.fromJson({
    "title": "자바의 정석",
    "description": "자바의 정석 3판",
    "author": "남궁성",
    "isbn13": "9788980782970",
    "thumbnailUrl":
        "https://bookthumb-phinf.pstatic.net/cover/150/077/15007773.jpg?type=m1&udate=20180726",
    "publicationDate": "2008-08-01",
    "starRating": 0
  }),
  BookSearchResultModel.fromJson({
    "title": "자바의 정석",
    "description": "자바의 정석 3판",
    "author": "남궁성",
    "isbn13": "9788980782970",
    "thumbnailUrl":
        "https://bookthumb-phinf.pstatic.net/cover/150/077/15007773.jpg?type=m1&udate=20180726",
    "publicationDate": "2008-08-01",
    "starRating": 0
  }),
];

class SearchScanListScreen extends StatefulWidget {
  const SearchScanListScreen({super.key});

  @override
  State<SearchScanListScreen> createState() => _SearchScanListScreenState();
}

class _SearchScanListScreenState extends State<SearchScanListScreen> {
  @override
  Widget build(BuildContext context) {
    return SubPageLayout(
      appBarTitle: '마이북 스캔 결과',
      appBarActions: [
        TextButton(
          onPressed: () async {},
          style: disableAnimationButtonStyle,
          child: const Text(
            '담기',
            style: saveTextButtonStyle,
          ),
        ),
      ],
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '검색 도서 ${testData.length}권',
                      style: commonSubBoldStyle.copyWith(
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      '전체 선택',
                      style: commonSubRegularStyle.copyWith(
                        fontSize: 13.0,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              const Divider(
                thickness: 2,
                height: 1,
                color: greyDDDDDD,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: testData.length,
              itemBuilder: (context, index) {
                final searchBookData = testData[index];
                final DateTime publishDate =
                    getPublishDate(searchBookData.publicationDate);

                return Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                height: 126,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 86,
                                      height: 126,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: greyF1F2F5,
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            searchBookData.thumbnailUrl,
                                          ),
                                          onError: (exception, stackTrace) =>
                                              Image.asset(
                                            'assets/img/logo/mybrary.png',
                                            fit: BoxFit.fill,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12.0),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                parse(searchBookData.title)
                                                    .documentElement!
                                                    .text,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textWidthBasis:
                                                    TextWidthBasis.parent,
                                                style: searchBookTitleStyle,
                                              ),
                                              const SizedBox(height: 4.0),
                                              bookInfo(
                                                infoText: parse(searchBookData
                                                        .description)
                                                    .documentElement!
                                                    .text,
                                                fontSize: 13.0,
                                                fontColor: bookDescriptionColor,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              bookInfo(
                                                infoText: searchBookData.author,
                                                fontSize: 13.0,
                                                fontColor: bookDescriptionColor,
                                              ),
                                              const SizedBox(height: 1.0),
                                              bookInfo(
                                                infoText:
                                                    '${publishDate.year}.${publishDate.month}',
                                                fontSize: 13.0,
                                                fontColor: bookDescriptionColor,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      if (index != testData.length - 1)
                        const Divider(
                          thickness: 1,
                          height: 1,
                          color: greyF1F2F5,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bookInfo({
    required String infoText,
    required double fontSize,
    Color? fontColor,
    FontWeight? fontWeight,
  }) {
    return Text(
      infoText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textWidthBasis: TextWidthBasis.parent,
      style: TextStyle(
        color: fontColor ?? commonBlackColor,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w500,
      ),
    );
  }
}
