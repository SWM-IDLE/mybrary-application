import 'package:flutter/material.dart';
import 'package:mybrary/data/model/search/user_search_response.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/data/repository/search_repository.dart';
import 'package:mybrary/ui/common/components/error_page.dart';
import 'package:mybrary/ui/common/components/single_data_error.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/search/components/search_loading.dart';
import 'package:mybrary/ui/search/search_book_list/components/search_user_info.dart';
import 'package:mybrary/ui/search/search_book_list/components/search_user_layout.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class SearchAllUserList extends StatefulWidget {
  const SearchAllUserList({super.key});

  @override
  State<SearchAllUserList> createState() => _SearchAllUserListState();
}

class _SearchAllUserListState extends State<SearchAllUserList> {
  late Future<UserSearchResponseData> _userSearchResponse;

  final _searchRepository = SearchRepository();

  final _userId = UserState.userId;

  @override
  void initState() {
    super.initState();

    _userSearchResponse = _searchRepository.getUserSearchResponse(
      context: context,
      nickname: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubPageLayout(
      appBarTitle: '마이브러리 유저',
      child: FutureBuilder<UserSearchResponseData>(
        future: _userSearchResponse,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage(
              errorMessage: '검색 결과를 불러오는데 실패했습니다.',
            );
          }

          if (!snapshot.hasData) {
            return const SearchLoading();
          }

          if (snapshot.hasData) {
            UserSearchResponseData userSearchResponse = snapshot.data!;
            List<SearchedUsers> searchedUsers =
                userSearchResponse.searchedUsers!;

            if (searchedUsers.isNotEmpty) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: searchedUsers.length,
                itemBuilder: (context, index) {
                  SearchedUsers searchedUser = searchedUsers[index];

                  return InkWell(
                    onTap: () {
                      nextToUserProfile(
                        context: context,
                        myUserId: _userId,
                        userId: searchedUser.userId!,
                        nickname: searchedUser.nickname!,
                      );
                    },
                    child: SearchUserLayout(
                      children: [
                        SearchUserInfo(
                          nickname: searchedUser.nickname!,
                          profileImageUrl: searchedUser.profileImageUrl!,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const SingleDataError(
                errorMessage: '검색된 사용자가 없습니다.',
              );
            }
          }
          return const SingleDataError(
            errorMessage: '검색 결과를 불러오는데 실패했습니다.',
          );
        },
      ),
    );
  }
}
