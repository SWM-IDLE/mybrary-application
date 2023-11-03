import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';

class MyRecommendHeader extends StatelessWidget {
  final int bookId;
  final String bookTitle;
  final String thumbnailUrl;
  final String bookAuthor;
  final void Function()? onTapAddBook;
  final void Function()? onTapEditBook;

  const MyRecommendHeader(
      {required this.bookId,
      required this.bookTitle,
      required this.thumbnailUrl,
      required this.bookAuthor,
      required this.onTapAddBook,
      required this.onTapEditBook,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                InkWell(
                  onTap: onTapAddBook,
                  child: Hero(
                    tag: bookId,
                    child: Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        color: greyF4F4F4,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        image: thumbnailUrl == ''
                            ? null
                            : DecorationImage(
                                image: NetworkImage(
                                  thumbnailUrl,
                                ),
                                onError: (exception, stackTrace) => Image.asset(
                                  'assets/img/logo/mybrary.png',
                                  fit: BoxFit.fill,
                                ),
                                fit: BoxFit.fill,
                              ),
                        boxShadow: thumbnailUrl == ''
                            ? null
                            : [
                                const BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 10,
                                  offset: Offset(4, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                      ),
                      child: Center(
                        child: Text(
                          thumbnailUrl == '' ? '+ 책 추가' : '',
                          style: recommendBookSubStyle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                if (thumbnailUrl != '')
                  InkWell(
                    onTap: onTapEditBook,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 2.0,
                      ),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1.0,
                            style: BorderStyle.solid,
                            color: grey262626,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: const Text(
                        '책 변경하기',
                        style: recommendBookEditStyle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 32.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.0),
                  Text(
                    bookTitle == '' ? '책 제목' : bookTitle,
                    style: recommendBookTitleStyle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    bookAuthor == ''
                        ? '마이북을 추가하여\n추천 피드를 작성해 보세요.'
                        : bookAuthor,
                    style: recommendBookSubStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
