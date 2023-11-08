import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/data/repository/book_repository.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/enum.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/mybook/interest_book_list/interest_book_list_screen.dart';
import 'package:mybrary/ui/search/search_detail_user_infos/search_detail_user_infos_screen.dart';
import 'package:mybrary/utils/logics/common_utils.dart';

class RecommendFeedHeader extends ConsumerStatefulWidget {
  final String isbn13;
  final String targetUserId;
  final String profileImageUrl;
  final String nickname;
  final int interestCount;
  final bool interested;

  const RecommendFeedHeader({
    required this.isbn13,
    required this.targetUserId,
    required this.profileImageUrl,
    required this.nickname,
    required this.interestCount,
    required this.interested,
    super.key,
  });

  @override
  ConsumerState<RecommendFeedHeader> createState() =>
      _RecommendFeedHeaderState();
}

class _RecommendFeedHeaderState extends ConsumerState<RecommendFeedHeader> {
  final _bookRepository = BookRepository();

  late bool _showReportButton = false;

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
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
                        right: 2.0,
                      ),
                      child: SvgPicture.asset(
                          'assets/svg/icon/small/${_newInterested ? 'heart_green' : 'heart'}.svg'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showReportButton = !_showReportButton;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 6.0,
                        right: 4.0,
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
          if (_showReportButton)
            Positioned(
              bottom: -6,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
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
                child: Text(
                  '신고하기',
                  style: commonSubMediumStyle.copyWith(
                    fontSize: 14.0,
                    height: 1.2,
                    letterSpacing: -1,
                  ),
                ),
              ),
            ),
        ],
      ),
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
