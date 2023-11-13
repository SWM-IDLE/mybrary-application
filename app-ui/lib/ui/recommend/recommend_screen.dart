import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/recommend/recommend_feed_model.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_post_provider.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/components/data_error.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/recommend/components/recommend_feed_content.dart';
import 'package:mybrary/ui/recommend/components/recommend_feed_header.dart';
import 'package:mybrary/ui/recommend/components/recommend_feed_keyword.dart';
import 'package:mybrary/ui/recommend/my_recommend/my_recommend_screen.dart';
import 'package:mybrary/ui/recommend/my_recommend_feed/my_recommend_feed_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class RecommendScreen extends ConsumerStatefulWidget {
  const RecommendScreen({super.key});

  @override
  ConsumerState<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends ConsumerState<RecommendScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _userId = UserState.userId;
  final ScrollController _recommendScrollController = ScrollController();

  late bool _isLoading;
  late bool _isVisibleAppBar;
  late bool _refreshRecommendFeed;
  late int? _lastRecommendationFeedId;

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    _isVisibleAppBar = false;
    _refreshRecommendFeed = false;
    _lastRecommendationFeedId = 0;

    ref
        .read(myRecommendProvider.notifier)
        .getRecommendFeedList(userId: _userId);

    _recommendScrollController.addListener(() {
      _changeAppBarState();
      if (_isScrollEnd && _lastRecommendationFeedId != null) {
        _isLoading = true;
        _fetchMoreRecommendFeedList();
      }
    });
  }

  void _changeAppBarState() {
    setState(() {
      if (_recommendScrollController.position.hasPixels) {
        _isVisibleAppBar = true;
      } else {
        _isVisibleAppBar = false;
      }
    });
  }

  bool get _isScrollEnd {
    return (_recommendScrollController.offset >=
            _recommendScrollController.position.maxScrollExtent) &&
        !_recommendScrollController.position.outOfRange;
  }

  void _fetchMoreRecommendFeedList() {
    ref.read(myRecommendProvider.notifier).getRecommendFeedList(
          userId: _userId,
          cursor: _lastRecommendationFeedId,
        );
  }

  @override
  void dispose() {
    _recommendScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final recommendFeedData = ref.watch(recommendFeedProvider);

    if (recommendFeedData == null) {
      return DefaultLayout(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            _recommendAppBar(),
            const SliverToBoxAdapter(
              child: CircularLoading(),
            ),
          ],
        ),
      );
    }

    if (recommendFeedData.recommendationFeeds.isEmpty) {
      return DefaultLayout(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            _recommendAppBar(),
            const SliverToBoxAdapter(
              child: DataError(
                icon: Icons.feed_rounded,
                errorMessage: '아직 작성된 추천 피드가 없어요 :(',
              ),
            ),
          ],
        ),
      );
    }

    if (_lastRecommendationFeedId !=
        recommendFeedData.lastRecommendationFeedId) {
      _isLoading = false;
      _lastRecommendationFeedId = recommendFeedData.lastRecommendationFeedId;
    }

    return RefreshIndicator(
      color: commonWhiteColor,
      backgroundColor: primaryColor,
      edgeOffset: const SliverAppBar().toolbarHeight * 0.5,
      onRefresh: () {
        return Future.delayed(
          const Duration(milliseconds: 500),
          () {
            ref
                .refresh(myRecommendProvider.notifier)
                .getRecommendFeedList(userId: _userId);
          },
        );
      },
      child: DefaultLayout(
        child: CustomScrollView(
          controller: _recommendScrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            _recommendAppBar(),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  RecommendFeedDataModel feed =
                      recommendFeedData.recommendationFeeds[index];

                  return Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 32.0,
                          right: 32.0,
                          top: index == 0 ? 12.0 : 8.0,
                          bottom: 16.0,
                        ),
                        child: Container(
                          decoration: recommendBoxStyle,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              RecommendFeedHeader(
                                isbn13: feed.isbn13,
                                targetUserId: feed.userId,
                                profileImageUrl: feed.profileImageUrl,
                                nickname: feed.nickname,
                                interestCount: feed.interestCount,
                                interested: feed.interested,
                                recommendationFeedId: feed.recommendationFeedId,
                                thumbnailUrl: feed.thumbnailUrl,
                                title: feed.title,
                                authors: feed.authors,
                              ),
                              commonDivider(
                                dividerColor: greyF7F7F7,
                                dividerThickness: 4,
                              ),
                              RecommendFeedKeyword(
                                recommendationTargetNames:
                                    feed.recommendationTargetNames,
                              ),
                              commonDivider(
                                dividerColor: greyF7F7F7,
                                dividerThickness: 4,
                              ),
                              RecommendFeedContent(
                                content: feed.content,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isLoading &&
                          index ==
                              recommendFeedData.recommendationFeeds.length - 1)
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Transform.scale(
                              scale: 0.7,
                              child: commonLoadingIndicator(),
                            ),
                          ),
                        ),
                    ],
                  );
                },
                childCount: recommendFeedData.recommendationFeeds.length,
              ),
            ),
            if (_lastRecommendationFeedId == null)
              SliverToBoxAdapter(
                child: _lastRecommendFeedPhrases(),
              ),
          ],
        ),
      ),
    );
  }

  Padding _lastRecommendFeedPhrases() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          children: [
            const Text(
              '마지막 추천 피드까지 보셨군요! 🎉🎉',
              style: recommendLastFeedStyle,
            ),
            const SizedBox(height: 6.0),
            InkWell(
              onTap: () {
                _recommendScrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('맨 위로 올라가기', style: recommendSubStyle),
                  Icon(
                    Icons.arrow_drop_up_rounded,
                    size: 36.0,
                    color: primaryColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverAppBar _recommendAppBar() {
    return SliverAppBar(
      toolbarHeight: 70.0,
      backgroundColor: commonWhiteColor,
      elevation: _isVisibleAppBar ? 0.5 : 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SvgPicture.asset('assets/svg/icon/mybrary_black.svg'),
      ),
      pinned: true,
      centerTitle: false,
      titleTextStyle: appBarTitleStyle,
      foregroundColor: commonBlackColor,
      actions: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyRecommendFeedScreen(
                  userId: _userId,
                ),
              ),
            );
          },
          child: SvgPicture.asset('assets/svg/icon/recommend_post.svg'),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 2.0,
            right: 8.0,
          ),
          child: IconButton(
            onPressed: () async {
              bool? refresh = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyRecommendScreen(),
                ),
              );

              setState(() {
                _refreshRecommendFeed = refresh ?? false;
              });

              if (_refreshRecommendFeed) {
                ref
                    .refresh(recommendProvider.notifier)
                    .getMyRecommendPostList(userId: _userId);
                ref
                    .refresh(myRecommendProvider.notifier)
                    .getRecommendFeedList(userId: _userId);
              }
            },
            icon: SvgPicture.asset('assets/svg/icon/add_button.svg'),
          ),
        ),
      ],
    );
  }
}
