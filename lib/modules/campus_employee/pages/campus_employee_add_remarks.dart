import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/pages/warehouse_remarks_details.dart';

import '../controllers/campus_employee_controller.dart';

class CampusEmployeeAddRemarks extends StatefulWidget {
  const CampusEmployeeAddRemarks({super.key});

  @override
  State<CampusEmployeeAddRemarks> createState() =>
      _CampusEmployeeAddRemarksState();
}

class _CampusEmployeeAddRemarksState extends State<CampusEmployeeAddRemarks> {
  final campusEmployeeController = Get.put(CampusEmployeeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    campusEmployeeController.warehouseRemarks.value = [
      RemarksWarehouseData(
          collectionId: 1, deliveryTime: '10-08-24', remarks: ''),
      RemarksWarehouseData(
          collectionId: 6, deliveryTime: '12-08-24', remarks: 'Not Proper'),
      RemarksWarehouseData(
          collectionId: 17, deliveryTime: '11-08-24', remarks: 'Torn'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'View Remarks',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Obx(() => Expanded(
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
                                    'ID',
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
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
                                    'DELIVERY',
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
                                    'REMARKS',
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
                        ...campusEmployeeController.warehouseRemarks
                            .asMap()
                            .entries
                            .map((order) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => WarehouseRemarksDetails(
                                          collectionId: '',
                                          tagId: '',
                                          campusId: '',
                                        ));
                                  },
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        order.value.collectionId.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => WarehouseRemarksDetails(
                                          collectionId: '',
                                          tagId: '',
                                          campusId: '',
                                        ));
                                  },
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${order.value.deliveryTime}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => WarehouseRemarksDetails(
                                          collectionId: '',
                                          tagId: '',
                                          campusId: '',
                                        ));
                                  },
                                  child: Container(
                                    child: !order.value.remarks.isEmpty
                                        ? Icon(Icons.done)
                                        : SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
