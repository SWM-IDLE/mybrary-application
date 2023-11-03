import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/recommend/recommend_feed_model.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/recommend/myRecommend/my_recommend_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

List<RecommendFeedModel> recommendScreenData = [
  RecommendFeedModel.fromJson({
    "content": "아버지의 장례식이 끝나고 아버지가 등장했다! 모이지 말아야 할 자리에서 시작된 복수극",
    "recommendationTargetNames": [
      "히가시노 게이고 팬",
      "추리소설을 좋아하는 사람",
      "시간이 잘 가지 않는 군인들"
    ],
    "userId": "USER_ID_1",
    "nickname": "이영자",
    "profileImageUrl":
        "https://d2k5miyk6y5zf0.cloudfront.net/article/MYH/20180720/MYH20180720017800038.jpg",
    "myBookId": 1,
    "bookId": 1,
    "title": "블랙 쇼맨과 이름 없는 마을의 살인",
    "thumbnailUrl":
        "https://image.aladin.co.kr/product/25659/89/cover/8925591715_1.jpg",
    "isbn13": "9788925591711",
    "authors": ["히가시노 게이고"],
    "holderCount": 9,
    "interestCount": 9,
    "interested": true,
  })
];

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  final ScrollController _recommendScrollController = ScrollController();
  late bool _isVisibleAppBar = false;

  @override
  void initState() {
    super.initState();

    _recommendScrollController.addListener(_changeAppBarState);
  }

  void _changeAppBarState() {
    setState(() {
      if (_recommendScrollController.position.hasPixels) {
        _isVisibleAppBar = true;
      } else {
        _isVisibleAppBar = false;
      }
    });
  }

  @override
  void dispose() {
    _recommendScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: CustomScrollView(
        controller: _recommendScrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          _recommendAppBar(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: index == 0 ? 12.0 : 24.0,
                ),
                child: Container(
                  height: 580,
                  decoration: ShapeDecoration(
                    color: commonWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    shadows: [
                      BoxShadow(
                        color: commonBlackColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18.0,
                                  backgroundImage: NetworkImage(
                                    recommendScreenData[index].profileImageUrl,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  recommendScreenData[index].nickname,
                                  style: recommendFeedHeaderStyle,
                                ),
                              ],
                            ),
                            Text.rich(
                              TextSpan(
                                text: recommendScreenData[index]
                                    .interestCount
                                    .toString(),
                                style: recommendFeedHeaderStyle.copyWith(
                                  color: primaryColor,
                                ),
                                children: const [
                                  TextSpan(
                                    text: ' 명의 픽',
                                    style: recommendFeedHeaderStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      commonDivider(
                        dividerColor: greyF7F7F7,
                        dividerThickness: 4,
                      ),
                    ],
                  ),
                ),
              ),
              childCount: recommendScreenData.length,
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _recommendAppBar() {
    return SliverAppBar(
      toolbarHeight: 70.0,
      backgroundColor: commonWhiteColor,
      elevation: _isVisibleAppBar ? 0.5 : 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SvgPicture.asset('assets/svg/icon/mybrary_black.svg'),
      ),
      pinned: true,
      centerTitle: false,
      titleTextStyle: appBarTitleStyle,
      foregroundColor: commonBlackColor,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyRecommendScreen(),
                ),
              );
            },
            icon: SvgPicture.asset('assets/svg/icon/add_button.svg'),
          ),
        ),
      ],
    );
  }
}
