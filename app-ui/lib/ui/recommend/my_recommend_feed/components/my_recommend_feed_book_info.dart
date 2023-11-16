import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';

class MyRecommendFeedBookInfo extends StatelessWidget {
  final String title;
  final List<String> recommendationTargetNames;
  final String content;

  const MyRecommendFeedBookInfo({
    required this.title,
    required this.recommendationTargetNames,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: recommendBookTitleStyle,
        ),
        const SizedBox(height: 2.0),
        Text(
          recommendationTargetNames.map((targetName) => targetName).join(', '),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: recommendBookSubStyle.copyWith(
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          content,
          overflow: TextOverflow.ellipsis,
          style: recommendBookSubStyle.copyWith(
            fontSize: 13.0,
          ),
        ),
      ],
    );
  }
}
