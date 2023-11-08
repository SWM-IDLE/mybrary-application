import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class MyRecommendKeyword extends StatelessWidget {
  final TextEditingController recommendKeywordListController;
  final List<String> recommendKeywordList;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool clearRecommendKeyword;
  final void Function()? onTapClearRecommendKeywordText;
  final void Function(int index)? onTapRemoveRecommendKeyword;

  const MyRecommendKeyword({
    required this.recommendKeywordListController,
    required this.recommendKeywordList,
    required this.onChanged,
    required this.onFieldSubmitted,
    required this.clearRecommendKeyword,
    required this.onTapClearRecommendKeywordText,
    required this.onTapRemoveRecommendKeyword,
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
          const Row(
            children: [
              Text(
                '____',
                style: recommendTitleStyle,
              ),
              SizedBox(width: 4.0),
              Text(
                '에게 추천*',
                style: recommendTitleStyle,
              ),
              SizedBox(width: 4.0),
              Text(
                '최대 5개 키워드',
                style: recommendSubStyle,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: recommendKeywordListController,
            cursorColor: primaryColor,
            textInputAction: TextInputAction.done,
            style: recommendEditStyle.copyWith(
              color: grey262626,
            ),
            maxLength: 15,
            readOnly: recommendKeywordList.length > 4 ? true : false,
            scrollPadding: EdgeInsets.only(
              bottom: bottomInset(context) * 0.5,
            ),
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              hintText: '내가 추천하고 싶은 대상은? (15자 이내)',
              hintStyle: recommendEditStyle.copyWith(
                letterSpacing: -1,
              ),
              filled: true,
              fillColor:
                  recommendKeywordList.length > 4 ? greyDDDDDD : greyF7F7F7,
              focusColor: greyF7F7F7,
              border: searchInputBorderStyle,
              focusedBorder: searchInputBorderStyle,
              enabledBorder: searchInputBorderStyle,
              counterText: '',
              suffix: recommendKeywordListController.text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                          "${recommendKeywordListController.text.length} / 15"),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minHeight: 24.0,
                minWidth: 24.0,
              ),
              suffixIcon: clearRecommendKeyword
                  ? InkWell(
                      onTap: onTapClearRecommendKeywordText,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: SvgPicture.asset(
                          'assets/svg/icon/clear.svg',
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16.0),
          if (recommendKeywordList.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/icon/empty_keyword.svg',
                      width: 24.0,
                      height: 24.0,
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      '예) 독서를 즐겨하는 사람,\n마이브러리를 좋아하는 사람:)',
                      style: recommendEmptyKeywordStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: recommendKeywordList.mapIndexed(
                  (index, recommendKeyword) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: commonGreenColor,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            recommendKeyword,
                            style: recommendSubStyle.copyWith(
                              fontSize: 15.0,
                              color: commonWhiteColor,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          InkWell(
                            onTap: () => onTapRemoveRecommendKeyword!(index),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: SvgPicture.asset(
                                'assets/svg/icon/white_clear.svg',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
