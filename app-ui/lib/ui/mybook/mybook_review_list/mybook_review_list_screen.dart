import 'package:flutter/material.dart';
import 'package:mybrary/data/model/book/mybook_review_model.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/data/repository/book_repository.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/components/single_data_error.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/mybook/mybook_detail/components/mybook_edit_review.dart';
import 'package:mybrary/ui/recommend/my_recommend_feed/components/my_recommend_feed_book_info.dart';
import 'package:mybrary/utils/logics/book_utils.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class MyReviewListScreen extends StatefulWidget {
  final String? userId;
  const MyReviewListScreen({
    this.userId,
    super.key,
  });

  @override
  State<MyReviewListScreen> createState() => _MyRecommendPostScreenState();
}

class _MyRecommendPostScreenState extends State<MyReviewListScreen> {
  final _bookRepository = BookRepository();
  final _userId = UserState.userId;

  late Future<MyBookReviewModel> _myBookReviewData;

  @override
  void initState() {
    super.initState();

    _myBookReviewData = _bookRepository.getMyBookReviewList(
      context: context,
      userId: widget.userId ?? _userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubPageLayout(
      appBarTitle: '마이 리뷰 목록',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: FutureBuilder(
          future: _myBookReviewData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SingleDataError(
                errorMessage: '마이 리뷰 목록을\n불러오는데 실패했습니다.',
              );
            }

            if (snapshot.hasData) {
              final myReviewData = snapshot.data!.reviews;
              return ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: myReviewData.length,
                itemBuilder: (context, index) {
                  return Wrap(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                if (widget.userId == _userId) {
                                  _moveMyReviewPage(
                                      context, myReviewData, index);
                                }

                                if (widget.userId != _userId) {
                                  if (!mounted) return;
                                  moveToBookDetail(
                                    context: context,
                                    isbn13: myReviewData[index].bookIsbn13,
                                  );
                                }
                              },
                              child: Hero(
                                tag: myReviewData[index].reviewId,
                                child: Container(
                                  width: 100,
                                  height: 150,
                                  decoration: commonBookThumbnailStyle(
                                    thumbnailUrl:
                                        myReviewData[index].bookThumbnailUrl,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (widget.userId == _userId) {
                                    _moveMyReviewPage(
                                        context, myReviewData, index);
                                  }

                                  if (widget.userId != _userId) {
                                    if (!mounted) return;
                                    showUserRecommendFeed(
                                      context: context,
                                      recommendationTargetNames:
                                          myReviewData[index].authors,
                                      content: myReviewData[index].content,
                                      isMyRecommend: false,
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyRecommendFeedBookInfo(
                                      title: myReviewData[index].bookTitle,
                                      recommendationTargetNames:
                                          myReviewData[index].authors,
                                      content: myReviewData[index].content,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index != myReviewData.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 32.0,
                          ),
                          child: commonDivider(
                            dividerColor: greyACACAC,
                            dividerThickness: 1,
                          ),
                        )
                      else
                        const SizedBox(height: 20.0),
                    ],
                  );
                },
              );
            }
            return const CircularLoading();
          },
        ),
      ),
    );
  }

  void _moveMyReviewPage(BuildContext context,
      List<MyBookReviewDataModel> myReviewData, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyBookEditReview(
          hasData: true,
          isCreateReview: false,
          thumbnailUrl: myReviewData[index].bookThumbnailUrl,
          title: myReviewData[index].bookTitle,
          authors: myReviewData[index].authors,
          starRating: myReviewData[index].starRating,
          contentController:
              TextEditingController(text: myReviewData[index].content),
          myBookId: myReviewData[index].myBookId,
          reviewId: myReviewData[index].reviewId,
        ),
      ),
    ).then(
      (value) => setState(() {
        _myBookReviewData = _bookRepository.getMyBookReviewList(
          context: context,
          userId: _userId,
        );
      }),
    );
  }
}
