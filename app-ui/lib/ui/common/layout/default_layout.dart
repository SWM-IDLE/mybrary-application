import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;

  final Color? backgroundColor;
  final AppBar? appBar;
  final Widget? bottomNavigationBar;
  final bool? extendBodyBehindAppBar;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.appBar,
    this.extendBodyBehindAppBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? commonWhiteColor,
      appBar: appBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
