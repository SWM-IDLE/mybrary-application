import 'package:flutter/material.dart';
import 'package:mybrary/data/model/recommend/my_recommend_feed_model.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/utils/logics/book_utils.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

List<MyRecommendFeedModel> myRecommendFeedData = [
  MyRecommendFeedModel.fromJson({
    "content": "아버지의 장례식이 끝나고 아버지가 등장했다! 모이지 말아야 할 자리에서 시작된 복수극",
    "recommendationFeedId": 1,
    "myBookId": 1,
    "bookId": 1,
    "title": "블랙 쇼맨과 이름 없는 마을의 살인",
    "thumbnailUrl":
        "https://image.aladin.co.kr/product/25659/89/cover/8925591715_1.jpg",
    "isbn13": "9788925591711",
    "createdAt": "2023.11.05",
    "recommendationTargetNames": [
      "히가시노 게이고의 팬",
      "추리소설을 좋아하는 사람",
    ],
  }),
  MyRecommendFeedModel.fromJson({
    "content": "아버지의 장례식이 끝나고 아버지가 등장했다! 모이지 말아야 할 자리에서 시작된 복수극",
    "recommendationFeedId": 1,
    "myBookId": 1,
    "bookId": 1,
    "title": "블랙 쇼맨과 이름 없는 마을의 살인",
    "thumbnailUrl":
        "https://image.aladin.co.kr/product/25659/89/cover/8925591715_1.jpg",
    "isbn13": "9788925591711",
    "createdAt": "2023.11.05",
    "recommendationTargetNames": [
      "히가시노 게이고의 팬",
      "추리소설을 좋아하는 사람",
    ],
  }),
];

class MyRecommendPostScreen extends StatefulWidget {
  const MyRecommendPostScreen({super.key});

  @override
  State<MyRecommendPostScreen> createState() => _MyRecommendPostScreenState();
}

class _MyRecommendPostScreenState extends State<MyRecommendPostScreen> {
  @override
  Widget build(BuildContext context) {
    return SubPageLayout(
      appBarTitle: '마이 추천 포스트',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: myRecommendFeedData.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        decoration: commonBookThumbnailStyle(
                          thumbnailUrl: myRecommendFeedData[index].thumbnailUrl,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  myRecommendFeedData[index].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: recommendBookTitleStyle,
                                ),
                                const SizedBox(height: 2.0),
                                Text(
                                  myRecommendFeedData[index]
                                      .recommendationTargetNames
                                      .map((targetName) => targetName)
                                      .join(', '),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: recommendBookSubStyle.copyWith(
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  myRecommendFeedData[index].content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: recommendBookSubStyle.copyWith(
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              myRecommendFeedData[index].createdAt,
                              style: recommendBookSubStyle.copyWith(
                                color: grey777777,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                  ),
                  child: commonDivider(
                    dividerColor: greyACACAC,
                    dividerThickness: 1,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
