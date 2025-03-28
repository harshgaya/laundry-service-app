import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/driver/pages/profile/driver_profile.dart';
import 'package:laundry_service/modules/driver/widgets/task_count_widget.dart';

class HomeTaskNumberPage extends StatelessWidget {
  final int todo;
  final int open;
  final int finished;
  final int overdue;
  final String title;
  const HomeTaskNumberPage(
      {super.key,
      required this.todo,
      required this.open,
      required this.overdue,
      required this.finished,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 150,
          width: Get.width,
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          height: 70,
          bottom: -35,
          left: 10,
          right: 10,
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TaskCountWidget(title: 'To Do', count: '$todo'),
                  TaskCountWidget(title: 'Open', count: '$open'),
                  TaskCountWidget(title: 'Finished', count: '$finished'),
                  TaskCountWidget(title: 'Overdue', count: '$overdue'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
