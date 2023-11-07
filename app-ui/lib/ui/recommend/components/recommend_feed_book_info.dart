import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/utils/logics/book_utils.dart';

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
            decoration: commonBookThumbnailStyle(
              thumbnailUrl: thumbnailUrl,
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
