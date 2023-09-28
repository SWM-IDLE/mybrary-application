import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: mediaQueryHeight(context) * 0.45,
        child: Stack(
          children: [
            Container(
              color: primaryColor,
              height: mediaQueryHeight(context) * 0.33,
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
              left: mediaQueryWidth(context) * 0.05,
              bottom: mediaQueryHeight(context) * 0.05,
              child: Container(
                height: mediaQueryHeight(context) * 0.13,
                width: mediaQueryWidth(context) * 0.9,
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
                child: Text('hi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
