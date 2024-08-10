import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import 'package:laundry_service/modules/washing/pages/washing_details_page.dart';

class ToDoListWashing extends StatefulWidget {
  const ToDoListWashing({super.key});

  @override
  State<ToDoListWashing> createState() => _ToDoListWashingState();
}

class _ToDoListWashingState extends State<ToDoListWashing> {
  final washingController = Get.put(WashingController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'To Do List',
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
                border: const TableBorder(
                    horizontalInside:
                        BorderSide(color: Colors.black, width: 0.2)),
                children: [
                  // Table header
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Collection No',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Campus Name',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Table rows from the orders list
                  ...washingController.washingTasks
                      .asMap()
                      .entries
                      .map((order) {
                    return TableRow(
                      children: [
                        TableCell(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => WashingDetailsPage());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${order.value.collectionNo}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => WashingDetailsPage());
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '${order.value.campusName}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
