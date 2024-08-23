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
  void initState() {
    // TODO: implement initState
    super.initState();
    campusEmployeeController.getEmployeeCollectionHistory();
  }

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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.compare_arrows),
                  SizedBox(
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
        Obx(() => campusEmployeeController
                .loadingEmployeeCollectionHistory.value
            ? const CircularProgressIndicator()
            : campusEmployeeController.employeeCollection.value == null
                ? const SizedBox()
                : Expanded(
                    child: ListView.builder(
                      itemCount: campusEmployeeController
                          .employeeCollection.value?.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskTileWidget(
                          color1: Colors.red,
                          title1: 'Asset',
                          title2: 'In progress',
                          title3:
                              'Collection No-${campusEmployeeController.employeeCollection.value?.data[index].id}',
                          title4: 'Sri Chaitnya',
                          icon: Icons.bookmark,
                          color2: Colors.green,
                          function: () {
                            List<CampusEmployeeStudentDaySheetCompareData>
                                studentData = campusEmployeeController
                                    .employeeCollection
                                    .value!
                                    .data[index]
                                    .studentDaySheet
                                    .map((e) =>
                                        CampusEmployeeStudentDaySheetCompareData(
                                            tagNo: e.tagNumber,
                                            campusCount: (e.campusUniforms +
                                                e.campusRegularCloths),
                                            warehouseCount:
                                                (e.wareHouseRegularCloths +
                                                    e.wareHouseUniform),
                                            delivered: e.delivered))
                                    .toList();
                            List<CampusEmployeeFacultyDaySheetCompareData>
                                facultyData = campusEmployeeController
                                    .employeeCollection
                                    .value!
                                    .data[index]
                                    .facultyDaySheet
                                    .map((e) =>
                                        CampusEmployeeFacultyDaySheetCompareData(
                                            facultyName: "",
                                            campusCount: e.regularCloths,
                                            warehouseCount:
                                                e.wareHouseRegularCloths,
                                            delivered: e.delivered))
                                    .toList();

                            setState(() {
                              id = campusEmployeeController
                                  .employeeCollection.value?.data[index].id;
                              dateCreated = DateFormat('dd-MM-yyyy hh:mm a')
                                  .format(DateTime.parse(
                                      campusEmployeeController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .studentDaySheet[0]
                                          .createdAt))
                                  .toString();
                              deliveryStatus = campusEmployeeController
                                  .employeeCollection
                                  .value
                                  ?.data[index]
                                  .studentDaySheet[0]
                                  .delivered;
                              studentTagCount = campusEmployeeController
                                      .employeeCollection
                                      .value
                                      ?.data[index]
                                      .studentDaySheet
                                      .fold(0, (previousValue, element) {
                                    return (previousValue ?? 0) +
                                        (element.campusRegularCloths) +
                                        (element.campusUniforms);
                                  }) ??
                                  0;
                              facultyTagCount = campusEmployeeController
                                  .employeeCollection
                                  .value
                                  ?.data[index]
                                  .facultyDaySheet
                                  .fold(0, (previousValue, element) {
                                return previousValue! + (element.regularCloths);
                              });
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                border: const TableBorder(
                                                    horizontalInside:
                                                        BorderSide(
                                                            color: Colors.black,
                                                            width: 0.2)),
                                                children: [
                                                  TableRow(
                                                    children: [
                                                      TableCell(
                                                        child: Center(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Text(
                                                              'Name'
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TableCell(
                                                        child: Center(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: const Text(
                                                              'Value',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    Colors.blue,
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: const Text(
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Text(
                                                              '$id',
                                                              style:
                                                                  const TextStyle(
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: const Text(
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Text(
                                                              '$dateCreated',
                                                              style:
                                                                  const TextStyle(
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: const Text(
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8),
                                                              child: deliveryStatus ==
                                                                      true
                                                                  ? const Text(
                                                                      'Done')
                                                                  : const Text(
                                                                      'Pending')),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  TableRow(
                                                    children: [
                                                      TableCell(
                                                        child: Center(
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: const Text(
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Text(
                                                              '$studentTagCount',
                                                              style:
                                                                  const TextStyle(
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: const Text(
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child: Text(
                                                              '$facultyTagCount',
                                                              style:
                                                                  const TextStyle(
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
                                                    Get.to(() =>
                                                        CampusEmployeeCompareDaysheet(
                                                          campusEmployeeStudentDaySheetCompareData:
                                                              studentData,
                                                          campusEmployeeFacultyDaySheetCompareData:
                                                              facultyData,
                                                        ));
                                                  } else {
                                                    Get.to(() =>
                                                        const CampusEmployeePendingDeliveryCollectionDetails());
                                                  }
                                                },
                                                child: Text(
                                                  deliveryStatus == true
                                                      ? 'Next'
                                                      : 'Check',
                                                  style: const TextStyle(
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
                        );
                      },
                    ),
                  )),
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
                child: const Text(
                  'Select Date Range',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (startDate != null && endDate != null)
          Text(
            'Selected Date Range: ${DateFormat.yMMMd().format(startDate!)} - ${DateFormat.yMMMd().format(endDate!)}',
            style: const TextStyle(fontSize: 16),
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
