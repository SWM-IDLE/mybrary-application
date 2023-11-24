import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';

class SingleDataError extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String errorMessage;

  const SingleDataError({
    required this.errorMessage,
    this.icon,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.info,
            size: 78.0,
            color: iconColor ?? grey777777,
          ),
          const SizedBox(height: 8.0),
          Text(
            errorMessage,
            style: commonSubMediumStyle.copyWith(
              color: grey777777,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}
