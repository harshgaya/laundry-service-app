import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import 'package:laundry_service/modules/washing/pages/remark/washing_remarks_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../helpers/utils.dart';
import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../campus_employee/models/day_sheet_history.dart';
import '../../../widegets/round_button_animate.dart';

class WashingRemarksPage extends StatefulWidget {
  final String collectionId;
  final String tagId;
  final List<WarehouseRemark> studentRemark;
  const WashingRemarksPage(
      {super.key,
      required this.collectionId,
      required this.tagId,
      required this.studentRemark});

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
  List<WarehouseRemark> warehouseRemarkList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    washingController.getUserId();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (washingController.washingRemarks.isEmpty) {
        washingController.washingRemarks.addAll(widget.studentRemark);
      }
    });
  }

  String? selectedRemark;
  @override
  Widget build(BuildContext context) {
    print('selected remark 2 $selectedRemark');
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, left: 8, right: 8),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        isExpanded: true,
                        icon: const SizedBox(),
                        onChanged: (String? newValue) {
                          selectedRemark = newValue;
                          setState(() {});
                          if (newValue == 'Other') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Enter Remark'),
                                  content: TextFormField(
                                    controller: dialogTextController,
                                    decoration: const InputDecoration(
                                      labelText: 'Remark',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {});

                                        Get.back();
                                      },
                                      child: const Text('OK'),
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
                            if (selectedRemark == null) {
                              return;
                            }
                            if (selectedRemark == 'Other') {
                              washingController.washingRemarks.add(
                                  WarehouseRemark(
                                      tagNumber:
                                          '${widget.tagId}${tagController.text}',
                                      remark: dialogTextController.text,
                                      employee:
                                          washingController.userId.value));
                              warehouseRemarkList.add(WarehouseRemark(
                                  tagNumber:
                                      '${widget.tagId}${tagController.text}',
                                  remark: dialogTextController.text,
                                  employee: washingController.userId.value));
                            } else {
                              washingController.washingRemarks.add(
                                  WarehouseRemark(
                                      tagNumber:
                                          '${widget.tagId}${tagController.text}',
                                      remark: selectedRemark!,
                                      employee:
                                          washingController.userId.value));
                              warehouseRemarkList.add(WarehouseRemark(
                                  tagNumber:
                                      '${widget.tagId}${tagController.text}',
                                  remark: selectedRemark!,
                                  employee: washingController.userId.value));
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
                Obx(() => SingleChildScrollView(
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
                                      'Tag No.'.toUpperCase(),
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
                              .where((order) => order.value.remark.isNotEmpty)
                              .map((order) {
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        order.value.tagNumber.toString(),
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
                                        order.value.remark,
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
      bottomSheet: Obx(() => washingController.uploadingRemarks.value
          ? LoadingAnimationWidget.discreteCircle(
              size: 40,
              color: Colors.blue,
              secondRingColor: const Color(0xFF1A1A3F),
              thirdRingColor: const Color(0xFFEA3799))
          : RoundButtonAnimate(
              buttonName: 'Update',
              onClick: () {
                Utils.showDialogPopUp(
                    context: context,
                    function: () async {
                      await washingController.uploadWashingRemarks(
                          collectionId: widget.collectionId,
                          context: context,
                          warehouseRem: warehouseRemarkList);
                    },
                    title: 'Done?');
              },
              image: Image.asset('assets/icons/drying.png'))),
    );
  }
}
