import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';
import 'package:laundry_service/modules/driver/pages/pickup_drop_page2.dart';

class PickUpDropPageDriver extends StatefulWidget {
  const PickUpDropPageDriver({super.key});

  @override
  State<PickUpDropPageDriver> createState() => _PickUpDropPageDriverState();
}

class _PickUpDropPageDriverState extends State<PickUpDropPageDriver> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text('PickUp'),
            const SizedBox(
              height: 50,
            ),
            InkWell(
                onTap: () {
                  Get.to(() => PickUpDropPage2());
                },
                child: WhiteContainer(widget: Text('STUDENT CLOTHES'))),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(widget: Text('FACULY CLOTHES')),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(widget: Text('OTHER CLOTHES')),
          ],
        ),
      ),
    );
  }
}
