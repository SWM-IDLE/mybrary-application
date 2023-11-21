import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/data/provider/user_provider.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';
import 'package:mybrary/ui/search/components/search_popular_keyword.dart';
import 'package:mybrary/ui/search/search_book_list/search_book_list.dart';
import 'package:mybrary/utils/logics/permission_utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late bool _isClearButtonVisible = false;

  final TextEditingController _bookSearchKeywordController =
      TextEditingController();

  List<String> _recentSearchKeywordList = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: commonLessGreyColor.withOpacity(0.2),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _loadRecentSearchKeywordList();
    _bookSearchKeywordController.addListener(_isClearText);
  }

  void _isClearText() {
    if (_bookSearchKeywordController.text.isEmpty) {
      _isClearButtonVisible = false;
    }
  }

  void _loadRecentSearchKeywordList() {
    setState(() {
      _recentSearchKeywordList = UserState.recentSearchKeywordList;
    });
  }

  void _saveRecentSearchKeywordList(String keyword) {
    _recentSearchKeywordList.insert(0, keyword);
    UserState.localStorage
        .setStringList('recentSearchKeywordList', _recentSearchKeywordList);
  }

  @override
  void dispose() {
    _bookSearchKeywordController.clear();
    _bookSearchKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: DefaultLayout(
          appBar: AppBar(
            toolbarHeight: 60.0,
            backgroundColor: commonWhiteColor,
            elevation: 0,
            title: const Text('검색'),
            titleTextStyle: commonSubTitleStyle.copyWith(
              color: commonBlackColor,
            ),
            centerTitle: true,
            foregroundColor: commonBlackColor,
            actions: [
              IconButton(
                onPressed: () => checkScanPermission(context),
                icon: SvgPicture.asset('assets/svg/icon/barcode_scan.svg'),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 0.0,
                          left: 18.0,
                          bottom: 12.0,
                          right: 18.0,
                        ),
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          controller: _bookSearchKeywordController,
                          cursorColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _isClearButtonVisible = value.isNotEmpty;
                            });
                          },
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SearchBookList(
                                    searchKeyword: value,
                                  ),
                                ),
                              ).then(
                                (value) => {
                                  setState(() {
                                    _bookSearchKeywordController.clear();
                                    _isClearButtonVisible = false;
                                  })
                                },
                              );

                              _saveRecentSearchKeywordList(value);
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                            ),
                            hintText: '책, 저자, 회원을 검색해보세요.',
                            hintStyle: commonSubRegularStyle,
                            filled: true,
                            fillColor: commonGreyOpacityColor,
                            focusedBorder: searchInputBorderStyle,
                            enabledBorder: searchInputBorderStyle,
                            focusColor: commonGreyColor,
                            prefixIcon: SvgPicture.asset(
                              'assets/svg/icon/search_small.svg',
                              fit: BoxFit.scaleDown,
                            ),
                            suffixIcon: _searchInputClearIcon(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      _recentSearchKeywordComponent(context),
                      const SizedBox(height: 24.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SearchPopularKeyword(
                          bookSearchKeywordController:
                              _bookSearchKeywordController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _recentSearchKeywordComponent(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '최근 검색어',
                  style: commonSubBoldStyle.copyWith(
                    fontSize: 16.0,
                  ),
                ),
                if (_recentSearchKeywordList.isNotEmpty)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _recentSearchKeywordList.clear();
                        UserState.localStorage
                            .setStringList('recentSearchKeywordList', []);
                      });
                    },
                    child: Text(
                      '전체 기록 지우기',
                      style: recentKeywordTextStyle.copyWith(
                        fontSize: 13.0,
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(height: 16.0),
            if (_recentSearchKeywordList.isEmpty)
              const Text(
                '최근 검색어가 없습니다.',
                style: recentKeywordTextStyle,
              )
            else
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(
                  _recentSearchKeywordList.length,
                  (index) => Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: circularGreenColor,
                          border: Border.all(
                            color: circularGreenColor,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Wrap(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SearchBookList(
                                      searchKeyword:
                                          _recentSearchKeywordList[index],
                                    ),
                                  ),
                                ).then(
                                  (value) => {
                                    setState(() {
                                      _bookSearchKeywordController.clear();
                                      _isClearButtonVisible = false;
                                    })
                                  },
                                );
                              },
                              child: Text(
                                _recentSearchKeywordList[index],
                                style: popularKeywordTextStyle.copyWith(
                                  color: primaryColor,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _recentSearchKeywordList.removeAt(index);
                                UserState.localStorage.setStringList(
                                    'recentSearchKeywordList',
                                    _recentSearchKeywordList);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                bottom: 2.0,
                              ),
                              child: SvgPicture.asset(
                                'assets/svg/icon/clear.svg',
                                width: 8.0,
                                height: 8.0,
                                colorFilter: const ColorFilter.mode(
                                  primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
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

  IconButton? _searchInputClearIcon() {
    return _isClearButtonVisible
        ? IconButton(
            onPressed: () {
              setState(() {
                _bookSearchKeywordController.text = '';
                _isClearButtonVisible = false;
              });
            },
            icon: const Icon(
              Icons.cancel_rounded,
              color: grey777777,
              size: 18.0,
            ),
          )
        : null;
  }
}
