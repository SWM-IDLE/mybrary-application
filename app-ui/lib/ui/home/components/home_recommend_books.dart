import 'package:flutter/material.dart';
import 'package:mybrary/data/model/home/books_by_category_model.dart';
import 'package:mybrary/data/model/home/books_by_interest_model.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';

class HomeRecommendBooks extends StatelessWidget {
  final String category;
  final List<UserInterests> userInterests;
  final List<BooksModel> bookListByCategory;
  final void Function(String) onTapCategory;
  final void Function(String) onTapBook;
  final ScrollController categoryScrollController;
  final VoidCallback onTapMyInterests;

  const HomeRecommendBooks({
    required this.category,
    required this.userInterests,
    required this.bookListByCategory,
    required this.onTapCategory,
    required this.onTapBook,
    required this.categoryScrollController,
    required this.onTapMyInterests,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(
              userInterests.length,
              (index) => InkWell(
                onTap: () {
                  onTapCategory(userInterests[index].name!);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 19.0,
                    vertical: 7.0,
                  ),
                  decoration: BoxDecoration(
                    color: category == userInterests[index].name!
                        ? grey262626
                        : commonWhiteColor,
                    border: Border.all(
                      color: grey777777,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    userInterests[index].name!,
                    style: categoryCircularTextStyle.copyWith(
                      color: category == userInterests[index].name!
                          ? commonWhiteColor
                          : grey262626,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: categoryScrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: bookListByCategory.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  bottom: 10.0,
                ),
                child: Row(
                  children: [
                    if (index == 0)
                      const SizedBox(
                        width: 16.0,
                      ),
                    InkWell(
                      onTap: () {
                        onTapBook(bookListByCategory[index].isbn13);
                      },
                      child: Container(
                        width: 116,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              bookListByCategory[index].thumbnailUrl,
                            ),
                            onError: (exception, stackTrace) => Image.asset(
                              'assets/img/logo/mybrary.png',
                              fit: BoxFit.fill,
                            ),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 2,
                              offset: Offset(1, 1),
                              spreadRadius: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                    if (index == bookListByCategory.length - 1)
                      const SizedBox(
                        width: 8.0,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
