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
  final GlobalKey _recommendKeywordWidgetKey = GlobalKey();
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
                padding: EdgeInsets.only(
                  left: 32.0,
                  right: 32.0,
                  top: index == 0 ? 12.0 : 24.0,
                  bottom: index == recommendScreenData.length - 1 ? 24.0 : 12.0,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 580 +
                      (_getRecommendKeywordWidgetHeight() == null
                          ? 0
                          : _getRecommendKeywordWidgetHeight()!.height * 0.3),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 150,
                              decoration: BoxDecoration(
                                color: greyF4F4F4,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    recommendScreenData[index].thumbnailUrl,
                                  ),
                                  onError: (exception, stackTrace) =>
                                      Image.asset(
                                    'assets/img/logo/mybrary.png',
                                    fit: BoxFit.fill,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x33000000),
                                    blurRadius: 10,
                                    offset: Offset(4, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              recommendScreenData[index].title,
                              style: recommendFeedBookTitleStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              recommendScreenData[index]
                                  .authors
                                  .map((author) => author)
                                  .join(', '),
                              style: recommendFeedBookSubStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      commonDivider(
                        dividerColor: greyF7F7F7,
                        dividerThickness: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          key: _recommendKeywordWidgetKey,
                          children: [
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              alignment: WrapAlignment.center,
                              children: recommendScreenData[index]
                                  .recommendationTargetNames
                                  .map(
                                (recommendKeyword) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: circularGreenColor,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Text(
                                      recommendKeyword,
                                      style: recommendSubStyle.copyWith(
                                        fontSize: 14.0,
                                        color: primaryColor,
                                        height: 1.2,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              '에게 추천',
                              style: recommendTitleStyle.copyWith(
                                fontSize: 14.0,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      commonDivider(
                        dividerColor: greyF7F7F7,
                        dividerThickness: 4,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 24.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: SvgPicture.asset(
                                    'assets/svg/icon/left_quote.svg'),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0,
                                  ),
                                  child: Text(
                                    recommendScreenData[index].content,
                                    style: recommendFeedHeaderStyle.copyWith(
                                      fontWeight: FontWeight.w400,
                                      height: 1.8,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: SvgPicture.asset(
                                    'assets/svg/icon/right_quote.svg'),
                              ),
                            ],
                          ),
                        ),
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

  Size? _getRecommendKeywordWidgetHeight() {
    if (_recommendKeywordWidgetKey.currentContext != null) {
      final RenderBox renderBox = _recommendKeywordWidgetKey.currentContext!
          .findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
    return null;
  }
}
