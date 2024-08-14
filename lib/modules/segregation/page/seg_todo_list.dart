import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/segregation/controler/seg_controller.dart';
import 'package:laundry_service/modules/segregation/page/profile/seg_profile.dart';
import 'package:laundry_service/modules/segregation/page/seg_to_do_details.dart';

import '../../driver/widgets/task_count_widget.dart';
import '../../driver/widgets/task_tile_widget.dart';

class SegToDoList extends StatefulWidget {
  const SegToDoList({super.key});

  @override
  State<SegToDoList> createState() => _SegToDoListState();
}

class _SegToDoListState extends State<SegToDoList> {
  final segController = Get.put(SegController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
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
        ),
        const SizedBox(
          height: 50,
        ),
        TaskTileWidget(
          function: () {
            Get.to(() => const SegToDoDetails());
          },
        ),
      ],
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Text('Login Time :${DateFormat.jm().format(DateTime.now())}'),
    //           InkWell(
    //             onTap: () {
    //               Get.to(() => SegProfile());
    //             },
    //             child: const Row(
    //               children: [
    //                 Text(
    //                   'Nima',
    //                   style: TextStyle(
    //                     fontSize: 18,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   width: 5,
    //                 ),
    //                 CircleAvatar(
    //                   backgroundColor: Colors.black,
    //                   child: Text(
    //                     'N',
    //                     style: TextStyle(color: Colors.white),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //       const SizedBox(
    //         height: 20,
    //       ),
    //       Expanded(
    //         child: SingleChildScrollView(
    //           child: Table(
    //             border: const TableBorder(
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
    //                         'Collection No',
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
    //                         'Campus Name',
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
    //               ...segController.dryingTask.asMap().entries.map((order) {
    //                 return TableRow(
    //                   children: [
    //                     TableCell(
    //                       child: InkWell(
    //                         onTap: () {
    //                           Get.to(() => SegToDoDetails());
    //                         },
    //                         child: Container(
    //                           padding: const EdgeInsets.all(8),
    //                           child: Text(
    //                             '${order.value.collectionNo}',
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
    //                           Get.to(() => SegToDoDetails());
    //                         },
    //                         child: Container(
    //                           padding: EdgeInsets.all(8),
    //                           child: Text(
    //                             '${order.value.campusName}',
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
