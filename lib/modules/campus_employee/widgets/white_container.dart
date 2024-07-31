import 'package:flutter/material.dart';

class WhiteContainer extends StatelessWidget {
  final Widget widget;
  const WhiteContainer({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Center(child: widget),
    );
  }
}
