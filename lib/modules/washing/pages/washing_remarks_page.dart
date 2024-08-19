import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import 'package:laundry_service/modules/washing/pages/washing_add_remarks.dart';

import '../../campus_employee/controllers/campus_employee_controller.dart';

class WashingRemarksPage extends StatefulWidget {
  const WashingRemarksPage({super.key});

  @override
  State<WashingRemarksPage> createState() => _WashingRemarksPageState();
}

class _WashingRemarksPageState extends State<WashingRemarksPage> {
  final TextEditingController tagController = TextEditingController();
  final washingController = Get.put(WashingController());
  final remarkController = TextEditingController();
  bool enterRemarkVisible = false;
  final formKey = GlobalKey<FormState>();
  final dialogTextController = TextEditingController();
  List<String> remarks = [
    'Lost shape',
    'Excessive wrinkles',
    'Design peeling',
    'Other'
  ];
  String? selectedRemark;
  @override
  Widget build(BuildContext context) {
    print('selected remark 2 $selectedRemark');
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Remarks',
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
                    // Container(
                    //   height: 60,
                    //   width: 50,
                    //   child: Center(child: Text('SKH')),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.black),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        icon: SizedBox(),
                        onChanged: (String? newValue) {
                          selectedRemark = newValue;
                          setState(() {});
                          if (newValue == 'Other') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Enter Remark'),
                                  content: TextFormField(
                                    controller: dialogTextController,
                                    decoration: InputDecoration(
                                      labelText: 'Remark',
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
                                        setState(() {});

                                        Get.back(); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Select Remark',
                          hintStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.blue,
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please select remark';
                          }
                          return null;
                        },
                        value: selectedRemark,
                        dropdownColor: Colors.blue,
                        items: remarks
                            .map<DropdownMenuItem<String>>((String teacher) {
                          return DropdownMenuItem<String>(
                            value: teacher,
                            child: Text(
                              teacher,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
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
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              enterRemarkVisible = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search Tag No',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          hintStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: enterRemarkVisible,
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            print('selected remark ${selectedRemark}');
                            if (selectedRemark == 'Other') {
                              washingController.washingRemarks.add(
                                  RemarkDataWashing(
                                      tagNo: int.parse(tagController.text),
                                      remarks: dialogTextController.text));
                            } else {
                              washingController.washingRemarks.add(
                                  RemarkDataWashing(
                                      tagNo: int.parse(tagController.text),
                                      remarks: selectedRemark!));
                            }

                            setState(() {
                              enterRemarkVisible = false;
                              selectedRemark = null;
                              tagController.text = '';
                              dialogTextController.text = '';
                            });
                          }
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
                                        'Tag No.'.toUpperCase(),
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
                                        'Remarks',
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
                            ...washingController.washingRemarks
                                .asMap()
                                .entries
                                .where(
                                    (order) => order.value.remarks.isNotEmpty)
                                .map((order) {
                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          order.value.tagNo.toString(),
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
                                          '${order.value.remarks}',
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
                          ],
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                // InkWell(
                //   onTap: () {
                //     showDialog(
                //         context: context,
                //         builder: (context) {
                //           return AlertDialog(
                //             title: Text('Finished Adding Remarks'),
                //             actions: [
                //               TextButton(
                //                   onPressed: () {
                //                     Navigator.of(context).pop();
                //                   },
                //                   child: Text('Yes')),
                //               TextButton(
                //                   onPressed: () {
                //                     Navigator.of(context).pop();
                //                   },
                //                   child: Text('Cancel')),
                //             ],
                //           );
                //         });
                //   },
                //   child: Align(
                //     alignment: Alignment.center,
                //     child: Container(
                //       width: 180,
                //       height: 180,
                //       decoration: BoxDecoration(
                //         color: Colors.blue.shade50,
                //         shape: BoxShape.circle,
                //       ),
                //       child: Center(
                //         child: Container(
                //           width: 150,
                //           height: 150,
                //           decoration: BoxDecoration(
                //             color: Colors.blue,
                //             shape: BoxShape.circle,
                //           ),
                //           child: Center(
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Icon(
                //                   Icons.done,
                //                   color: Colors.white,
                //                   size: 30,
                //                 ),
                //                 SizedBox(
                //                   height: 10,
                //                 ),
                //                 Text(
                //                   'Finish',
                //                   style: TextStyle(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
