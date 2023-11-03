import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/book/mybooks_response.dart';
import 'package:mybrary/data/model/recommend/my_recommend_model.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/mybook/mybook_list/mybook_list_screen.dart';
import 'package:mybrary/ui/recommend/myRecommend/components/my_recommend_content.dart';
import 'package:mybrary/ui/recommend/myRecommend/components/my_recommend_header.dart';
import 'package:mybrary/ui/recommend/myRecommend/components/my_recommend_keyword.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

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
                  MyRecommendHeader(
                    bookId: _bookId,
                    bookTitle: _bookTitle,
                    thumbnailUrl: _thumbnailUrl,
                    bookAuthor: _bookAuthor,
                    onTapAddBook: () async {
                      if (_thumbnailUrl == '') {
                        await _addMyBookToMyRecommend(context: context);
                      }
                    },
                    onTapEditBook: () async {
                      await _addMyBookToMyRecommend(context: context);
                    },
                  ),
                  commonDivider(
                    dividerColor: greyF7F7F7,
                    dividerThickness: 4,
                  ),
                  MyRecommendKeyword(
                    recommendKeywordListController:
                        _recommendKeywordListController,
                    recommendKeywordList: _recommendKeywordList,
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
                    clearRecommendKeyword: _clearRecommendKeyword,
                    onTapClearRecommendKeywordText: () {
                      setState(() {
                        _recommendKeywordListController.text = '';
                        _clearRecommendKeyword = false;
                      });
                    },
                    onTapRemoveRecommendKeyword: (index) {
                      setState(() {
                        _recommendKeywordList.removeAt(index);
                      });
                    },
                  ),
                  commonDivider(
                    dividerColor: greyF7F7F7,
                    dividerThickness: 4,
                  ),
                  MyRecommendContent(
                    recommendContentController: _recommendContentController,
                  ),
                  if (_recommendContentController.text.isNotEmpty &&
                      _recommendContentController.text.length < 5)
                    Text(
                      '5자 이상 입력해주세요.',
                      style: commonSubThinStyle.copyWith(
                        color: commonRedColor,
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
