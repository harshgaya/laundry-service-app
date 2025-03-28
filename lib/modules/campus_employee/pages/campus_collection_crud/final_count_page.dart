import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_collection_crud/CampusEmployeeUploadDaySheetImage.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../../../widegets/button_no_radius.dart';

class FinalCountPage extends StatefulWidget {
  const FinalCountPage({super.key});

  @override
  State<FinalCountPage> createState() => _FinalCountPageState();
}

class _FinalCountPageState extends State<FinalCountPage> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  bool studentDaySheetSelected = true;
  bool facultyDaySheetSelected = false;
  bool otherDaySheetSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonNoRadius(
                  isSelected: studentDaySheetSelected,
                  buttonText: 'Student',
                  function: () {
                    setState(() {
                      studentDaySheetSelected = true;
                      facultyDaySheetSelected = false;
                      otherDaySheetSelected = false;
                    });
                  },
                ),
                if (campusEmployeeController.teacherOrders.isNotEmpty)
                  ButtonNoRadius(
                    isSelected: facultyDaySheetSelected,
                    buttonText: 'Faculty',
                    function: () {
                      setState(() {
                        studentDaySheetSelected = false;
                        facultyDaySheetSelected = true;
                        otherDaySheetSelected = false;
                      });
                    },
                  ),
                if (campusEmployeeController.otherClothList.isNotEmpty)
                  ButtonNoRadius(
                    isSelected: otherDaySheetSelected,
                    buttonText: 'Other',
                    function: () {
                      setState(() {
                        studentDaySheetSelected = false;
                        facultyDaySheetSelected = false;
                        otherDaySheetSelected = true;
                      });
                    },
                  )
              ],
            ),
            Text(
              studentDaySheetSelected
                  ? 'Student Delivery\nDay Sheet'
                  : facultyDaySheetSelected
                      ? 'Faculty Delivery\nDay Sheet'
                      : 'Other Delivery\nDay Sheet',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // if (campusEmployeeController.teacherOrders.isNotEmpty)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       ElevatedButton(
            //         style:
            //             ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            //         onPressed: () {
            //           setState(() {
            //             studentDaySheetSelected = !studentDaySheetSelected;
            //             facultyDaySheetSelected = !facultyDaySheetSelected;
            //           });
            //         },
            //         child: Text(
            //           facultyDaySheetSelected
            //               ? 'Student Day Sheet'
            //               : 'Faculty Day Sheet',
            //           style: const TextStyle(
            //             color: Colors.white,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // const SizedBox(
            //   height: 20,
            // ),
            if (facultyDaySheetSelected)
              Obx(() => Expanded(
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
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
                                      'NAME',
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
                                      'TOTAL CLOTHES',
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
                          ...campusEmployeeController.teacherOrders
                              .asMap()
                              .entries
                              .map((order) {
                            final totals = campusEmployeeController
                                .calculateTotalClothesPerTeacher();
                            final sortedTeacherNames = totals.keys.toList()
                              ..sort();

                            return TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        order.value.teacherName,
                                        style: const TextStyle(
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
                                        '${totals[order.value.teacherName]}',
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
                  )),
            if (studentDaySheetSelected)
              Obx(() => Expanded(
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
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
                                      'TAG NO',
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
                                      'CLOTHES',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (campusEmployeeController.isUniform.value)
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
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
                          ...campusEmployeeController.orders
                              .asMap()
                              .entries
                              .map((order) {
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${order.value.tagNo}',
                                        style: const TextStyle(
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
                                if (campusEmployeeController.isUniform.value)
                                  TableCell(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '${order.value.totalUniforms.toString()}',
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
                                      '${campusEmployeeController.orders.length}',
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
                                      '${campusEmployeeController.orders.fold(0, (sum, order) => sum + order.totalCloths)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (campusEmployeeController.isUniform.value)
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${campusEmployeeController.orders.fold(0, (sum, order) => sum + order.totalUniforms)}',
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
                  )),
            if (otherDaySheetSelected)
              Obx(() => Expanded(
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
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
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
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
                                      'CLOTHES',
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
                          ...campusEmployeeController.otherClothList
                              .asMap()
                              .entries
                              .map((order) {
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${order.value.name}',
                                        style: const TextStyle(
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
                                        '${order.value.noOfItems.toString()}',
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
                                      '${campusEmployeeController.otherClothList.length}',
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
                                      '${campusEmployeeController.otherClothList.fold(0, (sum, order) => sum + order.noOfItems)}',
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
                  )),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: RoundButtonAnimate(
                buttonName: 'Done',
                onClick: () {
                  Get.to(() => const CampusEmployeeUploadDaySheetImage());
                },
                image: const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
