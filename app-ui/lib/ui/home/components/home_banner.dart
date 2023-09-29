import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/home/books_by_category_model.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class HomeBanner extends StatefulWidget {
  final List<BooksModel> bookListByBestSeller;

  const HomeBanner({
    required this.bookListByBestSeller,
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
          (item) => Container(
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
              width: 150,
              padding: const EdgeInsets.only(top: 16.0, left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: mediaQueryWidth(context) * 0.4,
                    child: Text(
                      '세상의 마지막 기차역',
                      style: commonSubBoldStyle.copyWith(
                        fontSize: 15.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '무라세 다케시',
                    style: commonSubRegularStyle.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    '⭐4.5',
                    style: commonSubMediumStyle.copyWith(
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      const Text(
                        '베스트셀러 보러가기',
                        style: commonSubRegularStyle,
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
        )
        .toList();

    List<Widget> imageSliders = widget.bookListByBestSeller
        .map(
          (item) => Padding(
            padding: EdgeInsets.only(left: mediaQueryWidth(context) * 0.45),
            child: Container(
              width: mediaQueryWidth(context) * 0.28,
              decoration: BoxDecoration(
                border: Border.all(
                  color: commonWhiteColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(
                    item.thumbnailUrl,
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
        )
        .toList();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: mediaQueryHeight(context) * 0.48,
        child: Stack(
          children: [
            Container(
              color: primaryColor,
              height: mediaQueryHeight(context) * 0.32,
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
                        '베스트 셀러',
                        style: homeBannerTitleBoldStyle,
                      ),
                      Text(
                        '를',
                        style: homeBannerTitleLightStyle,
                      ),
                    ],
                  ),
                  Text(
                    '만나러 가보실까요? 📚',
                    style: homeBannerTitleLightStyle,
                  ),
                ],
              ),
            ),
            Positioned(
              width: mediaQueryWidth(context),
              height: mediaQueryHeight(context) * 0.2,
              bottom: mediaQueryHeight(context) * 0.04,
              child: CarouselSlider(
                items: imageBox,
                carouselController: _controller,
                options: CarouselOptions(
                  aspectRatio: 2.6,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: true,
                ),
              ),
            ),
            Positioned(
              width: mediaQueryWidth(context),
              height: mediaQueryHeight(context) * 0.19,
              bottom: mediaQueryHeight(context) * 0.065,
              child: CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
            ),
            Positioned(
              bottom: mediaQueryWidth(context) * 0.03,
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
