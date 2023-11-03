import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';

class RecommendFeedBookInfo extends StatelessWidget {
  final String thumbnailUrl;
  final String title;
  final List<String> authors;

  const RecommendFeedBookInfo({
    required this.thumbnailUrl,
    required this.title,
    required this.authors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                image: NetworkImage(thumbnailUrl),
                onError: (exception, stackTrace) => Image.asset(
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
            title,
            style: recommendFeedBookTitleStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            authors.map((author) => author).join(', '),
            style: recommendFeedBookSubStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
