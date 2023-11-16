import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/res/constants/style.dart';

class RecommendFeedContent extends StatelessWidget {
  final String content;

  const RecommendFeedContent({
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 24.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/svg/icon/left_quote.svg'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
              ),
              child: Text(
                content,
                style: recommendFeedHeaderStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SvgPicture.asset('assets/svg/icon/right_quote.svg'),
        ],
      ),
    );
  }
}
