import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/books_by_category_model.dart';
import 'package:mybrary/data/model/home/books_by_interest_model.dart';
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
import 'package:mybrary/utils/logics/permission_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _homeRepository = HomeRepository();

  late String _bookCategory = '';
  late List<UserInterests> interests = [];
  late List<BooksModel> _bookListByCategory = [];

  late bool _initAppBarIsVisible = false;

  final ScrollController _homeScrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    sendNotificationMessage();

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        ref.refresh(homeProvider.notifier).getTodayRegisteredBookCount();
        ref.read(bestSellerProvider.notifier).getBooksByBestSeller();
        ref
            .read(recommendationBooksProvider.notifier)
            .getBooksByFirstInterests();
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
      interests = _getUserInterests(booksByInterests.userInterests);

      if (_bookListByCategory.isEmpty &&
          booksByInterests.userInterests!.isNotEmpty) {
        _bookListByCategory.addAll([...booksByInterests.bookRecommendations!]);
        _bookCategory = interests.first.name!;
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
                          interests;

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
            onPressed: () => onIsbnScan(context),
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
        ref
            .refresh(recommendationBooksProvider.notifier)
            .getBooksByFirstInterests();
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
