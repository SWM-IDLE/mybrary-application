import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_post_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/recommend/myRecommend/my_recommend_screen.dart';
import 'package:mybrary/utils/logics/book_utils.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class MyRecommendPostScreen extends ConsumerStatefulWidget {
  const MyRecommendPostScreen({super.key});

  @override
  ConsumerState<MyRecommendPostScreen> createState() =>
      _MyRecommendPostScreenState();
}

class _MyRecommendPostScreenState extends ConsumerState<MyRecommendPostScreen> {
  final _userId = UserState.userId;

  late bool _refreshRecommendFeedPost;

  @override
  void initState() {
    super.initState();

    _refreshRecommendFeedPost = false;

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        ref
            .read(recommendProvider.notifier)
            .getMyRecommendPostList(userId: _userId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final myRecommendFeed = ref.watch(myRecommendFeedProvider);

    if (myRecommendFeed == null) {
      return const SubPageLayout(
        appBarTitle: '마이 추천 포스트',
        child: CircularLoading(),
      );
    }

    final myRecommendFeedData = myRecommendFeed.recommendationFeeds;

    return SubPageLayout(
      appBarTitle: '마이 추천 포스트',
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
                      .read(recommendProvider.notifier)
                      .getMyRecommendPostList(userId: _userId);
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
