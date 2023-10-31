import 'package:flutter/material.dart';
import 'package:mybrary/data/model/book/mybooks_response.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/subpage_layout.dart';
import 'package:mybrary/ui/mybook/mybook_list/mybook_list_screen.dart';

class MyRecommendScreen extends StatefulWidget {
  const MyRecommendScreen({super.key});

  @override
  State<MyRecommendScreen> createState() => _MyRecommendScreenState();
}

class _MyRecommendScreenState extends State<MyRecommendScreen> {
  final _userId = UserState.userId;

  late int _bookId;
  late String _thumbnailUrl;
  late String _bookTitle;
  late String _bookAuthor;

  @override
  void initState() {
    super.initState();

    _bookId = 0;
    _thumbnailUrl = '';
    _bookTitle = '';
    _bookAuthor = '';
  }

  @override
  Widget build(BuildContext context) {
    return SubPageLayout(
      appBarTitle: '마이 추천',
      appBarActions: [
        TextButton(
          onPressed: () async {},
          style: disableAnimationButtonStyle,
          child: const Text(
            '저장',
            style: saveTextButtonStyle,
          ),
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            if (_thumbnailUrl == '') {
                              await _addMyBookToMyRecommend(context);
                            }
                          },
                          child: Hero(
                            tag: _bookId,
                            child: Container(
                              width: 100,
                              height: 150,
                              decoration: BoxDecoration(
                                color: greyF4F4F4,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                image: _thumbnailUrl == ''
                                    ? null
                                    : DecorationImage(
                                        image: NetworkImage(
                                          _thumbnailUrl,
                                        ),
                                        onError: (exception, stackTrace) =>
                                            Image.asset(
                                          'assets/img/logo/mybrary.png',
                                          fit: BoxFit.fill,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                boxShadow: _thumbnailUrl == ''
                                    ? null
                                    : [
                                        const BoxShadow(
                                          color: Color(0x33000000),
                                          blurRadius: 10,
                                          offset: Offset(4, 4),
                                          spreadRadius: 0,
                                        ),
                                      ],
                              ),
                              child: Center(
                                child: Text(
                                  _thumbnailUrl == '' ? '+ 책 추가' : '',
                                  style: recommendBookSubStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        if (_thumbnailUrl != '')
                          InkWell(
                            onTap: () async {
                              await _addMyBookToMyRecommend(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 2.0,
                              ),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: grey262626,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              child: const Text(
                                '책 변경하기',
                                style: recommendBookEditStyle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 32.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12.0),
                          Text(
                            _bookTitle == '' ? '책 제목' : _bookTitle,
                            style: recommendBookTitleStyle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            _bookAuthor == ''
                                ? '마이북을 추가하여\n추천 피드를 작성해 보세요.'
                                : _bookAuthor,
                            style: recommendBookSubStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addMyBookToMyRecommend(BuildContext context) async {
    MyBooksResponseData? book = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyBookListScreen(
          bookListTitle: '책 추가',
          order: 'registration',
          readStatus: '',
          userId: _userId,
          isNotMyBook: true,
          onTapBookComponent: (book) {
            Navigator.pop(context, book);
          },
        ),
      ),
    );

    if (book != null) {
      setState(() {
        _bookId = book.id!;
        _thumbnailUrl = book.book!.thumbnailUrl!;
        _bookTitle = book.book!.title!;
        _bookAuthor = book.book!.authors!;
      });
    }
  }
}
