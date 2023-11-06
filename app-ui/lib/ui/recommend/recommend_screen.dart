import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/recommend/recommend_feed_model.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/profile/my_recommend_post/my_recommend_post_screen.dart';
import 'package:mybrary/ui/recommend/components/recommend_feed_book_info.dart';
import 'package:mybrary/ui/recommend/components/recommend_feed_content.dart';
import 'package:mybrary/ui/recommend/components/recommend_feed_header.dart';
import 'package:mybrary/ui/recommend/components/recommend_feed_keyword.dart';
import 'package:mybrary/ui/recommend/myRecommend/my_recommend_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class RecommendScreen extends ConsumerStatefulWidget {
  const RecommendScreen({super.key});

  @override
  ConsumerState<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends ConsumerState<RecommendScreen> {
  final _userId = UserState.userId;

  final ScrollController _recommendScrollController = ScrollController();

  late bool _isVisibleAppBar;
  late bool _refreshRecommendFeed;

  @override
  void initState() {
    super.initState();

    _isVisibleAppBar = false;
    _refreshRecommendFeed = false;

    Future.delayed(const Duration(milliseconds: 500), () {
      ref
          .read(myRecommendProvider.notifier)
          .getRecommendFeedList(userId: _userId);
    });

    _recommendScrollController.addListener(_changeAppBarState);
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

  @override
  void dispose() {
    _recommendScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    return DefaultLayout(
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
                return Padding(
                  padding: EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    top: index == 0 ? 12.0 : 8.0,
                    bottom: 16.0,
                  ),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: commonWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      shadows: [
                        BoxShadow(
                          color: commonBlackColor.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        RecommendFeedHeader(
                          profileImageUrl: feed.profileImageUrl,
                          nickname: feed.nickname,
                          interestCount: feed.interestCount,
                          interested: feed.interested,
                        ),
                        commonDivider(
                          dividerColor: greyF7F7F7,
                          dividerThickness: 4,
                        ),
                        RecommendFeedBookInfo(
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
                );
              },
              childCount: recommendFeedData.recommendationFeeds.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20.0),
          ),
        ],
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
                builder: (context) => const MyRecommendPostScreen(),
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
