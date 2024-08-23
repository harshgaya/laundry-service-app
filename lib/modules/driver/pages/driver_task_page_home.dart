import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/driver/controllers/driver_controller.dart';
import 'package:laundry_service/modules/driver/pages/to_do_list_view_driver.dart';
import 'package:laundry_service/modules/driver/widgets/home_task_number_page.dart';
import 'package:laundry_service/modules/driver/widgets/task_count_widget.dart';
import 'package:laundry_service/modules/driver/widgets/task_tile_widget.dart';

class DriverTaskPageHome extends StatefulWidget {
  const DriverTaskPageHome({super.key});

  @override
  State<DriverTaskPageHome> createState() => _DriverTaskPageHomeState();
}

class _DriverTaskPageHomeState extends State<DriverTaskPageHome> {
  final driverController = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeTaskNumberPage(),
        const SizedBox(
          height: 50,
        ),
        TaskTileWidget(
          color1: Colors.red,
          title1: 'Asset',
          title2: 'In progress',
          title3: 'Collection No-1',
          title4: 'Sri Chaitnya',
          icon: Icons.bookmark,
          color2: Colors.green,
          function: () {
            Get.to(() => const ToDoListViewDriver());
          },
        ),
      ],
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Text(
    //         'To Do List',
    //         style: TextStyle(
    //           fontSize: 25,
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 20,
    //       ),
    //       Expanded(
    //         child: SingleChildScrollView(
    //           child: Table(
    //             border: TableBorder(
    //                 horizontalInside:
    //                     BorderSide(color: Colors.black, width: 0.2)),
    //             children: [
    //               // Table header
    //               TableRow(
    //                 children: [
    //                   TableCell(
    //                     child: Container(
    //                       padding: EdgeInsets.all(8),
    //                       child: Text(
    //                         'S.NO.',
    //                         style: TextStyle(
    //                           fontSize: 14,
    //                           color: Colors.blue,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   TableCell(
    //                     child: Container(
    //                       padding: EdgeInsets.all(8),
    //                       child: Text(
    //                         'College Name',
    //                         style: TextStyle(
    //                           fontSize: 14,
    //                           color: Colors.blue,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   TableCell(
    //                     child: Container(
    //                       padding: EdgeInsets.all(8),
    //                       child: Text(
    //                         'Task',
    //                         style: TextStyle(
    //                           fontSize: 14,
    //                           color: Colors.blue,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               // Table rows from the orders list
    //               ...driverController.driverToDoList
    //                   .asMap()
    //                   .entries
    //                   .map((order) {
    //                 return TableRow(
    //                   children: [
    //                     TableCell(
    //                       child: InkWell(
    //                         onTap: () {
    //                           Get.to(() => ToDoListViewDriver());
    //                         },
    //                         child: Container(
    //                           padding: EdgeInsets.all(8),
    //                           child: Text(
    //                             '${order.key + 1}',
    //                             style: TextStyle(
    //                               fontSize: 12,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     TableCell(
    //                       child: InkWell(
    //                         onTap: () {
    //                           Get.to(() => ToDoListViewDriver());
    //                         },
    //                         child: Container(
    //                           padding: EdgeInsets.all(8),
    //                           child: Text(
    //                             '${order.value.collegeName}',
    //                             style: TextStyle(
    //                               fontSize: 12,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     TableCell(
    //                       child: InkWell(
    //                         onTap: () {
    //                           Get.to(() => ToDoListViewDriver());
    //                         },
    //                         child: Container(
    //                           padding: EdgeInsets.all(8),
    //                           child: Text(
    //                             '${order.value.task}',
    //                             style: TextStyle(
    //                               fontSize: 12,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 );
    //               }).toList(),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
