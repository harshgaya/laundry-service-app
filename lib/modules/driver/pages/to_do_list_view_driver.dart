import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';
import 'package:laundry_service/modules/driver/pages/pickup_drop_page_driver.dart';

class ToDoListViewDriver extends StatefulWidget {
  const ToDoListViewDriver({super.key});

  @override
  State<ToDoListViewDriver> createState() => _ToDoListViewDriverState();
}

class _ToDoListViewDriverState extends State<ToDoListViewDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('TO DO LIST VIEW'),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(widget: Text('Sri Chityana')),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(widget: Text('${DateTime.now().toString()}')),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(widget: Text('Collection No-1')),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  Get.to(() => PickUpDropPageDriver());
                },
                child: WhiteContainer(widget: Text('Pick Up'))),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(widget: Text('Drop')),
          ],
        ),
      ),
    );
  }
}
