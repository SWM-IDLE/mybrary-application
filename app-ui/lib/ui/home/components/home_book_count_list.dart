import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/today_registered_book_count_model.dart';
import 'package:mybrary/data/provider/home/home_book_count_list_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/ui/common/components/error_page.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class HomeBookCountList extends ConsumerStatefulWidget {
  const HomeBookCountList({super.key});

  @override
  ConsumerState<HomeBookCountList> createState() => _HomeBookCountListState();
}

class _HomeBookCountListState extends ConsumerState<HomeBookCountList> {
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

    return _initLayout(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: homeBookCountList.totalCount,
        itemBuilder: (context, index) {
          MyBookRegisteredListModel book =
              homeBookCountList.myBookRegisteredList[index];

          return InkWell(
            onTap: () {},
            child: Column(
              children: [
                if (index != 0) const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
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
                                onError: (exception, stackTrace) => Image.asset(
                                  'assets/img/logo/mybrary.png',
                                  fit: BoxFit.fill,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: CircleAvatar(
                              radius: 22.0,
                              backgroundColor: greyACACAC,
                              backgroundImage: NetworkImage(
                                book.profileImageUrl,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 20.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 100,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              child: Text(
                                book.title,
                                style: commonSubMediumStyle.copyWith(
                                  fontSize: 14.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (book.nickname.length > 10)
                              Positioned(
                                bottom: 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: userDescription(book: book),
                                ),
                              )
                            else
                              Positioned(
                                bottom: 0,
                                child: Row(
                                  children: userDescription(book: book),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                commonDivider(
                  dividerHeight: 4,
                  dividerThickness: 4,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _initLayout({
    required Widget child,
  }) {
    return SubPageLayout(
      appBarTitle: '실시간 마이북 등록',
      child: child,
    );
  }

  List<Widget> userDescription({
    required MyBookRegisteredListModel book,
  }) {
    return [
      Text(
        book.nickname,
        style: todayRegisteredBookNickname,
      ),
      const Text(
        '님이 마이북에 도서를 추가했어요!',
        style: todayRegisteredBookIntroduction,
      ),
    ];
  }
}
