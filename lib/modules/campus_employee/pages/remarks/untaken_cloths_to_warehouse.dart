import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/models/day_sheet_history.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UntakenClothsWarehouse extends StatefulWidget {
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final String collectionId;
  const UntakenClothsWarehouse(
      {super.key,
      required this.studentData,
      required this.facultyData,
      required this.collectionId});

  @override
  State<UntakenClothsWarehouse> createState() => _UntakenClothsWarehouseState();
}

class _UntakenClothsWarehouseState extends State<UntakenClothsWarehouse> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  List<StudentDaySheet> studentNewDaySheet = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    studentNewDaySheet = widget.studentData;
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
            const Text(
              'Untaken Cloths',
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
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'TAG NO.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'WAREHOUSE',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'CAMPUS',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
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
                    ...studentNewDaySheet
                        .asMap()
                        .entries
                        // .where((entry) => entry.value.delivered == false)
                        .map((order) {
                      return TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                Utils.extractNumber(
                                        order.value.tagNumber.toString())
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${order.value.wareHouseRegularCloths + order.value.wareHouseUniform}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${order.value.campusUniforms + order.value.campusRegularCloths}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Checkbox(
                                value: order.value.delivered,
                                onChanged: (bool? value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() {
                                    int index =
                                        studentNewDaySheet.indexOf(order.value);
                                    studentNewDaySheet[index].delivered = value;
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
              height: 10,
            ),
          ],
        ),
      ),
      bottomSheet: Obx(() => campusEmployeeController.updatingUntakenCloth.value
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
                  List<StudentDaySheet> deliveredStudents = studentNewDaySheet
                      .where((order) => order.delivered == true)
                      .toList();

                  campusEmployeeController.updateUntakenCloth(
                    collectionId: widget.collectionId,
                    student: deliveredStudents,
                    context: context,
                  );
                },
                image: const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            )),
    );
  }
}
