import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/driver/controllers/driver_controller.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../../authentication/pages/user_state.dart';

class DriverEnterBagDetailsFaculty extends StatefulWidget {
  const DriverEnterBagDetailsFaculty({super.key});

  @override
  State<DriverEnterBagDetailsFaculty> createState() =>
      _DriverEnterBagDetailsFacultyState();
}

class _DriverEnterBagDetailsFacultyState
    extends State<DriverEnterBagDetailsFaculty> {
  final driverController = Get.put(DriverController());
  final bagNoController = TextEditingController();
  final dialogTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? selectedTeacher;
  List<String> teacherNames = [
    'Mr. Smith',
    'Ms. Johnson',
    'Mrs. Brown',
    'Mr. White',
    'Other'
  ];
  List<File> listOfImages = [];

  final ImagePicker _picker = ImagePicker();
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        listOfImages.add(File(pickedFile.path));
      });
    } else {
      print('No image selected.');
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
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Select Faculty',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.blue,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please select faculty';
                        }
                        return null;
                      },
                      value: selectedTeacher,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTeacher = newValue;
                        });
                        if (newValue == 'Other') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Enter Faculty Name'),
                                content: TextFormField(
                                  controller: dialogTextController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
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
                      dropdownColor: Colors.blue,
                      items: teacherNames
                          .map<DropdownMenuItem<String>>((String teacher) {
                        return DropdownMenuItem<String>(
                          value: teacher,
                          child: Text(
                            teacher,
                            style: TextStyle(color: Colors.white),
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: bagNoController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter Bag No';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Enter Bag No',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        hintStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (selectedTeacher == 'Other') {
                          driverController.addOrUpdateTeacherOrder(
                              TeacherBagData(
                                  teacherName: dialogTextController.text,
                                  bagNo: bagNoController.text));
                          setState(() {
                            selectedTeacher = null;
                            bagNoController.text = '';
                          });
                        } else {
                          driverController.addOrUpdateTeacherOrder(
                              TeacherBagData(
                                  teacherName: selectedTeacher!,
                                  bagNo: bagNoController.text));
                          setState(() {
                            selectedTeacher = null;
                            bagNoController.text = '';
                          });
                        }
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    )),
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
                                      'Name',
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
                                      'Bag No',
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
                          ...driverController.teacherBagNoList
                              .asMap()
                              .entries
                              .map((order) {
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        order.value.teacherName,
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
                                        '${order.value.bagNo}',
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
                height: 20,
              ),
              if (listOfImages.isNotEmpty)
                SizedBox(
                  height: 130,
                  width: Get.width - 20,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listOfImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Stack(
                            children: [
                              Image.file(
                                listOfImages[index],
                                height: 120,
                              ),
                              Positioned(
                                  right: 10,
                                  top: 10,
                                  child: InkWell(
                                    onTap: () {
                                      listOfImages.removeAt(index);
                                      setState(() {});
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 15,
                                      child: Icon(
                                        Icons.close,
                                        size: 20,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      }),
                ),
              InkWell(
                onTap: _captureImage,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.camera_alt,
                    size: 100,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: RoundButtonAnimate(
                  buttonName: 'Finish',
                  onClick: () {
                    if (listOfImages.isEmpty ||
                        listOfImages.length <
                            driverController.teacherBagNoList.length) {
                      Utils.showScaffoldMessageI(
                          context: context,
                          title: 'Please upload all faculty image');
                      return;
                    }
                    Utils.showDialogPopUp(
                        context: context,
                        function: () {
                          Get.back();
                        },
                        title: 'Finished Adding Bags');
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
      ),
    );
  }
}
