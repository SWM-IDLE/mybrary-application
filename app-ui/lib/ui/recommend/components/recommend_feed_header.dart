import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';

class RecommendFeedHeader extends StatefulWidget {
  final String profileImageUrl;
  final String nickname;
  final int interestCount;
  final bool interested;

  const RecommendFeedHeader({
    required this.profileImageUrl,
    required this.nickname,
    required this.interestCount,
    required this.interested,
    super.key,
  });

  @override
  State<RecommendFeedHeader> createState() => _RecommendFeedHeaderState();
}

class _RecommendFeedHeaderState extends State<RecommendFeedHeader> {
  late bool _showReportButton = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.0,
                    backgroundImage: NetworkImage(widget.profileImageUrl),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.nickname,
                    style: recommendFeedHeaderStyle,
                  ),
                ],
              ),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: widget.interestCount.toString(),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 6.0,
                      right: 2.0,
                    ),
                    child: SvgPicture.asset(
                        'assets/svg/icon/small/${widget.interested ? 'heart_green' : 'heart'}.svg'),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showReportButton = !_showReportButton;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 6.0,
                        right: 4.0,
                      ),
                      child: SvgPicture.asset(
                          'assets/svg/icon/small/more_vert.svg'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_showReportButton)
            Positioned(
              bottom: -4,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: commonWhiteColor,
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: [
                    BoxShadow(
                      color: commonBlackColor.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 0),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  '신고하기',
                  style: commonSubMediumStyle.copyWith(
                    fontSize: 14.0,
                    height: 1.2,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
