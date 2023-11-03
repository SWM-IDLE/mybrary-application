import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class MyRecommendContent extends StatelessWidget {
  final TextEditingController recommendContentController;

  const MyRecommendContent({
    required this.recommendContentController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '하고 싶은 말*',
            style: recommendTitleStyle,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            maxLines: 3,
            maxLength: 50,
            cursorColor: primaryColor,
            textInputAction: TextInputAction.done,
            style: recommendEditStyle.copyWith(
              color: grey262626,
              fontSize: 14.0,
            ),
            controller: recommendContentController,
            scrollPadding: EdgeInsets.only(
              bottom: bottomInset(context),
            ),
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16.0),
              hintText: '책의 줄거리나 요약, 명대사 등\n추천하고 싶은 대상에게 하고 싶은 말을 작성해보세요 :)',
              hintStyle: recommendEditStyle.copyWith(
                fontSize: 14.0,
                letterSpacing: -1,
              ),
              filled: true,
              fillColor: greyF7F7F7,
              focusColor: greyF7F7F7,
              border: searchInputBorderStyle,
              focusedBorder: searchInputBorderStyle,
              enabledBorder: searchInputBorderStyle,
            ),
          ),
        ],
      ),
    );
  }
}
