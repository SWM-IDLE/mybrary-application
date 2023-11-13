import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/provider/search/search_user_infos_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/enum.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/components/data_error.dart';
import 'package:mybrary/ui/common/components/error_page.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/search/search_book_list/components/search_user_info.dart';
import 'package:mybrary/ui/search/search_book_list/components/search_user_layout.dart';
import 'package:mybrary/ui/search/search_detail_user_infos/components/user_count.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class SearchDetailUserInfosScreen extends ConsumerStatefulWidget {
  final String title;
  final String isbn13;
  final int userCount;
  final SearchDetailUserInfosType type;

  const SearchDetailUserInfosScreen({
    required this.title,
    required this.isbn13,
    required this.userCount,
    required this.type,
    super.key,
  });

  @override
  ConsumerState<SearchDetailUserInfosScreen> createState() =>
      _SearchDetailUserInfosScreenState();
}

class _SearchDetailUserInfosScreenState
    extends ConsumerState<SearchDetailUserInfosScreen> {
  final _userId = UserState.userId;
  late String _introduction = '';

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case SearchDetailUserInfosType.interest:
        ref
            .refresh(searchUserInfosProvider.notifier)
            .getInterestBookUserInfos(widget.isbn13);
        _introduction = '관심있어 하는';
        break;
      case SearchDetailUserInfosType.readComplete:
        ref
            .refresh(searchUserInfosProvider.notifier)
            .getReadCompleteBookUserInfos(widget.isbn13);
        _introduction = '완독한';
        break;
      case SearchDetailUserInfosType.holder:
        ref
            .refresh(searchUserInfosProvider.notifier)
            .getMyBookUserInfos(widget.isbn13);
        _introduction = '소장하고 있는';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfos = [];

    final state = ref.watch(searchUserInfoListProvider);

    if (state == null || state is CommonResponseLoading) {
      return _initUserInfosLayout(
        child: const CircularLoading(),
      );
    }

    if (state is CommonResponseError) {
      return _initUserInfosLayout(
        child: const Column(
          children: [
            ErrorPage(
              errorMessage: '서비스에 문제가 있어요.\n잠시만 기다려 주세요 !',
            ),
          ],
        ),
      );
    }

    if (state is! CommonResponseLoading) {
      userInfos.addAll(state.userInfos);
    }

    if (userInfos.isEmpty) {
      return _initUserInfosLayout(
        child: DataError(
          icon: Icons.emoji_people_rounded,
          errorMessage: '아직 이 책을 ${_introduction}\n 사람이 없어요 :(',
        ),
      );
    }

    return _initUserInfosLayout(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          commonSliverAppBar(
            appBarTitle: widget.title,
          ),
          UserCount(userCount: widget.userCount),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => SearchUserLayout(
                children: [
                  InkWell(
                    onTap: () {
                      moveToUserProfile(
                        context: context,
                        myUserId: _userId,
                        userId: userInfos[index].userId,
                        nickname: userInfos[index].nickname,
                      );
                    },
                    child: SearchUserInfo(
                      nickname: userInfos[index].nickname!,
                      profileImageUrl: userInfos[index].profileImageUrl!,
                    ),
                  ),
                ],
              ),
              childCount: userInfos.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30.0,
            ),
          ),
        ],
      ),
    );
  }

  SubPageLayout _initUserInfosLayout({
    required Widget child,
  }) {
    return SubPageLayout(
      appBarTitle: widget.title,
      child: child,
    );
  }
}
