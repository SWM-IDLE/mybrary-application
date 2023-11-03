import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';

class RecommendFeedHeader extends StatelessWidget {
  final String profileImageUrl;
  final String nickname;
  final int interestCount;

  const RecommendFeedHeader({
    required this.profileImageUrl,
    required this.nickname,
    required this.interestCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.0,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              const SizedBox(width: 8.0),
              Text(
                nickname,
                style: recommendFeedHeaderStyle,
              ),
            ],
          ),
          Text.rich(
            TextSpan(
              text: interestCount.toString(),
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
    );
  }
}
