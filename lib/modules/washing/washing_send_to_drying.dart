import 'package:flutter/material.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class WashingSendToDrying extends StatefulWidget {
  const WashingSendToDrying({super.key});

  @override
  State<WashingSendToDrying> createState() => _WashingSendToDryingState();
}

class _WashingSendToDryingState extends State<WashingSendToDrying> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            WhiteContainer(
              widget: Text('Sri Chaitnya'),
            ),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(
              widget: Text('${DateTime.now()}'),
            ),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(
              widget: Text('Collection No-1'),
            ),
            WhiteContainer(widget: widget),
          ],
        ),
      ),
    );
  }
}
