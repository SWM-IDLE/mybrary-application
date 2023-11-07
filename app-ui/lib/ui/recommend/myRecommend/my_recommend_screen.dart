import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/book/mybooks_response.dart';
import 'package:mybrary/data/model/recommend/my_recommend_feed_model.dart';
import 'package:mybrary/data/model/recommend/my_recommend_model.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_post_provider.dart';
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
import 'package:mybrary/utils/logics/future_utils.dart';

class MyRecommendScreen extends ConsumerStatefulWidget {
  final MyRecommendFeedDataModel? myRecommendFeedData;

  const MyRecommendScreen({
    this.myRecommendFeedData,
    super.key,
  });

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
  late bool _notValidContent = false;

  @override
  void initState() {
    super.initState();

    if (widget.myRecommendFeedData == null) {
      _bookId = 0;
      _thumbnailUrl = '';
      _bookTitle = '';
      _bookAuthor = '';
      _recommendKeywordList = [];
    }

    if (widget.myRecommendFeedData != null) {
      final feed = widget.myRecommendFeedData!;
      _bookId = feed.myBookId;
      _thumbnailUrl = feed.thumbnailUrl;
      _bookTitle = feed.title;
      _bookAuthor = '';
      _recommendKeywordList = feed.recommendationTargetNames;
      _recommendContentController.text = feed.content;
    }

    _recommendKeywordListController.addListener(_isClearRecommendKeyword);
    _recommendContentController.addListener(_isValidContentLength);
  }

  void _isClearRecommendKeyword() {
    if (_recommendKeywordListController.text.isEmpty) {
      _clearRecommendKeyword = false;
    } else {
      _clearRecommendKeyword = true;
    }
  }

  void _isValidContentLength() {
    setState(() {
      if (_recommendContentController.text.isNotEmpty &&
          _recommendContentController.text.length < 5) {
        _notValidContent = true;
      } else {
        _notValidContent = false;
      }
    });
  }

  @override
  void dispose() {
    _recommendKeywordListController.dispose();
    _recommendContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await onWillPopCommonSaveAlert(
        context: context,
        saveCondition: _bookId != 0 ||
            _recommendKeywordList.isNotEmpty ||
            _recommendContentController.text.isNotEmpty,
        onTapBackAction: () {
          if (widget.myRecommendFeedData != null) {
            ref
                .refresh(recommendProvider.notifier)
                .getMyRecommendPostList(userId: _userId);
          }
          Navigator.pop(context, true);
        },
      ),
      child: SubPageLayout(
        appBarTitle: '마이 추천',
        appBarActions: [
          if (widget.myRecommendFeedData != null)
            TextButton(
              onPressed: () {
                commonShowConfirmOrCancelDialog(
                  context: context,
                  title: '삭제',
                  content: '해당 마이 추천 피드를\n삭제 하시겠습니까?',
                  cancelButtonText: '취소',
                  cancelButtonOnTap: () {
                    Navigator.of(context).pop();
                  },
                  confirmButtonText: '삭제하기',
                  confirmButtonOnTap: () {
                    ref.watch(myRecommendProvider.notifier).deleteRecommendFeed(
                          context: context,
                          userId: _userId,
                          recommendationFeedId:
                              widget.myRecommendFeedData!.recommendationFeedId,
                        );
                  },
                  confirmButtonColor: commonRedColor,
                  confirmButtonTextColor: commonWhiteColor,
                );
              },
              style: disableAnimationTextButtonStyle,
              child: Text(
                '삭제',
                style: saveTextButtonStyle.copyWith(
                  color: commonRedColor,
                ),
              ),
            ),
          TextButton(
            onPressed: () {
              if (_bookId == 0) {
                return showCommonSnackBarMessage(
                  context: context,
                  snackBarText: '마이 추천을 위한 책을 추가해주세요 :)',
                );
              }

              if (_recommendKeywordList.isEmpty ||
                  _recommendContentController.text.isEmpty) {
                return showCommonSnackBarMessage(
                  context: context,
                  snackBarText: '작성하신 내용을 다시한 번 확인해주세요 :)',
                );
              }

              if (_recommendContentController.text.length < 5) {
                return showCommonSnackBarMessage(
                  context: context,
                  snackBarText: '5자 이상 입력해주세요 :)',
                );
              }

              if (widget.myRecommendFeedData == null) {
                ref.watch(myRecommendProvider.notifier).createRecommendFeed(
                      context: context,
                      userId: _userId,
                      body: MyRecommendModel(
                        myBookId: _bookId,
                        content: _recommendContentController.text,
                        recommendationTargetNames: _recommendKeywordList,
                      ),
                    );
              }

              if (widget.myRecommendFeedData != null) {
                ref.watch(myRecommendProvider.notifier).updateRecommendFeed(
                      context: context,
                      userId: _userId,
                      recommendationFeedId:
                          widget.myRecommendFeedData!.recommendationFeedId,
                      body: MyRecommendPostDataModel(
                        content: _recommendContentController.text,
                        recommendationTargetNames: _recommendKeywordList,
                      ),
                    );
              }
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyRecommendHeader(
                      recommendFeedId:
                          widget.myRecommendFeedData?.recommendationFeedId,
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
                          if (_recommendKeywordList.contains(value)) {
                            return showCommonSnackBarMessage(
                              context: context,
                              snackBarText: '이미 추가된 키워드입니다 :)',
                            );
                          }

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
                    Stack(
                      children: [
                        MyRecommendContent(
                          recommendContentController:
                              _recommendContentController,
                        ),
                        if (_notValidContent)
                          Positioned(
                            bottom: 10,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                '5자 이상 입력해주세요.',
                                style: commonSubThinStyle.copyWith(
                                  color: commonRedColor,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            );
          },
        ),
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
