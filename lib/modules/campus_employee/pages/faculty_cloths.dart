import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/models/faculty_model.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_upload_collection_image.dart';
import 'package:laundry_service/modules/campus_employee/pages/final_count_page.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

class FacultyCloth extends StatefulWidget {
  const FacultyCloth({super.key});

  @override
  State<FacultyCloth> createState() => _FacultyClothState();
}

class _FacultyClothState extends State<FacultyCloth> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  final clothController = TextEditingController();
  String? selectedTeacher;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    campusEmployeeController.getFacultyList();
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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Faculty Cloths',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Select Faculty',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue,
                    ),
                    value: selectedTeacher,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTeacher = newValue;
                      });
                    },
                    dropdownColor: Colors.blue,
                    items: campusEmployeeController.facultyList
                        .map<DropdownMenuItem<String>>((Faculty teacher) {
                      return DropdownMenuItem<String>(
                        value: teacher.name,
                        child: Text(
                          teacher.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  )),
              const SizedBox(
                height: 20,
              ),
              if (selectedTeacher != null)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 2,
                        controller: clothController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter total cloths';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                          hintText: 'Enter Total Cloths',
                          hintStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            campusEmployeeController
                                .addOrUpdateTeacherOrder(TeacherOrder(
                              teacherName: selectedTeacher!,
                              totalCloths: int.parse(clothController.text),
                            ));
                            setState(() {
                              clothController.text = '';
                              selectedTeacher = null;
                            });
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => Table(
                    border: const TableBorder(
                        horizontalInside:
                            BorderSide(color: Colors.black, width: 0.2)),
                    children: [
                      const TableRow(
                        children: [
                          TableCell(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'NAME',
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
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'TOTAL CLOTHS',
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
                      ...campusEmployeeController.teacherOrders
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
                                    '${order.value.totalCloths}',
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
                                  '${campusEmployeeController.teacherOrders.length}',
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
                                  '${campusEmployeeController.teacherOrders.fold(0, (sum, order) => sum + order.totalCloths)}',
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
                  )),
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              if (selectedTeacher == null)
                Obx(() => Align(
                      alignment: Alignment.center,
                      child: RoundButtonAnimate(
                        buttonName:
                            campusEmployeeController.teacherOrders.isEmpty
                                ? 'Skip'
                                : 'Finish',
                        onClick: () {
                          Utils.showDialogPopUp(
                              context: context,
                              function: () {
                                Get.to(() => const FinalCountPage());
                              },
                              title: 'Finished Adding Faculty Cloth');
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
