import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_compare_daysheet.dart';

import '../../driver/widgets/home_task_number_page.dart';
import '../../driver/widgets/task_count_widget.dart';
import '../../driver/widgets/task_tile_widget.dart';
import 'campus_employee_pending_delivery_collection_details.dart';

class CampusEmployeeOrderFromWarehouse extends StatefulWidget {
  const CampusEmployeeOrderFromWarehouse({super.key});

  @override
  State<CampusEmployeeOrderFromWarehouse> createState() =>
      _CampusEmployeeOrderFromWarehouseState();
}

class _CampusEmployeeOrderFromWarehouseState
    extends State<CampusEmployeeOrderFromWarehouse> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  int? id;
  String? dateCreated;
  bool? deliveryStatus;
  int? studentTagCount;
  int? facultyTagCount;
  DateTime? startDate;
  DateTime? endDate;
  bool showDate = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                        'History',
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
        InkWell(
          onTap: () {
            _selectDateRange(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.compare_arrows),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Filter By Date'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TaskTileWidget(
          function: () {
            setState(() {
              id = 1;
              dateCreated = '22-12-2024';
              deliveryStatus = true;
              studentTagCount = 10;
              facultyTagCount = 5;
            });
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 500,
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Collection Details',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Table(
                                border: TableBorder(
                                    horizontalInside: BorderSide(
                                        color: Colors.black, width: 0.2)),
                                children: [
                                  // Table header
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'Name'.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'Value',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Table rows from the orders list
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'ID',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              '${id}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'Created Date',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              '${dateCreated}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'Delivery Status',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: deliveryStatus == true
                                                  ? Text('Done')
                                                  : Text('Pending')),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'Student Tag Count',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              '${studentTagCount}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'Faculty Count',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              '${facultyTagCount}',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  if (deliveryStatus == true) {
                                    Get.to(
                                        () => CampusEmployeeCompareDaysheet());
                                  } else {
                                    Get.to(() =>
                                        CampusEmployeePendingDeliveryCollectionDetails());
                                  }
                                },
                                child: Text(
                                  deliveryStatus == true ? 'Next' : 'Check',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
        // Obx(() => Expanded(
        //       child: SingleChildScrollView(
        //         child: Table(
        //           border: TableBorder(
        //               horizontalInside:
        //                   BorderSide(color: Colors.black, width: 0.2)),
        //           children: [
        //             // Table header
        //             TableRow(
        //               children: [
        //                 TableCell(
        //                   child: Container(
        //                     padding: EdgeInsets.all(8),
        //                     child: Text(
        //                       'Id',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: Colors.blue,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 TableCell(
        //                   child: Container(
        //                     padding: EdgeInsets.all(8),
        //                     child: Text(
        //                       'Delivery',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: Colors.blue,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 TableCell(
        //                   child: Container(
        //                     padding: EdgeInsets.all(8),
        //                     child: Text(
        //                       'Delivered',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: Colors.blue,
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             // Table rows from the orders list
        //             ...campusEmployeeController
        //                 .campusEmployeeOrdersFromWarehouse
        //                 .asMap()
        //                 .entries
        //                 .map((order) {
        //               return TableRow(
        //                 children: [
        //                   TableCell(
        //                     child: InkWell(
        //                       onTap: () {
        //                         setState(() {
        //                           id = order.value.collectionNo;
        //                           dateCreated = order.value.deliveryDate;
        //                           deliveryStatus = order.value.delivered;
        //                           studentTagCount = order.value.tagCount;
        //                           facultyTagCount = order.value.facultyCount;
        //                         });
        //                         showModalBottomSheet(
        //                             context: context,
        //                             builder: (context) {
        //                               return SizedBox(
        //                                 height: 500,
        //                                 width: Get.width,
        //                                 child: Padding(
        //                                   padding: const EdgeInsets.all(8.0),
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.start,
        //                                     children: [
        //                                       const Text(
        //                                         'Collection Details',
        //                                         style: TextStyle(
        //                                           fontSize: 25,
        //                                           fontWeight: FontWeight.w700,
        //                                         ),
        //                                       ),
        //                                       const SizedBox(
        //                                         height: 20,
        //                                       ),
        //                                       Expanded(
        //                                         child: SingleChildScrollView(
        //                                           child: Table(
        //                                             border: TableBorder(
        //                                                 horizontalInside:
        //                                                     BorderSide(
        //                                                         color: Colors
        //                                                             .black,
        //                                                         width: 0.2)),
        //                                             children: [
        //                                               // Table header
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Name',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 16,
        //                                                           color: Colors
        //                                                               .blue,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Value',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 16,
        //                                                           color: Colors
        //                                                               .blue,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               // Table rows from the orders list
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'ID',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         '${id}',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Created Date',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         '${dateCreated}',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Delivery Status',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                         padding:
        //                                                             EdgeInsets
        //                                                                 .all(8),
        //                                                         child: deliveryStatus ==
        //                                                                 true
        //                                                             ? Text(
        //                                                                 'Done')
        //                                                             : Text(
        //                                                                 'Pending')),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Student Tag Count',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         '${studentTagCount}',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Faculty Count',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         '${facultyTagCount}',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         ),
        //                                       ),
        //                                       const SizedBox(
        //                                         height: 10,
        //                                       ),
        //                                       Align(
        //                                         alignment: Alignment.center,
        //                                         child: ElevatedButton(
        //                                             style: ElevatedButton
        //                                                 .styleFrom(
        //                                               backgroundColor:
        //                                                   Colors.blue,
        //                                             ),
        //                                             onPressed: () {
        //                                               if (deliveryStatus ==
        //                                                   true) {
        //                                                 Get.to(() =>
        //                                                     CampusEmployeeCompareDaysheet());
        //                                               } else {
        //                                                 Get.to(() =>
        //                                                     CampusEmployeePendingDeliveryCollectionDetails());
        //                                               }
        //                                             },
        //                                             child: Text(
        //                                               deliveryStatus == true
        //                                                   ? 'Next'
        //                                                   : 'Check',
        //                                               style: TextStyle(
        //                                                 color: Colors.white,
        //                                               ),
        //                                             )),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               );
        //                             });
        //                       },
        //                       child: Container(
        //                         padding: EdgeInsets.all(8),
        //                         child: Text(
        //                           order.value.collectionNo.toString(),
        //                           style: TextStyle(
        //                             fontSize: 12,
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                   TableCell(
        //                     child: InkWell(
        //                       onTap: () {
        //                         setState(() {
        //                           id = order.value.collectionNo;
        //                           dateCreated = order.value.deliveryDate;
        //                           deliveryStatus = order.value.delivered;
        //                           studentTagCount = order.value.tagCount;
        //                           facultyTagCount = order.value.facultyCount;
        //                         });
        //                         showModalBottomSheet(
        //                             context: context,
        //                             builder: (context) {
        //                               return SizedBox(
        //                                 height: 500,
        //                                 width: Get.width,
        //                                 child: Padding(
        //                                   padding: const EdgeInsets.all(8.0),
        //                                   child: Column(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.start,
        //                                     children: [
        //                                       const Text(
        //                                         'Collection Details',
        //                                         style: TextStyle(
        //                                           fontSize: 25,
        //                                           fontWeight: FontWeight.w700,
        //                                         ),
        //                                       ),
        //                                       const SizedBox(
        //                                         height: 20,
        //                                       ),
        //                                       Expanded(
        //                                         child: SingleChildScrollView(
        //                                           child: Table(
        //                                             border: TableBorder(
        //                                                 horizontalInside:
        //                                                     BorderSide(
        //                                                         color: Colors
        //                                                             .black,
        //                                                         width: 0.2)),
        //                                             children: [
        //                                               // Table header
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Name',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 16,
        //                                                           color: Colors
        //                                                               .blue,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Value',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 16,
        //                                                           color: Colors
        //                                                               .blue,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               // Table rows from the orders list
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'ID',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         '${id}',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Created Date',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         '${dateCreated}',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Delivery Status',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                         padding:
        //                                                             EdgeInsets
        //                                                                 .all(8),
        //                                                         child: deliveryStatus ==
        //                                                                 true
        //                                                             ? Text(
        //                                                                 'Done')
        //                                                             : Text(
        //                                                                 'Pending')),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Student Tag Count',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         '${studentTagCount}',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               TableRow(
        //                                                 children: [
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         'Faculty Count',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                   TableCell(
        //                                                     child: Container(
        //                                                       padding:
        //                                                           EdgeInsets
        //                                                               .all(8),
        //                                                       child: Text(
        //                                                         '${facultyTagCount}',
        //                                                         style:
        //                                                             TextStyle(
        //                                                           fontSize: 12,
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         ),
        //                                       ),
        //                                       const SizedBox(
        //                                         height: 10,
        //                                       ),
        //                                       Align(
        //                                         alignment: Alignment.center,
        //                                         child: ElevatedButton(
        //                                             style: ElevatedButton
        //                                                 .styleFrom(
        //                                               backgroundColor:
        //                                                   Colors.blue,
        //                                             ),
        //                                             onPressed: () {
        //                                               if (deliveryStatus ==
        //                                                   true) {
        //                                                 Get.to(() =>
        //                                                     CampusEmployeeCompareDaysheet());
        //                                               } else {
        //                                                 Get.to(() =>
        //                                                     CampusEmployeePendingDeliveryCollectionDetails());
        //                                               }
        //                                             },
        //                                             child: Text(
        //                                               deliveryStatus == true
        //                                                   ? 'Next'
        //                                                   : 'Check',
        //                                               style: TextStyle(
        //                                                 color: Colors.white,
        //                                               ),
        //                                             )),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ),
        //                               );
        //                             });
        //                       },
        //                       child: Container(
        //                         padding: EdgeInsets.all(8),
        //                         child: Text(
        //                           '${order.value.deliveryDate}',
        //                           style: TextStyle(
        //                             fontSize: 12,
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                   TableCell(
        //                     child: order.value.delivered
        //                         ? InkWell(
        //                             onTap: () {
        //                               setState(() {
        //                                 id = order.value.collectionNo;
        //                                 dateCreated = order.value.deliveryDate;
        //                                 deliveryStatus = order.value.delivered;
        //                                 studentTagCount = order.value.tagCount;
        //                                 facultyTagCount =
        //                                     order.value.facultyCount;
        //                               });
        //                               showModalBottomSheet(
        //                                   context: context,
        //                                   builder: (context) {
        //                                     return SizedBox(
        //                                       height: 500,
        //                                       width: Get.width,
        //                                       child: Padding(
        //                                         padding:
        //                                             const EdgeInsets.all(8.0),
        //                                         child: Column(
        //                                           crossAxisAlignment:
        //                                               CrossAxisAlignment.start,
        //                                           children: [
        //                                             const Text(
        //                                               'Collection Details',
        //                                               style: TextStyle(
        //                                                 fontSize: 25,
        //                                                 fontWeight:
        //                                                     FontWeight.w700,
        //                                               ),
        //                                             ),
        //                                             const SizedBox(
        //                                               height: 20,
        //                                             ),
        //                                             Expanded(
        //                                               child:
        //                                                   SingleChildScrollView(
        //                                                 child: Table(
        //                                                   border: TableBorder(
        //                                                       horizontalInside:
        //                                                           BorderSide(
        //                                                               color: Colors
        //                                                                   .black,
        //                                                               width:
        //                                                                   0.2)),
        //                                                   children: [
        //                                                     // Table header
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Name',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     16,
        //                                                                 color: Colors
        //                                                                     .blue,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Value',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     16,
        //                                                                 color: Colors
        //                                                                     .blue,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     // Table rows from the orders list
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'ID',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               '${id}',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Created Date',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               '${dateCreated}',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Delivery Status',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child: Container(
        //                                                               padding:
        //                                                                   EdgeInsets.all(
        //                                                                       8),
        //                                                               child: deliveryStatus ==
        //                                                                       true
        //                                                                   ? Text(
        //                                                                       'Done')
        //                                                                   : Text(
        //                                                                       'Pending')),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Student Tag Count',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               '${studentTagCount}',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Faculty Count',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               '${facultyTagCount}',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                   ],
        //                                                 ),
        //                                               ),
        //                                             ),
        //                                             const SizedBox(
        //                                               height: 10,
        //                                             ),
        //                                             Align(
        //                                               alignment:
        //                                                   Alignment.center,
        //                                               child: ElevatedButton(
        //                                                   style: ElevatedButton
        //                                                       .styleFrom(
        //                                                     backgroundColor:
        //                                                         Colors.blue,
        //                                                   ),
        //                                                   onPressed: () {
        //                                                     if (deliveryStatus ==
        //                                                         true) {
        //                                                       Get.to(() =>
        //                                                           CampusEmployeeCompareDaysheet());
        //                                                     } else {
        //                                                       Get.to(() =>
        //                                                           CampusEmployeePendingDeliveryCollectionDetails());
        //                                                     }
        //                                                   },
        //                                                   child: Text(
        //                                                     deliveryStatus ==
        //                                                             true
        //                                                         ? 'Next'
        //                                                         : 'Check',
        //                                                     style: TextStyle(
        //                                                       color:
        //                                                           Colors.white,
        //                                                     ),
        //                                                   )),
        //                                             ),
        //                                           ],
        //                                         ),
        //                                       ),
        //                                     );
        //                                   });
        //                             },
        //                             child: Icon(Icons.done))
        //                         : InkWell(
        //                             onTap: () {
        //                               setState(() {
        //                                 id = order.value.collectionNo;
        //                                 dateCreated = order.value.deliveryDate;
        //                                 deliveryStatus = order.value.delivered;
        //                                 studentTagCount = order.value.tagCount;
        //                                 facultyTagCount =
        //                                     order.value.facultyCount;
        //                               });
        //                               showModalBottomSheet(
        //                                   context: context,
        //                                   builder: (context) {
        //                                     return SizedBox(
        //                                       height: 500,
        //                                       width: Get.width,
        //                                       child: Padding(
        //                                         padding:
        //                                             const EdgeInsets.all(8.0),
        //                                         child: Column(
        //                                           crossAxisAlignment:
        //                                               CrossAxisAlignment.start,
        //                                           children: [
        //                                             const Text(
        //                                               'Collection Details',
        //                                               style: TextStyle(
        //                                                 fontSize: 25,
        //                                                 fontWeight:
        //                                                     FontWeight.w700,
        //                                               ),
        //                                             ),
        //                                             const SizedBox(
        //                                               height: 20,
        //                                             ),
        //                                             Expanded(
        //                                               child:
        //                                                   SingleChildScrollView(
        //                                                 child: Table(
        //                                                   border: TableBorder(
        //                                                       horizontalInside:
        //                                                           BorderSide(
        //                                                               color: Colors
        //                                                                   .black,
        //                                                               width:
        //                                                                   0.2)),
        //                                                   children: [
        //                                                     // Table header
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Name',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     16,
        //                                                                 color: Colors
        //                                                                     .blue,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Value',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     16,
        //                                                                 color: Colors
        //                                                                     .blue,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     // Table rows from the orders list
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'ID',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               '${id}',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Created Date',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               '${dateCreated}',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Delivery Status',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child: Container(
        //                                                               padding:
        //                                                                   EdgeInsets.all(
        //                                                                       8),
        //                                                               child: deliveryStatus ==
        //                                                                       true
        //                                                                   ? Text(
        //                                                                       'Done')
        //                                                                   : Text(
        //                                                                       'Pending')),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Student Tag Count',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               '${studentTagCount}',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     TableRow(
        //                                                       children: [
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               'Faculty Count',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                         TableCell(
        //                                                           child:
        //                                                               Container(
        //                                                             padding:
        //                                                                 EdgeInsets
        //                                                                     .all(8),
        //                                                             child: Text(
        //                                                               '${facultyTagCount}',
        //                                                               style:
        //                                                                   TextStyle(
        //                                                                 fontSize:
        //                                                                     12,
        //                                                               ),
        //                                                             ),
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                   ],
        //                                                 ),
        //                                               ),
        //                                             ),
        //                                             const SizedBox(
        //                                               height: 10,
        //                                             ),
        //                                             Align(
        //                                               alignment:
        //                                                   Alignment.center,
        //                                               child: ElevatedButton(
        //                                                   style: ElevatedButton
        //                                                       .styleFrom(
        //                                                     backgroundColor:
        //                                                         Colors.blue,
        //                                                   ),
        //                                                   onPressed: () {
        //                                                     if (deliveryStatus ==
        //                                                         true) {
        //                                                       Get.to(() =>
        //                                                           CampusEmployeeCompareDaysheet());
        //                                                     } else {
        //                                                       Get.to(() =>
        //                                                           CampusEmployeePendingDeliveryCollectionDetails());
        //                                                     }
        //                                                   },
        //                                                   child: Text(
        //                                                     deliveryStatus ==
        //                                                             true
        //                                                         ? 'Next'
        //                                                         : 'Check',
        //                                                     style: TextStyle(
        //                                                       color:
        //                                                           Colors.white,
        //                                                     ),
        //                                                   )),
        //                                             ),
        //                                           ],
        //                                         ),
        //                                       ),
        //                                     );
        //                                   });
        //                             },
        //                             child: SizedBox()),
        //                   ),
        //                 ],
        //               );
        //             }).toList(),
        //           ],
        //         ),
        //       ),
        //     )),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  _selectDateRange(context);
                },
                child: Text(
                  'Select Date Range',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        if (startDate != null && endDate != null)
          Text(
            'Selected Date Range: ${DateFormat.yMMMd().format(startDate!)} - ${DateFormat.yMMMd().format(endDate!)}',
            style: TextStyle(fontSize: 16),
          ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }
}
