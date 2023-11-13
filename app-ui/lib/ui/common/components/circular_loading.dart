import 'package:flutter/material.dart';
import 'package:mybrary/utils/logics/ui_utils.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Center(
        child: commonLoadingIndicator(),
      ),
    );
  }
}
