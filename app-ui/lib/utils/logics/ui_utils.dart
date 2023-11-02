import 'dart:io';

import 'package:flutter/material.dart';

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
