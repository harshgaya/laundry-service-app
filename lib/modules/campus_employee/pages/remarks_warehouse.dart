import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/view_remarks_from_warehouse.dart';
import 'package:laundry_service/modules/campus_employee/pages/warehouse_remarks_details.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class RemarksWarehouse extends StatefulWidget {
  const RemarksWarehouse({super.key});

  @override
  State<RemarksWarehouse> createState() => _RemarksWarehouseState();
}

class _RemarksWarehouseState extends State<RemarksWarehouse> {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IconButton(
          //   onPressed: () {
          //     Get.back();
          //   },
          //   icon: CircleAvatar(
          //     backgroundColor: Colors.blue,
          //     child: Center(
          //       child: Icon(
          //         Icons.arrow_back_ios_new,
          //         color: Colors.white,
          //         size: 16,
          //       ),
          //     ),
          //   ),
          // ),
          const Text(
            'View Remarks',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
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
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Collection Id',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Delivery',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Remarks',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
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
                                  Get.to(() => WarehouseRemarksDetails());
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    order.value.collectionId.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '${order.value.deliveryTime}',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: !order.value.remarks.isEmpty
                                    ? Icon(Icons.done)
                                    : SizedBox(),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              )),
          // InkWell(
          //     onTap: () {
          //       Get.to(() => ViewRemarksFromWarehouse());
          //     },
          //     child:
          //         WhiteContainer(widget: Text('View Remarks\nFrom Warehouse'))),
          // WhiteContainer(widget: Text('Add Remarks')),
          // WhiteContainer(widget: Text('Untaken Cloths')),
        ],
      ),
    );
  }
}
