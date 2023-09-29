import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/books_by_category_model.dart';
import 'package:mybrary/data/model/home/books_by_interest_model.dart';
import 'package:mybrary/data/model/home/today_registered_book_count_model.dart';
import 'package:mybrary/data/provider/home/home_bestseller_provider.dart';
import 'package:mybrary/data/provider/home/home_provider.dart';
import 'package:mybrary/data/provider/home/home_recommendation_books_provider.dart';
import 'package:mybrary/data/repository/home_repository.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/error_page.dart';
import 'package:mybrary/ui/common/components/sliver_loading.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/home/components/home_banner.dart';
import 'package:mybrary/ui/home/components/home_book_count.dart';
import 'package:mybrary/ui/home/components/home_interest_setting_button.dart';
import 'package:mybrary/ui/home/components/home_recommend_books.dart';
import 'package:mybrary/ui/home/components/home_recommend_books_header.dart';
import 'package:mybrary/ui/profile/my_interests/my_interests_screen.dart';
import 'package:mybrary/ui/search/search_detail/search_detail_screen.dart';
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

    ref.read(homeProvider.notifier).getTodayRegisteredBookCount();
    ref.read(bestSellerProvider.notifier).getBooksByBestSeller();
    ref.read(recommendationBooksProvider.notifier).getBooksByFirstInterests();

    _homeScrollController.addListener(_changeAppBarComponent);
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
      return _initHomeLayout(
        todayRegisteredBookCount: todayRegisteredBookCount,
        child: [
          const SliverLoading(),
        ],
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
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 1),
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

  DefaultLayout _initHomeLayout({
    required TodayRegisteredBookCountModel? todayRegisteredBookCount,
    List<Widget>? child,
  }) {
    return DefaultLayout(
      appBar: _homeAppBar(),
      extendBodyBehindAppBar: true,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          HomeBanner(
            bookListByBestSeller: const [],
            onTapBook: (String isbn13) {},
          ),
          _sliverTodayRegisteredBookCountBox(todayRegisteredBookCount),
          if (child != null) ...child,
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30.0,
            ),
          ),
        ],
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
