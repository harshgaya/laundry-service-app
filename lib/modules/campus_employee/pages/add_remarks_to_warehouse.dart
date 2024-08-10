import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/modules/campus_employee/pages/remarks_page.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../controllers/campus_employee_controller.dart';

class AddRemarksToWarehouse extends StatefulWidget {
  const AddRemarksToWarehouse({super.key});

  @override
  State<AddRemarksToWarehouse> createState() => _AddRemarksToWarehouseState();
}

class _AddRemarksToWarehouseState extends State<AddRemarksToWarehouse> {
  final TextEditingController tagController = TextEditingController();
  final campusEmployeeController = Get.put(CampusEmployeeController());
  bool buttonVisible = false;
  String? selectedRemark;
  List<String> remarks = [
    'Torn',
    'Not Cleaned',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: CircleAvatar(
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
                Container(
                  height: 60,
                  width: 50,
                  child: Center(child: Text('SKH')),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: tagController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          buttonVisible = false;
                        });
                      } else {
                        setState(() {
                          buttonVisible = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search Tag No',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    padding: EdgeInsets.zero,
                    decoration: InputDecoration(
                      hintText: 'Select Remark',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      filled: true,
                    ),
                    value: selectedRemark,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRemark = newValue;
                      });
                    },
                    // dropdownColor: Colors.blue,
                    items:
                        remarks.map<DropdownMenuItem<String>>((String teacher) {
                      return DropdownMenuItem<String>(
                        value: teacher,
                        child: Text(
                          teacher,
                          style: TextStyle(color: Colors.black),
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
                      if (selectedRemark == null) {
                        return;
                      }
                      campusEmployeeController.addRemarkToWareHouse(
                          int.parse(tagController.text), selectedRemark!);
                      campusEmployeeController.orders
                          .sort((a, b) => a.tagNo.compareTo(b.tagNo));

                      tagController.text = '';
                      selectedRemark = null;
                      setState(() {});
                    },
                    child: Text(
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
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'S.NO.',
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
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'REMARKS',
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
                        ...campusEmployeeController.remarkToWarehouse
                            .asMap()
                            .entries
                            .map((order) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    '${order.key + 1}',
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
                                    order.value.tagNo.toString(),
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
                                    '${order.value.remarks}',
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
                )),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: RoundButtonAnimate(
                buttonName: 'Finish',
                onClick: () {
                  Navigator.of(context).pop();
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
