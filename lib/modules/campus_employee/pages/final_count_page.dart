import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

class FinalCountPage extends StatefulWidget {
  const FinalCountPage({super.key});

  @override
  State<FinalCountPage> createState() => _FinalCountPageState();
}

class _FinalCountPageState extends State<FinalCountPage> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Name',
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
                                        'Total Cloths',
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
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          order.value.teacherName,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '${totals[order.value.teacherName]}',
                                          style: TextStyle(
                                            fontSize: 12,
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
                  : Obx(() => Expanded(
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
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        'Tag No',
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
                                        'Cloths',
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
                                        'Uniforms',
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
                              ...campusEmployeeController.orders
                                  .asMap()
                                  .entries
                                  .map((order) {
                                return TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '${order.value.tagNo}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          '${order.value.totalCloths.toString()}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '${order.value.totalUniforms.toString()}',
                                          style: TextStyle(
                                            fontSize: 12,
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
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${campusEmployeeController.orders.length}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${campusEmployeeController.orders.fold(0, (sum, order) => sum + order.totalCloths + order.totalUniforms)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
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
              InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Alert'),
                            content: Text('Uploaded to sri chaityana school'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    campusEmployeeController
                                        .teacherOrders.value = [];
                                    campusEmployeeController.orders.value = [];
                                    Get.to(() => UserState());
                                  },
                                  child: const Text('Ok')),
                            ],
                          );
                        });
                  },
                  child: Center(
                    child: RoundButtonAnimate(
                      buttonName: 'Done',
                      onClick: () {
                        Utils.showDialogPopUp(
                            context: context,
                            function: () {
                              campusEmployeeController.teacherOrders.value = [];
                              campusEmployeeController.orders.value = [];
                              Get.to(() => const UserState());
                            },
                            title: 'Uploaded to sri chaityana school');
                      },
                      image: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
