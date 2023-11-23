import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mybrary/data/model/search/multi_book_search_response_model.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/data/repository/book_repository.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/single_data_error.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/utils/dios/auth_dio.dart';
import 'package:mybrary/utils/logics/book_utils.dart';
import 'package:mybrary/utils/logics/common_utils.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class SearchScanListScreen extends StatefulWidget {
  final String multiBookImagePath;

  const SearchScanListScreen({required this.multiBookImagePath, super.key});

  @override
  State<SearchScanListScreen> createState() => _SearchScanListScreenState();
}

class _SearchScanListScreenState extends State<SearchScanListScreen> {
  final _bookRepository = BookRepository();

  late List<MultiBookSearchResultModel> multiBookSearchResults = [];
  late List<String> _selectedSearchBooks = [];

  late Future<List<dynamic>> _multiBookSearchResponseData;

  final _userId = UserState.userId;

  @override
  void initState() {
    super.initState();

    _selectedSearchBooks = [];
    _multiBookSearchResponseData = _postMultiBookScanResults();
  }

  Future<List<dynamic>> _postMultiBookScanResults() async {
    final dio = await authDio(context);
    final multiBookScanResults = await dio.post(
      '$baseUrl/multi-book-recog/upload',
      options: Options(
        contentType: 'multipart/form-data',
      ),
      data: FormData.fromMap(
        {
          'fileobject': await MultipartFile.fromFile(
            widget.multiBookImagePath,
            contentType: MediaType(
              'image',
              'jpg',
            ),
          ),
        },
      ),
    );

    log('다중 도서 검색 응답값: $multiBookScanResults');
    final MultiBookSearchResponse result = commonResponseResult(
      multiBookScanResults,
      () => MultiBookSearchResponse(
        status: multiBookScanResults.data['status'],
        message: multiBookScanResults.data['message'],
        data: multiBookScanResults.data['data'],
      ),
    );

    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return SubPageLayout(
      appBarTitle: '마이북 스캔 결과',
      appBarActions: [
        TextButton(
          onPressed: () async {
            if (_selectedSearchBooks.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('마이북에 담을 도서를 선택해주세요 :)'),
                ),
              );
              return;
            }
            if (_selectedSearchBooks.isNotEmpty) {
              _enrollMyBook(_selectedSearchBooks);
            }
          },
          style: disableAnimationButtonStyle,
          child: const Text(
            '담기',
            style: saveTextButtonStyle,
          ),
        ),
      ],
      child: FutureBuilder(
        future: _multiBookSearchResponseData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SingleDataError(
              errorMessage: '마이북 스캔 결과를\n불러오는데 실패했습니다.',
            );
          }
          if (snapshot.hasData) {
            multiBookSearchResults = parseListOfModels(snapshot.data);
            return Column(
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
                            '검색 도서 ${multiBookSearchResults.length}권',
                            style: commonSubBoldStyle.copyWith(
                              fontSize: 15.0,
                            ),
                          ),
                          InkWell(
                            onTap: () => _toggleSelectAllSearchBook(),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                '전체 ${multiBookSearchResults.length == _selectedSearchBooks.length ? '취소' : '선택'}',
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
                    itemCount: multiBookSearchResults.length,
                    itemBuilder: (context, index) {
                      final searchBookData = multiBookSearchResults[index];
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
                                                onError:
                                                    (exception, stackTrace) =>
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  fontColor:
                                                      bookDescriptionColor,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                bookInfo(
                                                  infoText:
                                                      searchBookData.author,
                                                  fontSize: 13.0,
                                                  fontColor:
                                                      bookDescriptionColor,
                                                ),
                                                const SizedBox(height: 1.0),
                                                bookInfo(
                                                  infoText:
                                                      '${publishDate.year}.${publishDate.month}',
                                                  fontSize: 13.0,
                                                  fontColor:
                                                      bookDescriptionColor,
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
                            if (index != multiBookSearchResults.length - 1)
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
            );
          }
          return Image.asset(
            'assets/img/icon/loading_eve.gif',
            width: mediaQueryWidth(context),
            height: mediaQueryHeight(context),
          );
        },
      ),
    );
  }

  void _selectOrUnselectSearchBook(MultiBookSearchResultModel searchBookData) {
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
      if (multiBookSearchResults.length == _selectedSearchBooks.length) {
        _selectedSearchBooks.clear();
        return;
      }
      if (_selectedSearchBooks.isEmpty) {
        _selectedSearchBooks
            .addAll(multiBookSearchResults.map((data) => data.isbn13));
        return;
      }
      if (_selectedSearchBooks.isNotEmpty) {
        Set<String> myBookSet = Set.from(_selectedSearchBooks);

        for (var data in multiBookSearchResults) {
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

  List<MultiBookSearchResultModel> parseListOfModels(List<dynamic>? list) {
    return list!
        .map((item) => MultiBookSearchResultModel.fromJson(item))
        .toList();
  }

  void _enrollMyBook(List<String> bookList) async {
    commonLoadingAlert(
      context: context,
      loadingAction: () async {
        for (var isbn13 in bookList) {
          await _bookRepository.createMyBook(
            context: context,
            userId: _userId,
            isbn13: isbn13,
          );
        }

        if (!mounted) return;

        showCommonSnackBarMessage(
          context: context,
          snackBarText: '마이북이 모두 담아졌어요 :)',
        );
        Navigator.pop(context);
        Navigator.pop(context, true);
      },
    );
  }
}
