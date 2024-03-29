import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/provider/home/home_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/home/home_screen.dart';
import 'package:mybrary/ui/mybook/mybook_screen.dart';
import 'package:mybrary/ui/profile/profile_screen.dart';
import 'package:mybrary/ui/recommend/recommend_screen.dart';
import 'package:mybrary/ui/search/search_screen.dart';

const bottomNavigationBarItemList = [
  {
    'label': '홈',
    'iconPath': 'assets/svg/nav/home.svg',
  },
  {
    'label': '추천',
    'iconPath': 'assets/svg/nav/recommend.svg',
  },
  {
    'label': '검색',
    'iconPath': 'assets/svg/nav/search.svg',
  },
  {
    'label': '마이북',
    'iconPath': 'assets/svg/nav/mybook.svg',
  },
  {
    'label': '프로필',
    'iconPath': 'assets/svg/nav/profile.svg',
  },
];

class RootTab extends ConsumerStatefulWidget {
  final int? tapIndex;

  const RootTab({
    this.tapIndex,
    super.key,
  });

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int index = 0;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 5,
      vsync: this,
      animationDuration: Duration.zero,
    );

    if (widget.tapIndex != null) {
      index = widget.tapIndex!;
      tabController.index = widget.tapIndex!;
    }

    tabController.addListener(_tabListener);
  }

  void _tabListener() {
    setState(() {
      index = tabController.index;
      if (index == 0) {
        ref.refresh(homeProvider.notifier).getTodayRegisteredBookCount();
      }
    });
  }

  @override
  void dispose() {
    tabController.removeListener(_tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: greyF1F2F5,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: commonWhiteColor,
          selectedItemColor: commonBlackColor,
          unselectedItemColor: greyACACAC,
          selectedFontSize: 13,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          unselectedFontSize: 13,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            tabController.animateTo(index);
          },
          currentIndex: index,
          items: bottomNavigationBarItemList
              .map(
                (e) => BottomNavigationBarItem(
                  label: e['label'],
                  icon: Column(
                    children: [
                      SvgPicture.asset(
                        e['iconPath']!,
                        colorFilter: const ColorFilter.mode(
                          greyACACAC,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                  activeIcon: Column(
                    children: [
                      SvgPicture.asset(e['iconPath']!),
                      const SizedBox(height: 4.0),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          HomeScreen(),
          RecommendScreen(),
          SearchScreen(),
          MyBookScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
