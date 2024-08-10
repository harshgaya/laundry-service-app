import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/pages/faculty_cloths.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../controllers/campus_employee_controller.dart';

class RemarksPage extends StatefulWidget {
  const RemarksPage({super.key});

  @override
  State<RemarksPage> createState() => _RemarksPageState();
}

class _RemarksPageState extends State<RemarksPage> {
  final TextEditingController tagController = TextEditingController();
  final campusEmployeeController = Get.put(CampusEmployeeController());
  final remarkController = TextEditingController();
  bool enterRemarkVisible = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                            enterRemarkVisible = false;
                          });
                        } else {
                          if (campusEmployeeController.orders
                              .any((order) => order.tagNo == value)) {
                            setState(() {
                              enterRemarkVisible = true;
                            });
                          }
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
              Visibility(
                visible: enterRemarkVisible,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Form(
                    key: formKey,
                    child: SizedBox(
                      width: Get.width,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: remarkController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter remarks';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Remarks',
                              hintStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  var order = campusEmployeeController.orders
                                      .firstWhere((order) =>
                                          order.tagNo == tagController.text);
                                  order.remarks = remarkController.text;
                                  // If you're using an observable list (like with GetX), notify listeners manually:
                                  campusEmployeeController.orders.refresh();
                                  campusEmployeeController.orders.sort(
                                      (a, b) => a.tagNo.compareTo(b.tagNo));

                                  tagController.text = '';
                                  remarkController.text = '';
                                  setState(() {});
                                }
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
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
                                    'Tag No.',
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
                                    'Remarks',
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
                              .where((order) => order.value.remarks.isNotEmpty)
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
                                      order.value.tagNo,
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
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Tag Count: ${campusEmployeeController.orders.length}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Total Cloths: ${campusEmployeeController.orders.fold(0, (sum, order) => sum + order.totalCloths + order.totalUniforms)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  child: Text(''),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Finished Adding Remarks'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Get.to(() => FacultyCloth());
                                },
                                child: Text('Yes')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel')),
                          ],
                        );
                      });
                },
                child: Align(
                  alignment: Alignment.center,
                  child: RoundButtonAnimate(
                    buttonName: 'Finish',
                    onClick: () {},
                    image: const Icon(
                      Icons.done,
                      color: Colors.white,
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
