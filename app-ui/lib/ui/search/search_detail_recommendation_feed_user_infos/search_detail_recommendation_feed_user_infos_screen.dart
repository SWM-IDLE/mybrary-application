import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/provider/search/search_recommendation_feed_users_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/components/data_error.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/search/search_book_list/components/search_user_info.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class SearchDetailRecommendationFeedUserInfosScreen
    extends ConsumerStatefulWidget {
  final String isbn13;
  final int userCount;

  const SearchDetailRecommendationFeedUserInfosScreen({
    required this.isbn13,
    required this.userCount,
    super.key,
  });

  @override
  ConsumerState<SearchDetailRecommendationFeedUserInfosScreen> createState() =>
      _SearchDetailRecommendationFeedUserInfosScreenState();
}

class _SearchDetailRecommendationFeedUserInfosScreenState
    extends ConsumerState<SearchDetailRecommendationFeedUserInfosScreen> {
  @override
  void initState() {
    super.initState();

    ref
        .refresh(searchRecommendationFeedUsersProvider.notifier)
        .getRecommendationFeedsUserInfos(widget.isbn13);
  }

  @override
  Widget build(BuildContext context) {
    final recommendationFeedUserInfos =
        ref.watch(searchRecommendationFeedUsersInfoProvider);

    if (recommendationFeedUserInfos == null) {
      return const SubPageLayout(
        appBarTitle: '추천했어요',
        child: CircularLoading(),
      );
    }

    final recommendationFeedUserInfoList =
        recommendationFeedUserInfos.recommendationFeeds;

    if (recommendationFeedUserInfoList.isEmpty) {
      return const SubPageLayout(
        appBarTitle: '추천했어요',
        child: DataError(
          icon: Icons.menu_book_rounded,
          errorMessage: '해당 도서를 추천하는\n사용자와 피드가 아직 없어요 :(',
        ),
      );
    }

    return SubPageLayout(
      appBarTitle: '추천했어요',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Text(
                    '총 ${widget.userCount}명',
                    style: commonSubBoldStyle.copyWith(
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemBuilder: (context, index) {
                  final user = recommendationFeedUserInfoList[index];

                  return InkWell(
                    onTap: () {
                      showUserRecommendFeed(
                        context: context,
                        recommendationTargetNames:
                            user.recommendationTargetNames,
                        content: user.content,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SearchUserInfo(
                            nickname: user.nickname,
                            profileImageUrl: user.profileImageUrl,
                          ),
                          Row(
                            children: [
                              Text(
                                '추천피드 구경',
                                style: recommendSubStyle.copyWith(
                                  fontSize: 15.0,
                                  color: grey262626,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: grey262626,
                                size: 22.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: recommendationFeedUserInfoList.length,
              ),
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
