import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart';
import 'package:mybrary/data/model/search/book_search_response_model.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/utils/logics/book_utils.dart';

List<BookSearchResultModel> testData = [
  BookSearchResultModel.fromJson({
    "title": "곽수종 박사의 경제대예측 2024-2028",
    "description":
        "세계경제, 특히 미국과 중국 경제의 위기와 기회를 다루며, 각기 거시적, 미시적 요인을 살펴봄으로써 한국경제는 미중 간 경쟁에서 어떻게 살아남을 수 있을지를 이야기한다. 경제학의 모태는 철학이라는 모토 아래, 자연과학과 사회과학을 넘나들며 세계경제 흐름에 대해 해박한 지식과 탁월한 분석력을 보여주는 책이다.",
    "author": "곽수종 (지은이)",
    "isbn13": "9791160024142",
    "thumbnailUrl":
        "https://image.aladin.co.kr/product/32637/18/cover150/k332935651_3.jpg",
    "publicationDate": "2023-11-01",
    "starRating": 5.0
  }),
  BookSearchResultModel.fromJson({
    "title": "스태그플레이션 2024 경제전망 - 2024년을 결정지을 20대 경제트렌드",
    "description":
        "세계 경제의 동향과 스태그플레이션의 주요 원인들을 탐구한다. 또한, 윤석렬 정부의 ‘신성장 4.0’ 전략을 포함한 대응 전략과 2024년 산업의 핵심 이슈들을 다룬다. 2024년 경제전망의 키워드는 '상흔점'이다.",
    "author": "김광석 (지은이)",
    "isbn13": "9791197603662",
    "thumbnailUrl":
        "https://image.aladin.co.kr/product/32531/70/cover150/k592935025_1.jpg",
    "publicationDate": "2023-10-20",
    "starRating": 5.0
  }),
  BookSearchResultModel.fromJson({
    "title": "경제위기 투자 바이블 - 불확실한 시기, 확실한 투자전략",
    "description":
        "김앤장 출신 변호사이자 회계사, 감정평가사로 주식투자 분야 스테디셀러 작가인 곽상빈과 경제 예측 적중률 100%로 ‘한국의 마이클 버리’라 불리는 천만 경제 유튜버 빅쇼트 김피비가 경제위기의 신호를 포착하는 방법, 경제위기의 역사와 그 원인, 경제위기에 특별히 통하는 투자나 경제위기 전과 후에 투자자로서 어떤 것들을 준비하고 대비해야 하는지, 재산을 불리는 투자원리는 무엇인지 등을 자세하게 설명했다.",
    "author": "곽상빈, 김피비 (지은이)",
    "isbn13": "9788973435678",
    "thumbnailUrl":
        "https://image.aladin.co.kr/product/32656/45/cover150/8973435671_1.jpg",
    "publicationDate": "2023-11-30",
    "starRating": 5.0
  }),
  BookSearchResultModel.fromJson({
    "title": "이진우 기자의 몬말리는 경제 모험 1 - 처음 만나는 경제",
    "description":
        "&ltMBC 손에 잡히는 경제&gt 이진우 기자는 어린이 독자들에게 경제 공부의 즐거움을 가르쳐 주고, 경제적 사고방식을 키우는 방향을 제시한다. 평소 다양한 경제 책을 접해 왔던 어린이들도 이 책을 통해 ‘돈’을 바라보는 새로운 감각을 배울 수 있을 것이다.",
    "author": "글몬 (지은이), 지문 (그림), 이진우 (기획)",
    "isbn13": "9791171170821",
    "thumbnailUrl":
        "https://image.aladin.co.kr/product/32489/62/cover150/k142935502_1.jpg",
    "publicationDate": "2023-09-20",
    "starRating": 5.0
  }),
  BookSearchResultModel.fromJson({
    "title": "경제기사 궁금증 300문 300답 - 불확실성의 시대, 경제기사 속에 답이 있다, 2023 개정증보판",
    "description":
        "경제를 전공하지 않은 독자라도 단시일에 경제를 보는 안목을 키울 수 있도록 경제 원리와 현실을 알기 쉽게 설명한 실용경제 입문서다. 경기, 물가, 금융, 증권, 외환, 국제수지와 무역, 경제지표 등 경제 각 분야에 대한 전반적인 지식에 우리나라 실물경기, 금융정책, 국제 유가 등 최신 경제기사 해설까지 덧붙였다.",
    "author": "곽해선 (지은이)",
    "isbn13": "9791191183214",
    "thumbnailUrl":
        "https://image.aladin.co.kr/product/30966/52/cover150/k192831203_1.jpg",
    "publicationDate": "2023-02-10",
    "starRating": 4.5
  }),
  BookSearchResultModel.fromJson({
    "title": "달러 투자 무작정 따라하기 - 단 한 번도 잃지 않은, 성공률 100%의 달러 투자 공식",
    "description":
        "달러 투자의 신 박성현 저자와 길벗의 무작정 따라하기가 만났다. 달러 투자를 위한 기초 지식부터 투자 원리, 매수 타이밍의 기준이 되는 데이터 보는 법, 세븐 스플릿하는 법 등 무작정 따라하기 코너를 통해 단계별로 하나씩 따라 하다 보면, 그리고 예제를 풀어가다 보면 달러 투자에 대해 완벽하게 이해할 수 있을 것이다.",
    "author": "박성현 (지은이)",
    "isbn13": "9791140706167",
    "thumbnailUrl":
        "https://image.aladin.co.kr/product/32400/2/cover150/k542935885_1.jpg",
    "publicationDate": "2023-09-20",
    "starRating": 5.0
  }),
];

class SearchScanListScreen extends StatefulWidget {
  const SearchScanListScreen({super.key});

  @override
  State<SearchScanListScreen> createState() => _SearchScanListScreenState();
}

class _SearchScanListScreenState extends State<SearchScanListScreen> {
  late List<String> _selectedSearchBooks = [];

  @override
  void initState() {
    super.initState();

    _selectedSearchBooks = [];
  }

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
                padding: const EdgeInsets.only(
                  top: 8.0,
                  right: 16.0,
                  bottom: 6.0,
                  left: 24.0,
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
                    InkWell(
                      onTap: () => _toggleSelectAllSearchBook(),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '전체 ${testData.length == _selectedSearchBooks.length ? '취소' : '선택'}',
                          style: commonSubRegularStyle.copyWith(
                            fontSize: 13.0,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
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
                  padding: EdgeInsets.only(
                    top: index == 0 ? 0.0 : 8.0,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () =>
                            _selectOrUnselectSearchBook(searchBookData),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: 126,
                            child: Row(
                              children: [
                                Stack(
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
                                    Positioned(
                                      top: 1,
                                      left: 1,
                                      child: SvgPicture.asset(
                                        'assets/svg/icon/small/checkbox_${_selectedSearchBooks.contains(searchBookData.isbn13) ? 'green' : 'grey'}.svg',
                                      ),
                                    ),
                                  ],
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
                                            infoText: parse(
                                                    searchBookData.description)
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

  void _selectOrUnselectSearchBook(BookSearchResultModel searchBookData) {
    setState(() {
      if (_selectedSearchBooks.contains(searchBookData.isbn13) == false) {
        _selectedSearchBooks.add(searchBookData.isbn13);
        return;
      }

      if (_selectedSearchBooks.contains(searchBookData.isbn13)) {
        _selectedSearchBooks
            .removeWhere((isbn13) => isbn13 == searchBookData.isbn13);
        return;
      }
    });
  }

  void _toggleSelectAllSearchBook() {
    setState(() {
      if (testData.length == _selectedSearchBooks.length) {
        _selectedSearchBooks.clear();
        return;
      }
      if (_selectedSearchBooks.isEmpty) {
        _selectedSearchBooks.addAll(testData.map((data) => data.isbn13));
        return;
      }
      if (_selectedSearchBooks.isNotEmpty) {
        Set<String> myBookSet = Set.from(_selectedSearchBooks);

        for (var data in testData) {
          myBookSet.add(data.isbn13);
        }

        _selectedSearchBooks = myBookSet.toList();

        return;
      }
    });
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
