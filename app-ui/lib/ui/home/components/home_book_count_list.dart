import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/today_registered_book_count_model.dart';
import 'package:mybrary/data/provider/home/home_book_count_list_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/components/data_error.dart';
import 'package:mybrary/ui/common/components/error_page.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class HomeBookCountList extends ConsumerStatefulWidget {
  const HomeBookCountList({super.key});

  @override
  ConsumerState<HomeBookCountList> createState() => _HomeBookCountListState();
}

class _HomeBookCountListState extends ConsumerState<HomeBookCountList> {
  final _userId = UserState.userId;

  @override
  void initState() {
    super.initState();

    ref.refresh(homeBookServiceProvider.notifier).getTodayRegisteredBookList();
  }

  @override
  Widget build(BuildContext context) {
    final homeBookCountList = ref.watch(homeBookCountListProvider);

    if (homeBookCountList == null) {
      return _initLayout(
        child: const CircularLoading(),
      );
    }

    if (homeBookCountList is CommonResponseError) {
      return _initLayout(
        child: const ErrorPage(
          errorMessage: '서비스에 문제가 있어요.\n잠시만 기다려 주세요 !',
        ),
      );
    }

    if (homeBookCountList.totalCount == 0) {
      return refreshHomeBookCountList(
        child: _initLayout(
          child: const SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: DataError(
              icon: Icons.emoji_people_rounded,
              errorMessage: '오늘 마이북에 담긴 책이 아직 없어요!\n직접 마이북에 한번 담아볼까요?',
            ),
          ),
        ),
      );
    }

    return refreshHomeBookCountList(
      child: _initLayout(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: homeBookCountList.totalCount,
          itemBuilder: (context, index) {
            MyBookRegisteredListModel book =
                homeBookCountList.myBookRegisteredList[index];

            String bookTitle = book.title.length > 40
                ? '${book.title.substring(0, 40)}...'
                : book.title;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              moveToBookDetail(
                                context: context,
                                isbn13: book.isbn13,
                              );
                            },
                            child: Container(
                              width: 70,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: greyF1F2F5,
                                  width: 1,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    book.thumbnailUrl,
                                  ),
                                  onError: (exception, stackTrace) =>
                                      Image.asset(
                                    'assets/img/logo/mybrary.png',
                                    fit: BoxFit.fill,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: InkWell(
                              onTap: () {
                                moveToUserProfile(
                                  context: context,
                                  myUserId: _userId,
                                  userId: book.userId,
                                  nickname: book.nickname,
                                );
                              },
                              child: CircleAvatar(
                                radius: 22.0,
                                backgroundColor: greyACACAC,
                                backgroundImage: NetworkImage(
                                  book.profileImageUrl,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                moveToUserProfile(
                                  context: context,
                                  myUserId: _userId,
                                  userId: book.userId,
                                  nickname: book.nickname,
                                );
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: book.nickname,
                                  style: todayRegisteredBookNickname,
                                  children: const [
                                    TextSpan(
                                      text: '님이',
                                      style: todayRegisteredBookIntroduction,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            InkWell(
                              onTap: () {
                                moveToBookDetail(
                                  context: context,
                                  isbn13: book.isbn13,
                                );
                              },
                              child: Text(
                                '「 $bookTitle 」',
                                style: commonSubBoldStyle.copyWith(
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            const Text(
                              '을(를) 마이북에 추가했어요!',
                              style: todayRegisteredBookIntroduction,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                commonDivider(
                  dividerThickness: 5,
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _initLayout({
    required Widget child,
  }) {
    return SubPageLayout(
      appBarTitle: '오늘 마이북에 담긴 책',
      child: child,
    );
  }

  RefreshIndicator refreshHomeBookCountList({
    required Widget child,
  }) {
    return RefreshIndicator(
      color: commonWhiteColor,
      backgroundColor: primaryColor,
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 1),
          () {
            ref
                .refresh(homeBookServiceProvider.notifier)
                .getTodayRegisteredBookList();
          },
        );
      },
      child: child,
    );
  }
}
