import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';
import 'package:mybrary/res/constants/style.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  const ErrorPage({
    required this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info,
            size: 78.0,
            color: grey777777,
          ),
          const SizedBox(height: 8.0),
          Text(
            errorMessage,
            style: commonSubMediumStyle.copyWith(
              color: grey777777,
            ),
          ),
          const SizedBox(height: 100.0),
        ],
      ),
    );
  }
}
