import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../driver/controllers/driver_controller.dart';
import '../../driver/widgets/task_count_widget.dart';
import '../../driver/widgets/task_tile_widget.dart';

class WashingHistoryPage extends StatefulWidget {
  const WashingHistoryPage({super.key});

  @override
  State<WashingHistoryPage> createState() => _WashingHistoryPageState();
}

class _WashingHistoryPageState extends State<WashingHistoryPage> {
  final driverController = Get.put(DriverController());
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
                        'Washing history',
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            width: Get.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Get.width - 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: Colors.grey,
                              ),
                              Text(
                                'Asset',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 10,
                                width: 10,
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('In Progress'),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Collection No-5',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Shri Chaitnya',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Text(
    //         'Delivery History',
    //         style: TextStyle(
    //           fontSize: 25,
    //           fontWeight: FontWeight.w700,
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 20,
    //       ),
    //       Obx(
    //         () => Expanded(
    //           child: SingleChildScrollView(
    //             child: Table(
    //               border: TableBorder(
    //                   horizontalInside:
    //                       BorderSide(color: Colors.black, width: 0.2)),
    //               children: [
    //                 // Table header
    //                 TableRow(
    //                   children: [
    //                     TableCell(
    //                       child: Center(
    //                         child: Container(
    //                           padding: EdgeInsets.all(8),
    //                           child: Text(
    //                             'Collection Id'.toUpperCase(),
    //                             style: TextStyle(
    //                               fontSize: 18,
    //                               color: Colors.blue,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     TableCell(
    //                       child: Center(
    //                         child: Container(
    //                           padding: EdgeInsets.all(8),
    //                           child: Text(
    //                             'Time'.toUpperCase(),
    //                             style: TextStyle(
    //                               fontSize: 18,
    //                               color: Colors.blue,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     TableCell(
    //                       child: Center(
    //                         child: Container(
    //                           padding: EdgeInsets.all(8),
    //                           child: Text(
    //                             'Washed'.toUpperCase(),
    //                             style: TextStyle(
    //                               fontSize: 18,
    //                               color: Colors.blue,
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 // Table rows from the orders list
    //                 ...driverController.driverHistoryList
    //                     .asMap()
    //                     .entries
    //                     .map((order) {
    //                   return TableRow(
    //                     children: [
    //                       TableCell(
    //                         child: Center(
    //                           child: Container(
    //                             padding: EdgeInsets.all(8),
    //                             child: Text(
    //                               order.value.collectionId,
    //                               style: TextStyle(
    //                                 fontSize: 16,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       TableCell(
    //                         child: Center(
    //                           child: Container(
    //                             padding: EdgeInsets.all(8),
    //                             child: Text(
    //                               '${order.value.time}',
    //                               style: TextStyle(
    //                                 fontSize: 16,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       TableCell(
    //                         child: order.value.isDelivered
    //                             ? Center(child: Icon(Icons.done))
    //                             : SizedBox(),
    //                       ),
    //                     ],
    //                   );
    //                 }).toList(),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 10,
    //       ),
    //     ],
    //   ),
    // );
  }
}
