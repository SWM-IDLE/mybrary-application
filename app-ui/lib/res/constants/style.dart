import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mybrary/res/constants/color.dart';

// common style
const systemDarkUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light, // android
  statusBarBrightness: Brightness.dark, // ios
);

const systemLightUiOverlayStyle = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);

const appBarTitleStyle = TextStyle(
  color: commonBlackColor,
  fontSize: 22.0,
  fontWeight: FontWeight.w700,
);

const bottomSheetStyle = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  ),
);

const bottomSheetMenuTextStyle = TextStyle(
  color: grey262626,
  height: 1.0,
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
);

const commonSubTitleStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w700,
);

const commonSubThinStyle = TextStyle(
  color: grey777777,
  fontSize: 12.0,
  fontWeight: FontWeight.w300,
);

const commonMainRegularStyle = TextStyle(
  color: grey262626,
  fontSize: 18.0,
  fontWeight: FontWeight.w400,
);

const commonSubRegularStyle = TextStyle(
  color: grey262626,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const commonSubMediumStyle = TextStyle(
  color: grey262626,
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);

const commonSubBoldStyle = TextStyle(
  color: grey262626,
  fontSize: 18.0,
  fontWeight: FontWeight.w700,
);

const commonButtonTextStyle = TextStyle(
  color: grey262626,
  fontSize: 15.0,
  fontWeight: FontWeight.w700,
);

const commonDialogMessageStyle = TextStyle(
  color: commonBlackColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w400,
);

final commonMenuButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.transparent,
  foregroundColor: Colors.transparent,
  surfaceTintColor: Colors.transparent,
  splashFactory: NoSplash.splashFactory,
);

const commonSnackBarMessageStyle = TextStyle(
  color: commonWhiteColor,
  fontSize: 13.0,
);

const commonSnackBarButtonStyle = TextStyle(
  color: primaryColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
);

const boxBorderRadiusStyle = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(50.0),
  ),
);

const saveTextButtonStyle = TextStyle(
  color: primaryColor,
  fontSize: 17.0,
  fontWeight: FontWeight.w400,
);

// profile page style
const followTextStyle = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const inputHintStyle = TextStyle(
  color: inputHintColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const nameInputBorderStyle = UnderlineInputBorder(
  borderSide: BorderSide(
    color: circularBorderColor,
    width: 1,
  ),
);

const introInputBorderStyle = OutlineInputBorder(
  borderSide: BorderSide(
    color: circularBorderColor,
    width: 1,
  ),
);

const introInputBorderBottomStyle = UnderlineInputBorder(
  borderSide: BorderSide(
    color: circularBorderColor,
    width: 1,
  ),
);

const commonEditTitleStyle = TextStyle(
  color: grey262626,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const commonEditContentStyle = TextStyle(
  color: grey777777,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const interestDescriptionStyle = TextStyle(
  color: grey262626,
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
);

const followNicknameStyle = TextStyle(
  color: commonBlackColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);

const followButtonTextStyle = TextStyle(
  color: commonBlackColor,
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
);

// button style
final disableAnimationButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.transparent),
  elevation: MaterialStateProperty.all(0.0),
  splashFactory: NoSplash.splashFactory,
  overlayColor: MaterialStateProperty.all(Colors.transparent),
);

final disableTextButtonStyle = TextButton.styleFrom(
  splashFactory: NoSplash.splashFactory,
  minimumSize: Size.zero,
  padding: EdgeInsets.zero,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

final disableAnimationTextButtonStyle = TextButton.styleFrom(
  splashFactory: NoSplash.splashFactory,
  minimumSize: Size.zero,
  padding: EdgeInsets.zero,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
).copyWith(
  backgroundColor: MaterialStateProperty.all(Colors.transparent),
  elevation: MaterialStateProperty.all(0.0),
  splashFactory: NoSplash.splashFactory,
  overlayColor: MaterialStateProperty.all(Colors.transparent),
);

final followButtonRoundStyle = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
);

const popularKeywordTextStyle = TextStyle(
  color: circularTextColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const confirmButtonTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);

// border style
final searchInputBorderStyle = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.circular(5.0),
);

// button style
const bottomButtonTextStyle = TextStyle(
  color: commonWhiteColor,
  fontSize: 15.0,
  fontWeight: FontWeight.w700,
);

// home page style
final homeBannerTitleBoldStyle = TextStyle(
  color: commonWhiteColor,
  fontSize: 22.0,
  fontWeight: FontWeight.w700,
  shadows: [
    Shadow(
      color: commonBlackColor.withOpacity(0.2),
      blurRadius: 6,
      offset: const Offset(0, 4),
    ),
  ],
);

final homeBannerTitleLightStyle = TextStyle(
  color: commonWhiteColor,
  fontSize: 22.0,
  fontWeight: FontWeight.w300,
  shadows: [
    Shadow(
      color: commonBlackColor.withOpacity(0.2),
      blurRadius: 6,
      offset: const Offset(0, 4),
    ),
  ],
);

const todayRegisteredBookTextStyle = TextStyle(
  color: grey262626,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
);

const categoryCircularTextStyle = TextStyle(
  color: grey262626,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const todayRegisteredBookNickname = TextStyle(
  color: primaryColor,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
  height: 1.5,
);

const todayRegisteredBookIntroduction = TextStyle(
  color: grey262626,
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
  height: 1.5,
);

// book search page style
const searchBookTitleStyle = TextStyle(
  color: grey262626,
  fontSize: 15.0,
  fontWeight: FontWeight.w700,
);

const bookDetailTitleStyle = TextStyle(
  color: commonBlackColor,
  fontSize: 18.0,
  fontWeight: FontWeight.w700,
);

const bookDetailDescriptionStyle = TextStyle(
  height: 1.6,
  color: grey777777,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

const bookDetailSubStyle = TextStyle(
  height: 1.5,
  color: grey777777,
  fontSize: 16.0,
  fontWeight: FontWeight.w400,
);

const bookDetailInfoStyle = TextStyle(
  height: 1.5,
  color: commonBlackColor,
  fontSize: 16.0,
  fontWeight: FontWeight.w300,
);

const bookStatusStyle = TextStyle(
  color: grey777777,
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
);

const bookStatusCountStyle = TextStyle(
  color: grey262626,
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
);

const aladinTextStyle = TextStyle(
  height: 1.2,
  color: grey777777,
  fontSize: 11.0,
  fontWeight: FontWeight.w400,
);

const starRatingTextStyle = TextStyle(
  height: 1.25,
  color: grey262626,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);

const bookReviewTitleStyle = TextStyle(
  color: grey777777,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

// main page style
const mainIntroTextStyle = TextStyle(
  height: 1.2,
  color: grey262626,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

// mybook page style
const myBookAppBarTextStyle = TextStyle(
  color: commonBlackColor,
  fontSize: 17.0,
  fontWeight: FontWeight.w400,
);

const myBookButtonTitleStyle = TextStyle(
  color: grey262626,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
);

const myBookSubTextStyle = TextStyle(
  color: grey262626,
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
);

const myBookSortTextStyle = TextStyle(
  height: 1.3,
  color: grey262626,
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
);

const myBookListTitleStyle = TextStyle(
  height: 1.2,
  color: grey262626,
  fontSize: 13.0,
  fontWeight: FontWeight.w700,
);

const myBookListSubStyle = TextStyle(
  color: grey777777,
  fontSize: 11.0,
  fontWeight: FontWeight.w400,
);

const bookShelfTitleStyle = TextStyle(
  color: grey262626,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
);

// setting page style
const settingTitleStyle = TextStyle(
  color: grey777777,
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const settingSubTitleStyle = TextStyle(
  color: grey262626,
  fontSize: 15.0,
  fontWeight: FontWeight.w400,
);

const settingInfoStyle = TextStyle(
  color: commonWhiteColor,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
);

// recommend
const recommendBookTitleStyle = TextStyle(
  color: grey151816,
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
  letterSpacing: -1,
);

const recommendBookSubStyle = TextStyle(
  color: grey555555,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  letterSpacing: -1,
);

const recommendBookEditStyle = TextStyle(
  color: grey262626,
  fontSize: 11.0,
  fontWeight: FontWeight.w500,
  letterSpacing: -1,
  height: 1.2,
);

const recommendTitleStyle = TextStyle(
  color: grey151816,
  fontSize: 15.0,
  fontWeight: FontWeight.w700,
  letterSpacing: -1,
);

const recommendSubStyle = TextStyle(
  color: grey8D8D8D,
  fontSize: 13.0,
  fontWeight: FontWeight.w500,
  letterSpacing: -1,
);

const recommendEditStyle = TextStyle(
  color: grey8D8D8D,
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
);

const recommendEmptyKeywordStyle = TextStyle(
  color: grey8D8D8D,
  fontSize: 12.0,
  fontWeight: FontWeight.w400,
  letterSpacing: -1,
);

const recommendFeedHeaderStyle = TextStyle(
  color: grey151816,
  fontSize: 14.0,
  fontWeight: FontWeight.w700,
  letterSpacing: -1,
);

const recommendFeedBookTitleStyle = TextStyle(
  color: grey151816,
  fontSize: 16.0,
  fontWeight: FontWeight.w700,
  letterSpacing: -1,
);

const recommendFeedBookSubStyle = TextStyle(
  color: grey555555,
  fontSize: 14.0,
  fontWeight: FontWeight.w400,
  letterSpacing: -1,
);

const recommendMoreButtonStyle = TextStyle(
  color: grey262626,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  height: 1.2,
  letterSpacing: -1,
);

const recommendLastFeedStyle = TextStyle(
  color: grey555555,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  letterSpacing: -1,
);

final recommendBoxStyle = ShapeDecoration(
  color: commonWhiteColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
  shadows: [
    BoxShadow(
      color: commonBlackColor.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 0),
      spreadRadius: 2,
    ),
  ],
);

// padding
final double paddingTopHeight =
    Size.fromHeight(const SliverAppBar().toolbarHeight).height * 2;
