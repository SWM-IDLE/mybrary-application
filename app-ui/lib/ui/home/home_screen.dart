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
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/home/components/home_barcode_button.dart';
import 'package:mybrary/ui/home/components/home_best_seller.dart';
import 'package:mybrary/ui/home/components/home_book_count.dart';
import 'package:mybrary/ui/home/components/home_intro.dart';
import 'package:mybrary/ui/home/components/home_recommend_books.dart';
import 'package:mybrary/ui/profile/my_interests/my_interests_screen.dart';
import 'package:mybrary/ui/search/search_detail/search_detail_screen.dart';

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

  final ScrollController _categoryScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(homeProvider.notifier).getTodayRegisteredBookCount();
    ref.read(bestSellerProvider.notifier).getBooksByBestSeller();
    ref.read(recommendationBooksProvider.notifier).getBooksByFirstInterests();
  }

  void _scrollToTop() {
    _categoryScrollController.animateTo(
      0,
      duration: const Duration(microseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayRegisteredBookCount =
        ref.watch(todayRegisteredBookCountProvider);
    final booksByBestSeller = ref.watch(homeBestSellerProvider);
    final booksByInterests = ref.watch(homeRecommendationBooksProvider);

    if (booksByBestSeller == null) {
      return _initHomeLayout(
        todayRegisteredBookCount: todayRegisteredBookCount,
        child: [
          _sliverLoadingBox(),
        ],
      );
    }

    if (booksByInterests == null) {
      return _initHomeLayout(
        todayRegisteredBookCount: todayRegisteredBookCount,
        child: [
          _sliverBestSellerBox(booksByBestSeller),
          _sliverLoadingBox(),
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

    return DefaultLayout(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          _homeAppBar(),
          const HomeIntro(),
          const HomeBarcodeButton(),
          _sliverTodayRegisteredBookCountBox(todayRegisteredBookCount),
          _sliverBestSellerBox(booksByBestSeller),
          _sliverRecommendationBooksHeaderBox(),
          if (booksByInterests.userInterests!.isEmpty)
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () {
                  _navigateToMyInterestsScreen();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '지금 바로 마이 관심사를 등록해보세요!',
                        style: commonSubRegularStyle.copyWith(
                          fontSize: 15.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(
                        child: SvgPicture.asset(
                          'assets/svg/icon/right_arrow.svg',
                          width: 14.0,
                          height: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
          )
        ],
      ),
    );
  }

  SliverToBoxAdapter _sliverRecommendationBooksHeaderBox() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          bottom: 12.0,
        ),
        child: Row(
          children: [
            Text(
              '추천 도서, ',
              style: commonSubBoldStyle,
            ),
            Text(
              '이건 어때요?',
              style: commonMainRegularStyle,
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

  SliverToBoxAdapter _sliverBestSellerBox(
      BooksByCategoryModel booksByBestSeller) {
    return SliverToBoxAdapter(
      child: Container(
        height: 258,
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: HomeBestSeller(
          bookListByBestSeller: booksByBestSeller.books,
          onTapBook: (String isbn13) {
            _navigateToBookSearchDetailScreen(isbn13);
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _sliverLoadingBox() {
    return const SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  DefaultLayout _initHomeLayout({
    required TodayRegisteredBookCountModel? todayRegisteredBookCount,
    List<Widget>? child,
  }) {
    return DefaultLayout(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          _homeAppBar(),
          const HomeIntro(),
          const HomeBarcodeButton(),
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

  SliverAppBar _homeAppBar() {
    return SliverAppBar(
      toolbarHeight: 70.0,
      backgroundColor: commonWhiteColor,
      elevation: 0,
      pinned: true,
      title: SvgPicture.asset('assets/svg/icon/home_logo.svg'),
      titleTextStyle: appBarTitleStyle,
      centerTitle: false,
      foregroundColor: commonBlackColor,
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
}
