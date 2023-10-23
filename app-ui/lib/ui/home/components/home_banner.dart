import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/home/books_by_category_model.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class HomeBanner extends StatefulWidget {
  final List<BooksModel> bookListByBestSeller;
  final void Function(String) onTapBook;

  const HomeBanner({
    required this.bookListByBestSeller,
    required this.onTapBook,
    super.key,
  });

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _current = 0;

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    List<Widget> imageBox = widget.bookListByBestSeller
        .map(
          (book) => InkWell(
            onTap: () {
              widget.onTapBook(book.isbn13);
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  child: Container(
                    width: mediaQueryWidth(context),
                    decoration: BoxDecoration(
                      color: commonWhiteColor,
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
                    child: Container(
                      width: mediaQueryHeight(context) * 0.1,
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: mediaQueryWidth(context) * 0.4,
                            child: Text(
                              book.title!,
                              style: commonSubBoldStyle.copyWith(
                                fontSize: 15,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            book.authors!.length > 15
                                ? '${book.authors!.substring(0, 15)}...'
                                : book.authors!,
                            style: commonSubRegularStyle.copyWith(
                              fontSize: 11.0,
                            ),
                          ),
                          Text(
                            '⭐${book.aladinStarRating}',
                            style: commonSubMediumStyle.copyWith(
                              fontSize: 11.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Text(
                                '베스트셀러 보러가기',
                                style: commonSubRegularStyle.copyWith(
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              SvgPicture.asset(
                                'assets/svg/icon/right_arrow.svg',
                                width: 12.0,
                                height: 12.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: isAndroid ? -10 : -16,
                  bottom: 10,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left:
                          mediaQueryWidth(context) * (isAndroid ? 0.55 : 0.54),
                    ),
                    child: Container(
                      width: mediaQueryWidth(context) * 0.23,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: greyDDDDDD,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            book.thumbnailUrl,
                          ),
                          onError: (exception, stackTrace) => Image.asset(
                            'assets/img/logo/mybrary.png',
                            fit: BoxFit.fill,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: mediaQueryHeight(context) * 0.43,
        child: Stack(
          children: [
            Container(
              color: primaryColor,
              height: mediaQueryHeight(context) * 0.30,
            ),
            Positioned(
              top: mediaQueryHeight(context) * (isAndroid ? 0.13 : 0.14),
              left: mediaQueryWidth(context) * 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '이주의 ',
                        style: homeBannerTitleLightStyle,
                      ),
                      Text(
                        '베스트 셀러 📚',
                        style: homeBannerTitleBoldStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              width: mediaQueryWidth(context),
              height: mediaQueryHeight(context) * 0.25,
              bottom: 0,
              child: CarouselSlider(
                items: imageBox,
                carouselController: _controller,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  aspectRatio: 2.8,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
            ),
            Positioned(
              bottom: mediaQueryWidth(context) * (isAndroid ? 0 : 0.02),
              width: mediaQueryWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.bookListByBestSeller.asMap().entries.map(
                  (entry) {
                    return InkWell(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 18.0,
                        height: 5.0,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              _current == entry.key ? primaryColor : greyDDDDDD,
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
