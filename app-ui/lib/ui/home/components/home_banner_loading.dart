import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/components/circular_loading.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class HomeBannerLoading extends StatelessWidget {
  const HomeBannerLoading({super.key});

  @override
  Widget build(BuildContext context) {
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
              height: mediaQueryHeight(context) * 0.15,
              bottom: 0,
              child: const CircularLoading(),
            ),
          ],
        ),
      ),
    );
  }
}
