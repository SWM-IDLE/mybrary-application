import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  final ScrollController _recommendScrollController = ScrollController();
  late bool _initAppBarIsVisible = false;

  @override
  void initState() {
    super.initState();

    _recommendScrollController.addListener(_changeAppBarComponent);
  }

  void _changeAppBarComponent() {
    setState(() {
      if (_recommendScrollController.offset > 10) {
        _initAppBarIsVisible = true;
      } else {
        _initAppBarIsVisible = false;
      }
    });
  }

  @override
  void dispose() {
    _recommendScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: CustomScrollView(
        controller: _recommendScrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          _recommendAppBar(),
          SliverToBoxAdapter(
            child: Text('추천 화면입니다.'),
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: MediaQuery.of(context).size.height * 1.5,
          )),
        ],
      ),
    );
  }

  SliverAppBar _recommendAppBar() {
    return SliverAppBar(
      toolbarHeight: 70.0,
      backgroundColor: commonWhiteColor,
      elevation: _initAppBarIsVisible ? 0.5 : 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SvgPicture.asset('assets/svg/icon/mybrary_black.svg'),
      ),
      pinned: true,
      centerTitle: false,
      titleTextStyle: appBarTitleStyle,
      foregroundColor: commonBlackColor,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/svg/icon/add_button.svg'),
          ),
        ),
      ],
    );
  }
}
