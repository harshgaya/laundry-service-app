import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/driver/pages/profile/driver_profile.dart';
import 'package:laundry_service/modules/driver/widgets/task_count_widget.dart';

class HomeTaskNumberPage extends StatelessWidget {
  const HomeTaskNumberPage({super.key});

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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Login Time :${DateFormat.jm().format(DateTime.now())}',
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),
                //     ),
                //     InkWell(
                //       onTap: () {
                //         Get.to(() => DriverProfile());
                //       },
                //       child: Row(
                //         children: [
                //           Text(
                //             'Nima',
                //             style: TextStyle(
                //               fontSize: 18,
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           const SizedBox(
                //             width: 5,
                //           ),
                //           CircleAvatar(
                //             backgroundColor: Colors.black,
                //             child: Text(
                //               'N',
                //               style: TextStyle(
                //                 color: Colors.white,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                const Center(
                  child: Text(
                    'To Do List',
                    style: TextStyle(
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
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TaskCountWidget(title: 'Overdue', count: '200'),
                  TaskCountWidget(title: 'To Do', count: '81'),
                  TaskCountWidget(title: 'Open', count: '5'),
                  TaskCountWidget(title: 'Overdue', count: '50'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
