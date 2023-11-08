import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/provider/search/search_recommendation_feed_users_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/components/data_error.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';

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
  final _userId = UserState.userId;

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

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(user.profileImageUrl),
                    ),
                    title: Text(user.nickname),
                  );
                },
                itemCount: recommendationFeedUserInfoList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
