import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/books_by_category_model.dart';
import 'package:mybrary/data/model/home/books_by_interest_model.dart';
import 'package:mybrary/data/model/home/books_ranking_model.dart';
import 'package:mybrary/data/model/home/today_registered_book_count_model.dart';
import 'package:mybrary/data/provider/home/home_bestseller_provider.dart';
import 'package:mybrary/data/provider/home/home_provider.dart';
import 'package:mybrary/data/provider/home/home_recommendation_books_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/data/repository/home_repository.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/error_page.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/home/components/home_banner.dart';
import 'package:mybrary/ui/home/components/home_banner_loading.dart';
import 'package:mybrary/ui/home/components/home_book_count.dart';
import 'package:mybrary/ui/home/components/home_interest_setting_button.dart';
import 'package:mybrary/ui/home/components/home_recommend_books.dart';
import 'package:mybrary/ui/home/components/home_recommend_books_header.dart';
import 'package:mybrary/ui/profile/my_interests/my_interests_screen.dart';
import 'package:mybrary/ui/search/search_detail/search_detail_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';
import 'package:mybrary/utils/logics/future_utils.dart';
import 'package:mybrary/utils/logics/permission_utils.dart';

const Map<String, String> rankingTypes = {
  'holder': '마이북',
  'read': '관심북',
  'interest': '완독북',
  'recommendation': '추천피드순',
  'review': '리뷰작성순',
  'star': '별점순',
};

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final _homeRepository = HomeRepository();

  late String _bookCategory = '';
  late List<UserInterests> _interests = [];
  late List<BooksModel> _bookListByCategory = [];

  late bool _initAppBarIsVisible;

  final ScrollController _homeScrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _rankingCategoryScrollController = ScrollController();

  late BooksRankingModel _booksRankingResponseData;
  late List<BookRankingDataModel> _booksRankingList = [];
  late String _bookRankingCategory = '';

  @override
  void initState() {
    super.initState();

    sendNotificationMessage();
    getToken();
    _initAppBarIsVisible = false;

    Future.delayed(
      const Duration(milliseconds: 500),
      () async {
        ref.read(homeProvider.notifier).getTodayRegisteredBookCount();
        ref.read(bestSellerProvider.notifier).getBooksByBestSeller();
        ref
            .read(recommendationBooksProvider.notifier)
            .getBooksByFirstInterests();
        _bookRankingCategory = 'holder';
        _booksRankingResponseData = await _homeRepository.getBooksByRanking(
            context: context, order: _bookRankingCategory, limit: 6);
        _booksRankingList = _booksRankingResponseData.books;
      },
    );

    _homeScrollController.addListener(_changeAppBarComponent);

    if (UserState.update == false && UserState.forceUpdate == false) {
      return;
    }

    if (UserState.update == true) {
      return _showUpdateAlert();
    }

    if (UserState.forceUpdate == true) {
      return _showForceUpdateAlert();
    }
  }

  void sendNotificationMessage() {
    setState(() {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification? notification = message.notification;

        if (notification != null) {
          FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'high_importance_notification',
                importance: Importance.max,
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
          );
        }
      });
    });
  }

  void _showUpdateAlert() {
    Future.delayed(
      Duration.zero,
      () => commonShowConfirmOrCancelDialog(
        context: context,
        title: '새로운 버전 출시',
        content: '업데이트를 통해\n새로운 기능을 만나보세요 !',
        cancelButtonText: '나중에',
        cancelButtonOnTap: () {
          Navigator.pop(context);
          UserState.localStorage.setBool('update', false);
        },
        confirmButtonText: '업데이트',
        confirmButtonOnTap: () => connectAppStoreLink(),
        confirmButtonColor: primaryColor,
        confirmButtonTextColor: commonWhiteColor,
      ),
    );
  }

  void _showForceUpdateAlert() {
    Future.delayed(
      Duration.zero,
      () => commonShowConfirmDialog(
        context: context,
        title: '업데이트 필요',
        content: '중요한 변경으로 인해\n업데이트가 꼭 필요해요!',
        confirmButtonColor: primaryColor,
        confirmButtonText: '업데이트하러 가기 :)',
        confirmButtonTextColor: commonWhiteColor,
        confirmButtonOnTap: () => connectAppStoreLink(),
      ),
    );
  }

  void _scrollToTop() {
    _categoryScrollController.animateTo(
      0,
      duration: const Duration(microseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _changeAppBarComponent() {
    setState(() {
      if (_homeScrollController.offset > 10) {
        _initAppBarIsVisible = true;
      } else {
        _initAppBarIsVisible = false;
      }
    });
  }

  @override
  void dispose() {
    _homeScrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final todayRegisteredBookCount =
        ref.watch(todayRegisteredBookCountProvider);
    final booksByBestSeller = ref.watch(homeBestSellerProvider);
    final booksByInterests = ref.watch(homeRecommendationBooksProvider);

    if (booksByBestSeller == null || booksByInterests == null) {
      return DefaultLayout(
        appBar: _homeAppBar(),
        extendBodyBehindAppBar: true,
        child: const CustomScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            HomeBannerLoading(),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 30.0,
              ),
            ),
          ],
        ),
      );
    }

    if (isError([
      todayRegisteredBookCount,
      booksByBestSeller,
      booksByInterests,
    ])) {
      return const Column(
        children: [
          ErrorPage(
            errorMessage: '서비스에 문제가 있어요.\n잠시만 기다려 주세요 !',
          ),
        ],
      );
    }

    if (booksByInterests is! CommonResponseLoading) {
      if (booksByInterests.userInterests!.isNotEmpty &&
          listEquals(_interests, booksByInterests.userInterests) == false) {
        _interests = _getUserInterests(booksByInterests.userInterests);
        _bookListByCategory = booksByInterests.bookRecommendations!;
        _bookCategory = _interests.first.name!;
      }

      if (_bookListByCategory.isEmpty &&
          booksByInterests.userInterests!.isNotEmpty) {
        _bookListByCategory = booksByInterests.bookRecommendations!;
        _bookCategory = _interests.first.name!;
      }
    }

    return RefreshIndicator(
      color: commonWhiteColor,
      backgroundColor: primaryColor,
      edgeOffset: AppBar().preferredSize.height * 0.5,
      onRefresh: () {
        return Future.delayed(
          const Duration(milliseconds: 500),
          () {
            ref.refresh(homeProvider.notifier).getTodayRegisteredBookCount();
            ref.refresh(bestSellerProvider.notifier).getBooksByBestSeller();
            ref
                .refresh(recommendationBooksProvider.notifier)
                .getBooksByFirstInterests();
          },
        );
      },
      child: DefaultLayout(
        appBar: _homeAppBar(),
        extendBodyBehindAppBar: true,
        child: CustomScrollView(
          controller: _homeScrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            HomeBanner(
              bookListByBestSeller: booksByBestSeller.books,
              onTapBook: (String isbn13) {
                _navigateToBookSearchDetailScreen(isbn13);
              },
            ),
            _sliverTodayRegisteredBookCountBox(todayRegisteredBookCount),
            const HomeRecommendBooksHeader(),
            if (booksByInterests.userInterests!.isEmpty)
              HomeInterestSettingButton(
                onTapMyInterests: _navigateToMyInterestsScreen,
              ),
            if (booksByInterests.userInterests!.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 240,
                  child: HomeRecommendBooks(
                    category: _bookCategory,
                    userInterests: booksByInterests.userInterests!,
                    bookListByCategory: _bookListByCategory,
                    categoryScrollController: _categoryScrollController,
                    onTapBook: (String isbn13) {
                      _navigateToBookSearchDetailScreen(isbn13);
                    },
                    onTapMyInterests: _navigateToMyInterestsScreen,
                    onTapCategory: (String category) {
                      final [firstInterest, secondInterest, thirdInterest] =
                          _interests;

                      setState(() {
                        _bookCategory = category;
                        _setInterests(firstInterest, category);
                        _setInterests(secondInterest, category);
                        _setInterests(thirdInterest, category);
                      });
                    },
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 880,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        top: 36.0,
                        bottom: 12.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '마이브러리의 ',
                            style: commonMainRegularStyle,
                          ),
                          Text(
                            '핫 랭킹 도서 🔥',
                            style: commonSubBoldStyle.copyWith(
                              fontSize: 17.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 56.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: ListView.builder(
                          controller: _rankingCategoryScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: rankingTypes.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _refreshRankingBookList(
                                      rankingTypes.keys.toList()[index]);
                                  _bookRankingCategory =
                                      rankingTypes.keys.toList()[index];
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 16.0 : 0.0,
                                  right: index == rankingTypes.length - 1
                                      ? 16.0
                                      : 8.0,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 19.0,
                                    vertical: 7.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: commonWhiteColor,
                                    border: Border.all(
                                      color: _isEqualRankingType(index)
                                          ? grey262626
                                          : greyF4F4F4,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    rankingTypes.values.toList()[index],
                                    style: categoryCircularTextStyle.copyWith(
                                      color: _isEqualRankingType(index)
                                          ? grey262626
                                          : grey999999,
                                      fontWeight: _isEqualRankingType(index)
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: _booksRankingList
                                    .getRange(0, _booksRankingList.length ~/ 2)
                                    .map(
                                      (book) => _rankingBookListComponent(
                                        padding: const EdgeInsets.only(
                                          right: 6.0,
                                          bottom: 16.0,
                                        ),
                                        bookList: book,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: _booksRankingList
                                    .getRange(_booksRankingList.length ~/ 2,
                                        _booksRankingList.length)
                                    .map(
                                      (book) => _rankingBookListComponent(
                                        padding: const EdgeInsets.only(
                                          left: 6.0,
                                          top: 16.0,
                                        ),
                                        bookList: book,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isEqualRankingType(int index) {
    return rankingTypes.keys.toList()[index] == _bookRankingCategory;
  }

  Padding _rankingBookListComponent({
    required EdgeInsetsGeometry padding,
    required BookRankingDataModel bookList,
  }) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _navigateToBookSearchDetailScreen(bookList.isbn13);
            },
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: greyF4F4F4,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Container(
                  width: 100,
                  height: 140,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        bookList.thumbnailUrl,
                      ),
                      onError: (exception, stackTrace) => Image.asset(
                        'assets/img/logo/mybrary.png',
                        fit: BoxFit.fill,
                      ),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 2,
                        offset: Offset(1, 1),
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            bookList.title,
            style: commonSubBoldStyle.copyWith(
              fontSize: 15.0,
              letterSpacing: -1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _sliverTodayRegisteredBookCountBox(
      TodayRegisteredBookCountModel? todayRegisteredBookCount) {
    return SliverToBoxAdapter(
      child: HomeBookCount(
        todayRegisteredBookCount: todayRegisteredBookCount?.count ?? 0,
      ),
    );
  }

  AppBar _homeAppBar() {
    return AppBar(
      toolbarHeight: 70.0,
      backgroundColor:
          _initAppBarIsVisible ? commonWhiteColor : Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SvgPicture.asset(
            'assets/svg/icon/mybrary_${_initAppBarIsVisible ? 'black' : 'white'}.svg'),
      ),
      centerTitle: false,
      titleTextStyle: appBarTitleStyle,
      foregroundColor: commonBlackColor,
      bottom: _initAppBarIsVisible
          ? PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                height: 1.0,
                color: Colors.grey.withOpacity(0.3),
              ),
            )
          : null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () => checkScanPermission(context),
            icon: SvgPicture.asset(
                'assets/svg/icon/barcode_${_initAppBarIsVisible ? 'black' : 'white'}.svg'),
          ),
        ),
      ],
    );
  }

  void _navigateToBookSearchDetailScreen(String isbn13) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchDetailScreen(
          isbn13: isbn13,
        ),
      ),
    ).then((value) => {
          setState(() {
            ref.refresh(homeProvider.notifier).getTodayRegisteredBookCount();
          })
        });
  }

  void _navigateToMyInterestsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MyInterestsScreen(),
      ),
    ).then(
      (value) => setState(() {
        ref.refresh(homeProvider.notifier).getTodayRegisteredBookCount();
      }),
    );
  }

  void _refreshBookLists(UserInterests interests) async {
    await _homeRepository
        .getBookListByCategory(
          context: context,
          type: 'Bestseller',
          categoryId: interests.code,
        )
        .then(
          (data) => setState(() {
            _bookListByCategory = data.books!;
          }),
        );
  }

  void _refreshRankingBookList(String rankingCategory) async {
    await _homeRepository
        .getBooksByRanking(context: context, order: rankingCategory, limit: 6)
        .then(
          (data) => setState(() {
            _booksRankingList = data.books;
          }),
        );
  }

  List<UserInterests> _getUserInterests(List<UserInterests>? userInterests) {
    List<UserInterests> interests = userInterests ?? [];
    List<UserInterests> assignedInterests = List.filled(
      3,
      UserInterests.fromJson(UserInterests().toJson()),
    );

    for (int i = 0; i < interests.length && i < 3; i++) {
      assignedInterests[i] = interests[i];
    }

    return assignedInterests;
  }

  void _setInterests(UserInterests interest, String category) {
    if (interest.name != null && category == interest.name!) {
      _refreshBookLists(interest);
      _scrollToTop();
    }
  }

  bool isError(List<dynamic> states) {
    return states.any((state) => state is CommonResponseError);
  }
}
