import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';

import '../../../helpers/utils.dart';
import '../../campus_employee/controllers/campus_employee_controller.dart';
import '../../campus_employee/models/day_sheet_history.dart';
import '../../widegets/button_no_radius.dart';

class DaySheetData extends StatefulWidget {
  final bool isUniform;
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final List<OtherClothDaySheet> otherCloth;
  const DaySheetData(
      {super.key,
      required this.studentData,
      required this.facultyData,
      required this.isUniform,
      required this.otherCloth});

  @override
  State<DaySheetData> createState() => _DaySheetDataState();
}

class _DaySheetDataState extends State<DaySheetData> {
  final washingController = Get.put(WashingController());
  bool studentDaySheetSelected = true;
  bool facultyDaySheetSelected = false;
  bool otherDaySheetSelected = false;

  bool isAscending = true;
  int? sortColumnIndex;

  void sortTable(int columnIndex) {
    setState(() {
      if (sortColumnIndex == columnIndex) {
        isAscending = !isAscending;
      } else {
        sortColumnIndex = columnIndex;
        isAscending = true;
      }

      widget.studentData.sort((a, b) {
        int compare;
        switch (columnIndex) {
          case 0: // Custom logic for sorting tagNo
            compare = compareTagNo(a.tagNumber!, b.tagNumber!);
            break;
          case 1:
            compare = a.campusRegularCloths.compareTo(b.campusRegularCloths);
            break;
          case 2:
            compare = a.campusUniforms.compareTo(b.campusUniforms);
            break;
          case 3: // Custom logic for sorting by "Missing"
            int totalMissingA =
                (a.wareHouseRegularCloths + a.wareHouseUniform) -
                    (a.campusRegularCloths + a.campusUniforms);
            int totalMissingB =
                (b.wareHouseRegularCloths + b.wareHouseUniform) -
                    (b.campusRegularCloths + b.campusUniforms);
            compare = totalMissingA.compareTo(totalMissingB);
            break;
          case 4: // Custom logic for sorting by "Extra"
            int totalExtraA = (a.campusRegularCloths + a.campusUniforms) -
                (a.wareHouseRegularCloths + a.wareHouseUniform);
            int totalExtraB = (b.campusRegularCloths + b.campusUniforms) -
                (b.wareHouseRegularCloths + b.wareHouseUniform);
            compare = totalExtraA.compareTo(totalExtraB);
            break;
          default:
            compare = 0;
        }
        return isAscending ? compare : -compare;
      });
    });
  }

  int compareTagNo(String tagNoA, String tagNoB) {
    final regex = RegExp(r'(\D+)(\d+)');
    final matchA = regex.firstMatch(tagNoA);
    final matchB = regex.firstMatch(tagNoB);

    if (matchA != null && matchB != null) {
      final textPartA = matchA.group(1);
      final textPartB = matchB.group(1);
      final numberPartA = int.parse(matchA.group(2)!);
      final numberPartB = int.parse(matchB.group(2)!);

      // Compare the text parts
      int textCompare = textPartA!.compareTo(textPartB!);
      if (textCompare != 0) {
        return textCompare;
      }

      // If text parts are equal, compare the number parts
      return numberPartA.compareTo(numberPartB);
    } else {
      // If the format doesn't match the expected pattern, fall back to string comparison
      return tagNoA.compareTo(tagNoB);
    }
  }

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
                if (widget.otherCloth.isNotEmpty)
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
            // if (widget.facultyData.isNotEmpty)
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
                      ...widget.facultyData.asMap().entries.map((order) {
                        return TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    order.value.faculty!['name'] ?? '',
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
                                    '${order.value.regularCloths.toString()}',
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
              ),
            if (studentDaySheetSelected)
              Expanded(
                child: SingleChildScrollView(
                  child: Table(
                    border: const TableBorder(
                      horizontalInside:
                          BorderSide(color: Colors.black, width: 0.2),
                    ),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: InkWell(
                              onTap: () => sortTable(0),
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
                          ),
                          TableCell(
                            child: InkWell(
                              onTap: () => sortTable(1),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
                                    // 'CLOTHES',
                                    'CAMPUS',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // if (widget.isUniform)
                          TableCell(
                            child: InkWell(
                              onTap: () => sortTable(2),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
                                    // 'UNIFORMS',
                                    'WAREHOUSE',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: InkWell(
                              onTap: () => sortTable(3),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
                                    'MISSING',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: InkWell(
                              onTap: () => sortTable(4),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
                                    'EXTRA',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Table rows from the orders list
                      ...widget.studentData.asMap().entries.map((order) {
                        return TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    Utils.extractNumber(order.value.tagNumber!)
                                        .toString(),
                                    // '${order.value.tagNo}',
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
                                    (order.value.campusRegularCloths +
                                            order.value.campusUniforms)
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // if (widget.isUniform)
                            TableCell(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    (order.value.wareHouseUniform +
                                            order.value.wareHouseRegularCloths)
                                        .toString(),
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
                                  child: const Text(
                                    '0',
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
                                  child: const Text(
                                    '0',
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
                                  '${widget.studentData.length}',
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
                                  '${widget.studentData.fold(0, (sum, order) => sum + order.campusRegularCloths + order.campusUniforms)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // if (widget.isUniform)
                          TableCell(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '${widget.studentData.fold(0, (sum, order) => sum + order.wareHouseRegularCloths + order.wareHouseUniform)}',
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
                                child: const Text(
                                  '${0}',
                                  style: TextStyle(
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
                                child: const Text(
                                  '0',
                                  style: TextStyle(
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
                      ...widget.otherCloth.asMap().entries.map((order) {
                        return TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    order.value.name ?? '',
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
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
