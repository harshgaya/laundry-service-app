import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../driver/controllers/driver_controller.dart';

class DryingHistory extends StatefulWidget {
  const DryingHistory({super.key});

  @override
  State<DryingHistory> createState() => _DryingHistoryState();
}

class _DryingHistoryState extends State<DryingHistory> {
  final driverController = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Drying History',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder(
                      horizontalInside:
                          BorderSide(color: Colors.black, width: 0.2)),
                  children: [
                    // Table header
                    TableRow(
                      children: [
                        TableCell(
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Collection Id'.toUpperCase(),
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
                                'Time'.toUpperCase(),
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
                                'Dried'.toUpperCase(),
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
                    ...driverController.driverHistoryList
                        .asMap()
                        .entries
                        .map((order) {
                      return TableRow(
                        children: [
                          TableCell(
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  order.value.collectionId,
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
                                  '${order.value.time}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: order.value.isDelivered
                                ? Center(child: Icon(Icons.done))
                                : SizedBox(),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
