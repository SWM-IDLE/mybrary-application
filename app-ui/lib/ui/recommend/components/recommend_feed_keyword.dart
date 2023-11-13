import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';

class RecommendFeedKeyword extends StatelessWidget {
  final List<String> recommendationTargetNames;

  const RecommendFeedKeyword({
    required this.recommendationTargetNames,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            alignment: WrapAlignment.center,
            children: recommendationTargetNames.map(
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
    );
  }
}
