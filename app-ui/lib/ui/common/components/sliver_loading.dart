import 'package:flutter/material.dart';
import 'package:mybrary/res/constants/color.dart';

class SliverLoading extends StatelessWidget {
  const SliverLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
