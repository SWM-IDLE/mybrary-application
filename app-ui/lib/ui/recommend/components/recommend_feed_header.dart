import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/profile/user_report_model.dart';
import 'package:mybrary/data/provider/profile/user_report_provider.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_post_provider.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/config.dart';
import 'package:mybrary/res/constants/enum.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/recommend/components/recommend_feed_book_info.dart';
import 'package:mybrary/ui/search/search_detail_user_infos/search_detail_user_infos_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class RecommendFeedHeader extends ConsumerStatefulWidget {
  final String isbn13;
  final String targetUserId;
  final String profileImageUrl;
  final String nickname;
  final int interestCount;
  final bool interested;
  final int recommendationFeedId;
  final String thumbnailUrl;
  final String title;
  final List<String> authors;

  const RecommendFeedHeader({
    required this.isbn13,
    required this.targetUserId,
    required this.profileImageUrl,
    required this.nickname,
    required this.interestCount,
    required this.interested,
    required this.recommendationFeedId,
    required this.thumbnailUrl,
    required this.title,
    required this.authors,
    super.key,
  });

  @override
  ConsumerState<RecommendFeedHeader> createState() =>
      _RecommendFeedHeaderState();
}

class _RecommendFeedHeaderState extends ConsumerState<RecommendFeedHeader> {
  final TextEditingController _reasonContentController =
      TextEditingController();

  late bool _showMoreButton = false;
  bool onTapInterestBook = false;

  late int _tapReasonIndex;
  late String _tapReportReason;

  final _userId = UserState.userId;

  @override
  void initState() {
    super.initState();

    _tapReasonIndex = 0;
    _tapReportReason = userReportReason[_tapReasonIndex];
  }

  @override
  void dispose() {
    _reasonContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      moveToUserProfile(
                        context: context,
                        myUserId: _userId,
                        userId: widget.targetUserId,
                        nickname: widget.nickname,
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18.0,
                          backgroundColor: primaryColor,
                          backgroundImage: Image.network(
                            widget.profileImageUrl,
                            errorBuilder: (context, error, stackTrace) =>
                                SvgPicture.asset(
                              'assets/svg/icon/profile_default.svg',
                            ),
                          ).image,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          widget.nickname,
                          style: recommendFeedHeaderStyle,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SearchDetailUserInfosScreen(
                                title: '읽고싶어요',
                                isbn13: widget.isbn13,
                                userCount: widget.interestCount,
                                type: SearchDetailUserInfosType.interest,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text.rich(
                            TextSpan(
                              text: widget.interestCount.toString(),
                              style: recommendFeedHeaderStyle.copyWith(
                                color: primaryColor,
                              ),
                              children: const [
                                TextSpan(
                                  text: ' 명의 픽   📚',
                                  style: recommendFeedHeaderStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showMoreButton = !_showMoreButton;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/icon/small/more_vert.svg',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            commonDivider(
              dividerColor: greyF7F7F7,
              dividerThickness: 4,
            ),
            RecommendFeedBookInfo(
              isbn13: widget.isbn13,
              thumbnailUrl: widget.thumbnailUrl,
              title: widget.title,
              authors: widget.authors,
            ),
          ],
        ),
        if (_showMoreButton)
          Positioned(
            top: 20,
            right: 36,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: commonWhiteColor,
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: [
                  BoxShadow(
                    color: commonBlackColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (widget.targetUserId != _userId) ...[
                    InkWell(
                      onTap: () => _showUserReportAlert(context: context),
                      child: const Text(
                        '신고하기',
                        style: recommendMoreButtonStyle,
                      ),
                    ),
                  ],
                  if (widget.targetUserId == _userId) ...[
                    InkWell(
                      onTap: () => _showMyRecommendFeedDeleteAlert(context),
                      child: const Text(
                        '삭제하기',
                        style: recommendMoreButtonStyle,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showMyRecommendFeedDeleteAlert(BuildContext context) {
    return commonShowConfirmOrCancelDialog(
      context: context,
      title: '삭제',
      content: '해당 마이 추천 피드를\n삭제 하시겠습니까?',
      cancelButtonText: '취소',
      cancelButtonOnTap: () {
        Navigator.of(context).pop();
      },
      confirmButtonText: '삭제하기',
      confirmButtonOnTap: () {
        ref.watch(myRecommendProvider.notifier).deleteRecommendFeed(
              context: context,
              userId: _userId,
              recommendationFeedId: widget.recommendationFeedId,
              afterSuccessDelete: () {
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pop(context);
                  ref
                      .refresh(myRecommendProvider.notifier)
                      .getRecommendFeedList(
                        userId: _userId,
                      );
                  ref
                      .refresh(recommendProvider.notifier)
                      .getMyRecommendPostList(userId: _userId);
                });
              },
            );
      },
      confirmButtonColor: commonRedColor,
      confirmButtonTextColor: commonWhiteColor,
    );
  }

  Future<dynamic> _showUserReportAlert({
    required BuildContext context,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: commonBlackColor.withOpacity(0.2),
      builder: (context) {
        _tapReasonIndex = 0;
        _tapReportReason = userReportReason[_tapReasonIndex];

        return AlertDialog(
          title: Text(
            '신고하기',
            style: commonSubBoldStyle.copyWith(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Column(
                      children: userReportReason.mapIndexed(
                        (index, reason) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _tapReasonIndex = index;
                                _tapReportReason = reason;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    reason,
                                    style: recommendBookSubStyle.copyWith(
                                      color: grey262626,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Icon(
                                    _tapReasonIndex == index
                                        ? Icons.radio_button_checked_rounded
                                        : Icons.radio_button_off_rounded,
                                    color: _tapReasonIndex == index
                                        ? grey262626
                                        : greyDDDDDD,
                                    size: 20.0,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    if (_tapReasonIndex == userReportReason.length - 1)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _reportInputBox(context),
                      ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _reasonContentController.text = '';
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: greyF4F4F4,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: const Text(
                        '취소',
                        style: commonSubMediumStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_tapReasonIndex == userReportReason.length - 1) {
                        if (_reasonContentController.text.isEmpty) {
                          showCommonSnackBarMessage(
                            context: context,
                            snackBarText: '신고 사유를 입력해주세요.',
                          );
                          return;
                        }
                        _tapReportReason = _reasonContentController.text;
                      }

                      ref.watch(userReportProvider.notifier).createUserReport(
                            context: context,
                            userId: _userId,
                            body: UserReportModel(
                              reportedUserId: widget.targetUserId,
                              reportReason: _tapReportReason,
                            ),
                          );
                    },
                    child: Container(
                      color: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: Text(
                        '등록',
                        style: commonSubMediumStyle.copyWith(
                          color: commonWhiteColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          actionsPadding: const EdgeInsets.only(top: 8.0),
        );
      },
    );
  }

  TextFormField _reportInputBox(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      maxLength: 30,
      cursorColor: primaryColor,
      textInputAction: TextInputAction.done,
      style: recommendEditStyle.copyWith(
        color: grey262626,
        fontSize: 14.0,
      ),
      controller: _reasonContentController,
      onEditingComplete: () {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        constraints: const BoxConstraints(
          minHeight: 18.0,
        ),
        contentPadding: const EdgeInsets.all(16.0),
        hintText: '신고 사유를 입력해주세요.',
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
    );
  }
}
