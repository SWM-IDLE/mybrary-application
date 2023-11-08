import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_post_provider.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/components/data_error.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/recommend/my_recommend//my_recommend_screen.dart';
import 'package:mybrary/utils/logics/book_utils.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class MyRecommendFeedScreen extends ConsumerStatefulWidget {
  final String? userId;
  const MyRecommendFeedScreen({
    this.userId,
    super.key,
  });

  @override
  ConsumerState<MyRecommendFeedScreen> createState() =>
      _MyRecommendPostScreenState();
}

class _MyRecommendPostScreenState extends ConsumerState<MyRecommendFeedScreen> {
  final _userId = UserState.userId;
  late bool _refreshRecommendFeedPost;

  @override
  void initState() {
    super.initState();

    _refreshRecommendFeedPost = false;

    Future.delayed(const Duration(milliseconds: 500), () {
      ref
          .read(recommendProvider.notifier)
          .getMyRecommendPostList(userId: _userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final myRecommendFeed = ref.watch(myRecommendFeedProvider);

    if (myRecommendFeed == null) {
      return const SubPageLayout(
        appBarTitle: '마이 추천 피드',
        child: CircularLoading(),
      );
    }

    final myRecommendFeedData = myRecommendFeed.recommendationFeeds;

    if (myRecommendFeedData.isEmpty) {
      return const SubPageLayout(
        appBarTitle: '마이 추천 피드',
        child: DataError(
          icon: Icons.menu_book_rounded,
          errorMessage: '작성된 추천 글이 없어요!\n추천 피드를 작성해보세요 :)',
        ),
      );
    }

    return SubPageLayout(
      appBarTitle: '마이 추천 피드',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: myRecommendFeedData.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                if (widget.userId == _userId) {
                  bool? refresh = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyRecommendScreen(
                        myRecommendFeedData: myRecommendFeedData[index],
                      ),
                    ),
                  );

                  setState(() {
                    _refreshRecommendFeedPost = refresh ?? false;
                  });

                  if (_refreshRecommendFeedPost) {
                    ref
                        .refresh(recommendProvider.notifier)
                        .getMyRecommendPostList(
                            userId: widget.userId ?? _userId);
                    ref
                        .refresh(myRecommendProvider.notifier)
                        .getRecommendFeedList(userId: widget.userId ?? _userId);
                  }
                }

                if (widget.userId != _userId) {
                  if (!mounted) return;
                  moveToBookDetail(
                    context: context,
                    isbn13: myRecommendFeedData[index].isbn13,
                  );
                }
              },
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: myRecommendFeedData[index].recommendationFeedId,
                          child: Container(
                            width: 100,
                            decoration: commonBookThumbnailStyle(
                              thumbnailUrl:
                                  myRecommendFeedData[index].thumbnailUrl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    myRecommendFeedData[index].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: recommendBookTitleStyle,
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    myRecommendFeedData[index]
                                        .recommendationTargetNames
                                        .map((targetName) => targetName)
                                        .join(', '),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: recommendBookSubStyle.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    myRecommendFeedData[index].content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: recommendBookSubStyle.copyWith(
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                myRecommendFeedData[index].createdAt,
                                style: recommendBookSubStyle.copyWith(
                                  color: grey777777,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index != myRecommendFeedData.length - 1)
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
              ),
            );
          },
        ),
      ),
    );
  }
}