import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/model/profile/user_report_model.dart';
import 'package:mybrary/data/provider/profile/user_report_provider.dart';
import 'package:mybrary/data/provider/recommend/my_recommend_provider.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/data/repository/book_repository.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/config.dart';
import 'package:mybrary/res/constants/enum.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/mybook/interest_book_list/interest_book_list_screen.dart';
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
  final _bookRepository = BookRepository();

  late bool _showMoreButton = false;

  bool onTapInterestBook = false;
  late bool _newInterested;
  late int _newInterestCount;

  final _userId = UserState.userId;

  @override
  void initState() {
    super.initState();

    _newInterested = widget.interested;
    _newInterestCount = widget.interestCount;
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
                                userCount: _newInterestCount,
                                type: SearchDetailUserInfosType.interest,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text.rich(
                            TextSpan(
                              text: _newInterestCount.toString(),
                              style: recommendFeedHeaderStyle.copyWith(
                                color: primaryColor,
                              ),
                              children: const [
                                TextSpan(
                                  text: ' 명의 픽',
                                  style: recommendFeedHeaderStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final result =
                              await _bookRepository.createOrDeleteInterestBook(
                            context: context,
                            userId: _userId,
                            isbn13: widget.isbn13,
                          );

                          setState(() {
                            onTapInterestBook = result.interested!;

                            _isInterestBook(
                              _newInterested,
                              _newInterestCount,
                              context,
                            );
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 6.0,
                            right: 4.0,
                          ),
                          child: SvgPicture.asset(
                              'assets/svg/icon/small/${_newInterested ? 'heart_green' : 'heart'}.svg'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showMoreButton = !_showMoreButton;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 6.0,
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
            right: 32,
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
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierColor: commonBlackColor.withOpacity(0.2),
                          builder: (context) {
                            int tapReasonIndex = 0;
                            String tapReportReason =
                                userReportReason[tapReasonIndex];

                            return AlertDialog(
                              title: Text(
                                '신고하기',
                                style: commonSubBoldStyle.copyWith(
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Wrap(
                                    alignment: WrapAlignment.center,
                                    children: userReportReason.mapIndexed(
                                      (index, reason) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              tapReasonIndex = index;
                                              tapReportReason = reason;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 8.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  reason,
                                                  style: recommendBookSubStyle
                                                      .copyWith(
                                                    color: grey262626,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Icon(
                                                  tapReasonIndex == index
                                                      ? Icons
                                                          .radio_button_checked_rounded
                                                      : Icons
                                                          .radio_button_off_rounded,
                                                  color: tapReasonIndex == index
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
                                  );
                                },
                              ),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
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
                                          ref
                                              .watch(
                                                  userReportProvider.notifier)
                                              .createUserReport(
                                                context: context,
                                                userId: _userId,
                                                body: UserReportModel(
                                                  reportedUserId:
                                                      widget.targetUserId,
                                                  reportedReason:
                                                      tapReportReason,
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
                                            style:
                                                commonSubMediumStyle.copyWith(
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
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              actionsPadding: const EdgeInsets.only(top: 8.0),
                            );
                          },
                        );
                      },
                      child: const Text(
                        '신고하기',
                        style: recommendMoreButtonStyle,
                      ),
                    ),
                  ],
                  if (widget.targetUserId == _userId) ...[
                    InkWell(
                      onTap: () {
                        commonShowConfirmOrCancelDialog(
                          context: context,
                          title: '삭제',
                          content: '해당 마이 추천 피드를\n삭제 하시겠습니까?',
                          cancelButtonText: '취소',
                          cancelButtonOnTap: () {
                            Navigator.of(context).pop();
                          },
                          confirmButtonText: '삭제하기',
                          confirmButtonOnTap: () {
                            ref
                                .watch(myRecommendProvider.notifier)
                                .deleteRecommendFeed(
                                  context: context,
                                  userId: _userId,
                                  recommendationFeedId:
                                      widget.recommendationFeedId,
                                  afterSuccessDelete: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      Navigator.pop(context);
                                      ref
                                          .refresh(myRecommendProvider.notifier)
                                          .getRecommendFeedList(
                                            userId: _userId,
                                          );
                                    });
                                  },
                                );
                          },
                          confirmButtonColor: commonRedColor,
                          confirmButtonTextColor: commonWhiteColor,
                        );
                      },
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

  void _isInterestBook(
    bool interested,
    int interestCount,
    BuildContext context,
  ) {
    if (!interested && onTapInterestBook) {
      _newInterested = true;
      _newInterestCount = interestCount + 1;
      showCommonSnackBarMessage(
        context: context,
        snackBarText: '관심 도서에 담겼습니다.',
        snackBarAction: _moveNextToInterestBookListScreen(),
      );
    } else if (interested && onTapInterestBook == false) {
      _newInterested = false;
      _newInterestCount = interestCount - 1;
      showCommonSnackBarMessage(
        context: context,
        snackBarText: '관심 도서가 삭제되었습니다.',
      );
    } else if (interested && onTapInterestBook) {
      _newInterested = true;
      _newInterestCount = interestCount;
      showCommonSnackBarMessage(
        context: context,
        snackBarText: '관심 도서에 담겼습니다.',
        snackBarAction: _moveNextToInterestBookListScreen(),
      );
    } else {
      _newInterested = false;
      _newInterestCount = interestCount;
      showCommonSnackBarMessage(
        context: context,
        snackBarText: '관심 도서가 삭제되었습니다.',
      );
    }
  }

  Widget _moveNextToInterestBookListScreen() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const InterestBookListScreen(),
          ),
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: const Text(
        '관심북으로 이동',
        style: commonSnackBarButtonStyle,
      ),
    );
  }
}
