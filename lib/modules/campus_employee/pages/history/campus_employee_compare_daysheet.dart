import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../widegets/button_no_radius.dart';
import '../../../widegets/round_button_animate.dart';
import '../../models/day_sheet_history.dart';

class CampusEmployeeCompareDaysheet extends StatefulWidget {
  final String collectionId;
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final List<OtherClothDaySheet> otherClothList;
  final bool isFromSearch;
  const CampusEmployeeCompareDaysheet(
      {super.key,
      required this.studentData,
      required this.facultyData,
      required this.collectionId,
      required this.isFromSearch,
      required this.otherClothList});

  @override
  State<CampusEmployeeCompareDaysheet> createState() =>
      _CampusEmployeeCompareDaysheetState();
}

class _CampusEmployeeCompareDaysheetState
    extends State<CampusEmployeeCompareDaysheet> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  bool studentDaySheetSelected = true;
  bool facultyDaySheetSelected = false;
  bool otherDaySheetSelected = false;
  bool buttonVisible = false;
  List<StudentDaySheet> studentNewDaySheet = [];
  List<FacultyDaySheet> facultyNewDaySheet = [];
  List<OtherClothDaySheet> otherNewClothList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    studentNewDaySheet = widget.studentData;
    facultyNewDaySheet = widget.facultyData;
    otherNewClothList = widget.otherClothList;
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the process?'),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool value) async {
        if (value) {
          return;
        }
        final pop = await _onWillPop();
        if (pop) {
          Navigator.of(context).pop();
        }
      },
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
                  if (widget.facultyData.isNotEmpty)
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
                  if (widget.otherClothList.isNotEmpty)
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
              // if (widget.campusEmployeeFacultyDaySheetCompareData.isNotEmpty)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.blue),
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
              if (studentDaySheetSelected)
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
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
                                    'TAG NO.',
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
                                  child: Text(
                                    'Campus'.toUpperCase(),
                                    style: const TextStyle(
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
                                  child: Text(
                                    'Warehouse'.toUpperCase(),
                                    style: const TextStyle(
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
                                    'DELIEVERED',
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
                        ...studentNewDaySheet.map((order) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      '${Utils.extractNumber(order.tagNumber.toString())}',
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
                                      '${order.campusRegularCloths + order.campusUniforms}',
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
                                      '${order.wareHouseUniform + order.wareHouseRegularCloths}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Checkbox(
                                    value: order.delivered,
                                    onChanged: (bool? value) {
                                      if (value == null) {
                                        return;
                                      }
                                      setState(() {
                                        int index =
                                            studentNewDaySheet.indexOf(order);
                                        studentNewDaySheet[index].delivered =
                                            value;
                                      });
                                    },
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
              if (facultyDaySheetSelected)
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
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Name'.toUpperCase(),
                                    style: const TextStyle(
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
                                  child: Text(
                                    'Campus'.toUpperCase(),
                                    style: const TextStyle(
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
                                  child: Text(
                                    'Warehouse'.toUpperCase(),
                                    style: const TextStyle(
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
                                  child: Text(
                                    'Delivered'.toUpperCase(),
                                    style: const TextStyle(
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
                        ...facultyNewDaySheet.map((order) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      order.faculty!['name'].toString(),
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
                                      '${order.regularCloths}',
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
                                      '${order.wareHouseRegularCloths}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Checkbox(
                                    value: order.delivered,
                                    onChanged: (bool? value) {
                                      if (value == null) {
                                        return;
                                      }
                                      setState(() {
                                        int index =
                                            facultyNewDaySheet.indexOf(order);
                                        facultyNewDaySheet[index].delivered =
                                            value;
                                        // order.delivered = true;
                                        // bool allDelivered = widget
                                        //     .campusEmployeeFacultyDaySheetCompareData
                                        //     .every((order) =>
                                        //         order.delivered == true);
                                        // bool allDelivered2 = widget
                                        //     .campusEmployeeStudentDaySheetCompareData
                                        //     .every((order) =>
                                        //         order.delivered == true);
                                        // if (allDelivered && allDelivered2) {
                                        //   buttonVisible = true;
                                        // }
                                      });
                                    },
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
              if (otherDaySheetSelected)
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
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Name'.toUpperCase(),
                                    style: const TextStyle(
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
                                  child: Text(
                                    'Campus'.toUpperCase(),
                                    style: const TextStyle(
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
                                  child: Text(
                                    'Warehouse'.toUpperCase(),
                                    style: const TextStyle(
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
                                  child: Text(
                                    'Delivered'.toUpperCase(),
                                    style: const TextStyle(
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
                        ...otherNewClothList.map((order) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      order.name.toString(),
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
                                      '${order.noOfItems}',
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
                                      '${order.noOfItems}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Checkbox(
                                    value: order.delivered,
                                    onChanged: (bool? value) {
                                      if (value == null) {
                                        return;
                                      }
                                      setState(() {
                                        int index =
                                            otherNewClothList.indexOf(order);
                                        otherNewClothList[index].delivered =
                                            value;
                                      });
                                    },
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
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
        bottomSheet: Obx(() => campusEmployeeController
                .updatingDeliveryDaySheet.value
            ? LoadingAnimationWidget.discreteCircle(
                size: 40,
                color: Colors.blue,
                secondRingColor: const Color(0xFF1A1A3F),
                thirdRingColor: const Color(0xFFEA3799))
            : Visibility(
                visible: true,
                child: RoundButtonAnimate(
                  buttonName: 'Finish',
                  onClick: () {
                    bool allFacultyDelivered = facultyNewDaySheet
                        .every((order) => order.delivered == true);
                    print('delivered all faculty $allFacultyDelivered');

                    if (!allFacultyDelivered) {
                      Utils.showScaffoldMessageI(
                          context: context,
                          title: 'Please deliver all faculty cloth.');
                      return;
                    }
                    List<StudentDaySheet> deliveredStudents = studentNewDaySheet
                        .where((order) => order.delivered == true)
                        .toList();
                    List<OtherClothDaySheet> deliveredOtherCloths =
                        otherNewClothList
                            .where((order) => order.delivered == true)
                            .toList();

                    campusEmployeeController.updateDeliveryDaySheet(
                        collectionId: widget.collectionId,
                        student: deliveredStudents,
                        faculty: widget.facultyData,
                        context: context,
                        fromSearch: widget.isFromSearch,
                        otherClothData: deliveredOtherCloths);
                  },
                  image: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
              )),
      ),
    );
  }
}
