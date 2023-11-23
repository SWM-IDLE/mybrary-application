import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/profile/my_interests_response.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/mybook/mybook_review_list/mybook_review_list_screen.dart';
import 'package:mybrary/ui/profile/my_badge/my_badge_screen.dart';
import 'package:mybrary/ui/recommend/my_recommend_feed/my_recommend_feed_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class ProfileIntro extends StatelessWidget {
  final String userId;
  final String? introduction;
  final List<UserInterests> userInterests;
  final VoidCallback onTapWriteIntroduction;
  final VoidCallback onTapMyInterests;

  const ProfileIntro({
    required this.userId,
    required this.introduction,
    required this.userInterests,
    required this.onTapWriteIntroduction,
    required this.onTapMyInterests,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '한 줄 소개',
            style: commonSubTitleStyle,
          ),
          const SizedBox(height: 12.0),
          GestureDetector(
            onTap: () {
              if (introduction == '') {
                onTapWriteIntroduction();
              }
            },
            child: Text(
              introduction == '' ? '한 줄 소개 작성하기' : introduction!,
              style: commonEditContentStyle.copyWith(
                decoration:
                    introduction == '' ? TextDecoration.underline : null,
              ),
            ),
          ),
          const SizedBox(height: 42.0),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onTapMyInterests();
            },
            child: commonSubTitle(title: '마이 관심사'),
          ),
          const SizedBox(height: 12.0),
          Text(
            userInterests.isEmpty
                ? '나의 관심사를 표시해보세요!'
                : userInterests.map((interest) => interest.name).join(', '),
            style: commonEditContentStyle,
          ),
          const SizedBox(height: 42.0),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MyRecommendFeedScreen(
                    userId: userId,
                  ),
                ),
              );
            },
            child: commonSubTitle(title: '마이 추천 피드'),
          ),
          const SizedBox(height: 42.0),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MyReviewListScreen(
                    userId: userId,
                  ),
                ),
              );
            },
            child: commonSubTitle(title: '마이 리뷰 목록'),
          ),
          const SizedBox(height: 42.0),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MyBadgeScreen(),
                ),
              );
            },
            child: commonSubTitle(title: '마이 뱃지'),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 72.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                final iconPath = [
                  'assets/svg/badge/beginner_reviewer.svg',
                  'assets/svg/badge/my_member.svg',
                  'assets/svg/badge/read_through.svg',
                  'assets/svg/badge/influencer.svg',
                ];

                return Container(
                  width: 72.0,
                  height: 72.0,
                  margin: const EdgeInsets.only(right: 10.0),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: bookBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: SvgPicture.asset(
                    iconPath[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
