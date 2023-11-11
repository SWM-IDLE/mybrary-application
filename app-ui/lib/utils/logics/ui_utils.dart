import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';

double mediaQueryHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double mediaQueryWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double bottomInset(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}

final bool isAndroid = Platform.isAndroid;
final bool isIOS = Platform.isIOS;

CircularProgressIndicator commonLoadingIndicator() {
  return CircularProgressIndicator(
    backgroundColor: primaryColor.withOpacity(0.2),
    valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
  );
}
