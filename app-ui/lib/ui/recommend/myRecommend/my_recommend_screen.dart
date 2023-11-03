import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/book/mybooks_response.dart';
import 'package:mybrary/data/model/recommend/my_recommend_model.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/mybook/mybook_list/mybook_list_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class MyRecommendScreen extends ConsumerStatefulWidget {
  const MyRecommendScreen({super.key});

  @override
  ConsumerState<MyRecommendScreen> createState() => _MyRecommendScreenState();
}

class _MyRecommendScreenState extends ConsumerState<MyRecommendScreen> {
  final _userId = UserState.userId;

  final TextEditingController _recommendKeywordListController =
      TextEditingController();
  final TextEditingController _recommendContentController =
      TextEditingController();

  late int _bookId;
  late String _thumbnailUrl;
  late String _bookTitle;
  late String _bookAuthor;
  late List<String> _recommendKeywordList;
  late bool _clearRecommendKeyword = false;

  @override
  void initState() {
    super.initState();

    _bookId = 0;
    _thumbnailUrl = '';
    _bookTitle = '';
    _bookAuthor = '';
    _recommendKeywordList = [];

    _recommendKeywordListController.addListener(_isClearRecommendKeyword);
  }

  void _isClearRecommendKeyword() {
    if (_recommendKeywordListController.text.isEmpty) {
      _clearRecommendKeyword = false;
    } else {
      _clearRecommendKeyword = true;
    }
  }

  @override
  void dispose() {
    _recommendKeywordListController.dispose();
    _recommendContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SubPageLayout(
      appBarTitle: '마이 추천',
      appBarActions: [
        TextButton(
          onPressed: () async {
            ref.watch(myRecommendProvider.notifier).createRecommendFeed(
                  userId: _userId,
                  body: MyRecommendModel(
                    myBookId: _bookId,
                    content: _recommendContentController.text,
                    recommendationTargetNames: _recommendKeywordList,
                  ),
                );
          },
          style: disableAnimationButtonStyle,
          child: const Text(
            '저장',
            style: saveTextButtonStyle,
          ),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 24.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (_thumbnailUrl == '') {
                                    await _addMyBookToMyRecommend(
                                      context: context,
                                    );
                                  }
                                },
                                child: Hero(
                                  tag: _bookId,
                                  child: Container(
                                    width: 100,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: greyF4F4F4,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                      image: _thumbnailUrl == ''
                                          ? null
                                          : DecorationImage(
                                              image: NetworkImage(
                                                _thumbnailUrl,
                                              ),
                                              onError:
                                                  (exception, stackTrace) =>
                                                      Image.asset(
                                                'assets/img/logo/mybrary.png',
                                                fit: BoxFit.fill,
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                      boxShadow: _thumbnailUrl == ''
                                          ? null
                                          : [
                                              const BoxShadow(
                                                color: Color(0x33000000),
                                                blurRadius: 10,
                                                offset: Offset(4, 4),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        _thumbnailUrl == '' ? '+ 책 추가' : '',
                                        style: recommendBookSubStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              if (_thumbnailUrl != '')
                                InkWell(
                                  onTap: () async {
                                    await _addMyBookToMyRecommend(
                                      context: context,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 2.0,
                                    ),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          width: 1.0,
                                          style: BorderStyle.solid,
                                          color: grey262626,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                    ),
                                    child: const Text(
                                      '책 변경하기',
                                      style: recommendBookEditStyle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 32.0),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12.0),
                                Text(
                                  _bookTitle == '' ? '책 제목' : _bookTitle,
                                  style: recommendBookTitleStyle,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  _bookAuthor == ''
                                      ? '마이북을 추가하여\n추천 피드를 작성해 보세요.'
                                      : _bookAuthor,
                                  style: recommendBookSubStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  commonDivider(
                    dividerColor: greyF7F7F7,
                    dividerThickness: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              '____',
                              style: recommendTitleStyle,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '에게 추천*',
                              style: recommendTitleStyle,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '최대 5개 키워드',
                              style: recommendSubStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _recommendKeywordListController,
                          cursorColor: primaryColor,
                          textInputAction: TextInputAction.done,
                          style: recommendEditStyle.copyWith(
                            color: grey262626,
                          ),
                          maxLength: 15,
                          readOnly:
                              _recommendKeywordList.length > 4 ? true : false,
                          scrollPadding: EdgeInsets.only(
                            bottom: bottomInset(context) * 0.5,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _clearRecommendKeyword = value.isNotEmpty;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                _recommendKeywordList.add(value);
                                _recommendKeywordListController.text = '';
                              }
                            });
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            hintText: '내가 추천하고 싶은 대상은? (15자 이내)',
                            hintStyle: recommendEditStyle.copyWith(
                              letterSpacing: -1,
                            ),
                            filled: true,
                            fillColor: _recommendKeywordList.length > 4
                                ? greyDDDDDD
                                : greyF7F7F7,
                            focusColor: greyF7F7F7,
                            border: searchInputBorderStyle,
                            focusedBorder: searchInputBorderStyle,
                            enabledBorder: searchInputBorderStyle,
                            counterText: '',
                            suffix: _recommendKeywordListController
                                    .text.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                        "${_recommendKeywordListController.text.length} / 15"),
                                  )
                                : null,
                            suffixIconConstraints: const BoxConstraints(
                              minHeight: 24.0,
                              minWidth: 24.0,
                            ),
                            suffixIcon: _clearRecommendKeyword
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        _recommendKeywordListController.text =
                                            '';
                                        _clearRecommendKeyword = false;
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: SvgPicture.asset(
                                        'assets/svg/icon/clear.svg',
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        if (_recommendKeywordList.isEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/icon/empty_keyword.svg',
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Text(
                                    '예) 독서를 즐겨하는 사람,\n마이브러리를 좋아하는 사람:)',
                                    style: recommendEmptyKeywordStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: _recommendKeywordList.mapIndexed(
                                (index, recommendKeyword) {
                                  return InkWell(
                                    onTap: () => {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: commonGreenColor,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            recommendKeyword,
                                            style: recommendSubStyle.copyWith(
                                              fontSize: 15.0,
                                              color: commonWhiteColor,
                                              height: 1.2,
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _recommendKeywordList
                                                    .removeAt(index);
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/icon/white_clear.svg',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  commonDivider(
                    dividerColor: greyF7F7F7,
                    dividerThickness: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 24.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '하고 싶은 말*',
                          style: recommendTitleStyle,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          maxLines: 3,
                          maxLength: 50,
                          cursorColor: primaryColor,
                          textInputAction: TextInputAction.done,
                          style: recommendEditStyle.copyWith(
                            color: grey262626,
                            fontSize: 14.0,
                          ),
                          controller: _recommendContentController,
                          scrollPadding: EdgeInsets.only(
                            bottom: bottomInset(context),
                          ),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            hintText:
                                '책의 줄거리나 요약, 명대사 등\n추천하고 싶은 대상에게 하고 싶은 말을 작성해보세요 :)',
                            hintStyle: recommendEditStyle.copyWith(
                              fontSize: 14.0,
                              letterSpacing: -1,
                            ),
                            filled: true,
                            fillColor: greyF7F7F7,
                            focusColor: greyF7F7F7,
                            border: searchInputBorderStyle,
                            focusedBorder: searchInputBorderStyle,
                            enabledBorder: searchInputBorderStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _addMyBookToMyRecommend({
    required BuildContext context,
  }) async {
    MyBooksResponseData? book = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyBookListScreen(
          bookListTitle: '책 추가',
          order: 'registration',
          readStatus: '',
          userId: _userId,
          isNotMyBook: true,
          onTapBookComponent: (book) {
            Navigator.pop(context, book);
          },
        ),
      ),
    );

    if (book != null) {
      setState(() {
        _bookId = book.id!;
        _thumbnailUrl = book.book!.thumbnailUrl!;
        _bookTitle = book.book!.title!;
        _bookAuthor = book.book!.authors!;
      });
    }
  }
}
