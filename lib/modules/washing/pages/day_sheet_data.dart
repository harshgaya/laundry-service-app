import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';

class DaySheetData extends StatefulWidget {
  const DaySheetData({super.key});

  @override
  State<DaySheetData> createState() => _DaySheetDataState();
}

class _DaySheetDataState extends State<DaySheetData> {
  final washingController = Get.put(WashingController());
  bool studentDaySheetSelected = true;
  bool facultyDaySheetSelected = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const CircleAvatar(
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
              Text(
                studentDaySheetSelected
                    ? 'Student Delivery\nDay Sheet'
                    : 'Faculty Delivery\nDay Sheet',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (washingController.teacherOrders.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        setState(() {
                          studentDaySheetSelected = !studentDaySheetSelected;
                          facultyDaySheetSelected = !facultyDaySheetSelected;
                        });
                      },
                      child: Text(
                        facultyDaySheetSelected
                            ? 'Student Day Sheet'
                            : 'Faculty Day Sheet',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              facultyDaySheetSelected
                  ? Obx(() => Expanded(
                        child: SingleChildScrollView(
                          child: Table(
                            border: const TableBorder(
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
                                          'Name',
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
                                          'Total Cloths',
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
                              ...washingController.teacherOrders
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
                                            order.value.teacherName,
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
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            '${order.value.totalCloths.toString()}',
                                            style: const TextStyle(
                                              fontSize: 16,
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
                      ))
                  : Obx(
                      () => Expanded(
                        child: SingleChildScrollView(
                          child: Table(
                            border: const TableBorder(
                                horizontalInside: BorderSide(
                                    color: Colors.black, width: 0.2)),
                            children: [
                              // Table header
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          'Tag No',
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
                                          'Cloths',
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
                                          'Uniforms',
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
                              ...washingController.orders
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
                                            '${order.value.tagNo}',
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
                                            '${order.value.totalCloths.toString()}',
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
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            '${order.value.totalUniforms.toString()}',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              TableRow(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.blue,
                                    )),
                                children: [
                                  TableCell(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '${washingController.orders.length}',
                                          style: const TextStyle(
                                            fontSize: 16,
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
                                        child: Text(
                                          '${washingController.orders.fold(0, (sum, order) => sum + order.totalCloths)}',
                                          style: const TextStyle(
                                            fontSize: 16,
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
                                        child: Text(
                                          '${washingController.orders.fold(0, (sum, order) => sum + order.totalUniforms)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
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
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
