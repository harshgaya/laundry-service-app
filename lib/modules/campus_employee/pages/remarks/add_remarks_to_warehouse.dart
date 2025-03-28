import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/modules/campus_employee/models/day_sheet_history.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../controllers/campus_employee_controller.dart';

class AddRemarksToWarehouse extends StatefulWidget {
  final String tagName;
  final String campusId;
  final String collectionId;
  final List<StudentRemark> studentRemark;
  AddRemarksToWarehouse(
      {super.key,
      required,
      required this.tagName,
      required this.campusId,
      required this.collectionId,
      required this.studentRemark});

  @override
  State<AddRemarksToWarehouse> createState() => _AddRemarksToWarehouseState();
}

class _AddRemarksToWarehouseState extends State<AddRemarksToWarehouse> {
  final TextEditingController tagController = TextEditingController();
  final campusEmployeeController = Get.put(CampusEmployeeController());
  bool buttonVisible = false;
  String? selectedRemark;
  String? remarkText;
  List<String> remarks = [
    'Color Bleeding',
    'Torn',
    'Improper Cleaning',
    'Not Cleaned',
    'Unpleasant Odor',
    'Damaged Clothing',
    'Other'
  ];
  final dialogTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    campusEmployeeController.getCampusDetails(campusId: widget.campusId);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (campusEmployeeController.studentRemarks.isEmpty) {
        campusEmployeeController.studentRemarks.addAll(widget.studentRemark);
      }
    });
  }

  List<StudentRemark> studentRemarkList = [];

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
      body: Obx(
        () => campusEmployeeController.gettingCampusDetails.value
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                  size: 40,
                  color: Colors.blue,
                  secondRingColor: const Color(0xFF1A1A3F),
                  thirdRingColor: const Color(0xFFEA3799),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Complain',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text(widget.tagName)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: tagController,
                              onChanged: (value) async {
                                if (value.isEmpty) {
                                  setState(() {
                                    buttonVisible = false;
                                  });
                                } else {
                                  int enteredValue = int.tryParse(value) ?? 0;
                                  if (enteredValue >= 101 &&
                                      enteredValue <=
                                          campusEmployeeController
                                              .maxStudentCount.value) {
                                    setState(() {
                                      buttonVisible = true;
                                    });
                                  }

                                  // bool tagExist =
                                  //     await campusEmployeeController.searchTag(
                                  //         tag: '${widget.tagName}$value',
                                  //         campusId: widget.campusId);
                                  // if (tagExist) {
                                  //   setState(() {
                                  //     buttonVisible = true;
                                  //   });
                                  // }
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Enter Tag No',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                hintStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              padding: EdgeInsets.zero,
                              decoration: InputDecoration(
                                hintText: 'Select Complain',
                                hintStyle: const TextStyle(
                                    color: Colors.black, fontSize: 13),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                filled: true,
                              ),
                              value: selectedRemark,
                              onChanged: (String? newValue) {
                                if (newValue == 'Other') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Enter Complain'),
                                        content: TextFormField(
                                          controller: dialogTextController,
                                          decoration: const InputDecoration(
                                            labelText: 'Complain',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back(); // Close the dialog
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                remarkText =
                                                    dialogTextController.text;
                                              });

                                              Get.back(); // Close the dialog
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  setState(() {
                                    remarkText = newValue;
                                    selectedRemark = newValue;
                                  });
                                }
                              },
                              // dropdownColor: Colors.blue,
                              items: remarks.map<DropdownMenuItem<String>>(
                                  (String teacher) {
                                return DropdownMenuItem<String>(
                                  value: teacher,
                                  child: Text(
                                    teacher,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: buttonVisible,
                        child: Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                if (remarkText == null) {
                                  return;
                                }
                                campusEmployeeController.addRemarkToWareHouse(
                                    '${widget.tagName}${tagController.text}',
                                    remarkText!,
                                    false,
                                    '');
                                // campusEmployeeController.orders
                                //     .sort((a, b) => a.tagNo.compareTo(b.tagNo));

                                studentRemarkList.add(StudentRemark(
                                    tagNumber:
                                        '${widget.tagName}${tagController.text}',
                                    remark: remarkText!,
                                    remarkStatus: false,
                                    resolution: ''));
                                tagController.text = '';
                                selectedRemark = null;
                                setState(() {});
                              },
                              child: const Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(() => SingleChildScrollView(
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
                                            'S.NO.',
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
                                          child: const Text(
                                            'COMPLAIN',
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
                                            'STATUS',
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
                                            'RESOLUTION',
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
                                ...campusEmployeeController.studentRemarks
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
                                              '${order.key + 1}',
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
                                              '${order.value.tagNumber.toString()}',
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
                                              '${order.value.remark}',
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
                                              '${order.value.remarkStatus ? 'Done' : 'Not Done'}',
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
                                              '${order.value.resolution}',
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
                          )),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomSheet:
          Obx(() => campusEmployeeController.uploadingStudentRemark.value
              ? LoadingAnimationWidget.discreteCircle(
                  size: 40,
                  color: Colors.blue,
                  secondRingColor: const Color(0xFF1A1A3F),
                  thirdRingColor: const Color(0xFFEA3799),
                )
              : RoundButtonAnimate(
                  buttonName: 'Finish',
                  onClick: () async {
                    await campusEmployeeController.uploadStudentRemarks(
                        collectionId: widget.collectionId,
                        tagId: widget.tagName,
                        context: context,
                        list: studentRemarkList);
                  },
                  image: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                )),
    );
  }
}
