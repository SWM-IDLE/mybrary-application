import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/res/constants/style.dart';

class HomeInterestSettingButton extends StatelessWidget {
  final VoidCallback onTapMyInterests;

  const HomeInterestSettingButton({
    required this.onTapMyInterests,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          onTapMyInterests();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '지금 바로 마이 관심사를 등록해보세요!',
                style: commonSubRegularStyle.copyWith(
                  fontSize: 15.0,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(
                child: SvgPicture.asset(
                  'assets/svg/icon/right_arrow.svg',
                  width: 14.0,
                  height: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
