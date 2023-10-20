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
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/data/repository/home_repository.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/error_page.dart';
import 'package:mybrary/ui/common/components/sliver_loading.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/home/components/home_barcode_button.dart';
import 'package:mybrary/ui/home/components/home_best_seller.dart';
import 'package:mybrary/ui/home/components/home_book_count.dart';
import 'package:mybrary/ui/home/components/home_interest_setting_button.dart';
import 'package:mybrary/ui/home/components/home_intro.dart';
import 'package:mybrary/ui/home/components/home_recommend_books.dart';
import 'package:mybrary/ui/home/components/home_recommend_books_header.dart';
import 'package:mybrary/ui/profile/my_interests/my_interests_screen.dart';
import 'package:mybrary/ui/search/search_detail/search_detail_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

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
        child: [const SliverLoading()],
      );
    }

    if (booksByInterests == null) {
      return _initHomeLayout(
        todayRegisteredBookCount: todayRegisteredBookCount,
        child: [
          _sliverBestSellerBox(booksByBestSeller),
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
            )
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

  bool isError(List<dynamic> states) {
    return states.any((state) => state is CommonResponseError);
  }
}
