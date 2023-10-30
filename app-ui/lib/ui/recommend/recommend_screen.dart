import 'package:flutter/material.dart';
import 'package:mybrary/ui/common/layout/default_layout.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Container(
        child: Text('추천 화면입니다.'),
      ),
    );
  }
}
