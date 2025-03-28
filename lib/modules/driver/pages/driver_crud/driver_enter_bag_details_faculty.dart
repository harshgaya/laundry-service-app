import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/driver/controllers/driver_controller.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../authentication/pages/user_state.dart';
import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../campus_employee/models/day_sheet_history.dart';

class DriverEnterBagDetailsFaculty extends StatefulWidget {
  final String status;
  final String collectionId;
  final List<FacultyDaySheet> facultyData;
  const DriverEnterBagDetailsFaculty(
      {super.key,
      required this.facultyData,
      required this.status,
      required this.collectionId});

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
  String? selectedUid;
  File? currentImage;

  List<Map<String, dynamic>> facultyList = [];
  List<File> listOfImages = [];

  final ImagePicker _picker = ImagePicker();
  Future<void> _captureImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      print('image ${pickedFile?.path}');

      if (pickedFile != null) {
        currentImage = File(pickedFile.path);
        // final data = driverController.teacherBagNoList
        //     .firstWhere((element) => element.teacherName == selectedTeacher);
        // data.image = File(pickedFile.path);
        // driverController.teacherBagNoList.refresh();
        setState(() {});
        print('image selected.');
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('error $e');
    }
  }

  File? getSelectedTeacherImage() {
    final data = driverController.teacherBagNoList
        .firstWhere((element) => element.teacherName == selectedTeacher);
    return data.image;
  }

  bool imageExistsForSelectedTeacher() {
    try {
      driverController.teacherBagNoList.firstWhere(
        (element) =>
            element.teacherName == selectedTeacher && element.image != null,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var uuid = const Uuid();
    facultyList = widget.facultyData.map((faculty) {
      return {
        'name': faculty.faculty!['name'],
        'uid': faculty.faculty!['uid'],
      };
    }).toList();
    Set<String> uniqueUids = {};
    facultyList = facultyList.where((faculty) {
      return uniqueUids.add(faculty['uid']!);
    }).toList();
    facultyList.add({'name': 'Other', 'uid': uuid.v4()});
  }

  @override
  Widget build(BuildContext context) {
    print('faculty length ${widget.facultyData.length}');
    print('selected uid ${selectedUid} selected teacher $selectedTeacher');
    print('dtaa ${driverController.teacherBagNoList.toString()}');
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
              if (!driverController.hasUploadedBagNoFaculty.value)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: 'Select Faculty',
                          hintStyle: const TextStyle(color: Colors.white),
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
                            Map<String, dynamic> data = facultyList.firstWhere(
                                (element) => element['name'] == newValue);
                            selectedUid = data['uid'];
                          });
                          if (newValue == 'Other') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Enter Faculty Name'),
                                  content: TextFormField(
                                    controller: dialogTextController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back(); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {});

                                        Get.back(); // Close the dialog
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        dropdownColor: Colors.blue,
                        items: facultyList.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> teacher) {
                          return DropdownMenuItem<String>(
                            value: teacher['name'],
                            child: Text(
                              teacher['name'],
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
                        controller: bagNoController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Enter Total Bag No';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Enter Total Bag No',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          hintStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              if (!driverController.hasUploadedBagNoFaculty.value)
                const SizedBox(
                  height: 20,
                ),
              if (!driverController.hasUploadedBagNoFaculty.value &&
                  selectedTeacher != null)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (selectedTeacher == 'Other') {
                            if (currentImage == null) {
                              Utils.showScaffoldMessageI(
                                  context: context,
                                  title:
                                      'Upload Bag Image For faculty $selectedTeacher');
                              return;
                            }
                            driverController.addOrUpdateTeacherOrder(
                                TeacherBagData(
                                    teacherName: dialogTextController.text,
                                    bagNo: bagNoController.text,
                                    uid: selectedUid!,
                                    image: currentImage));
                            setState(() {
                              selectedTeacher = null;
                              selectedUid = null;
                              bagNoController.text = '';
                              currentImage = null;
                            });
                          } else {
                            if (currentImage == null) {
                              Utils.showScaffoldMessageI(
                                  context: context,
                                  title:
                                      'Upload Bag Image For faculty $selectedTeacher');
                              return;
                            }
                            driverController.addOrUpdateTeacherOrder(
                                TeacherBagData(
                                    teacherName: selectedTeacher!,
                                    bagNo: bagNoController.text,
                                    uid: selectedUid!,
                                    image: currentImage));
                            setState(() {
                              selectedTeacher = null;
                              selectedUid = null;
                              bagNoController.text = '';
                              currentImage = null;
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              if (!driverController.hasUploadedBagNoFaculty.value)
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
                                  child: const Text(
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
                                  padding: const EdgeInsets.all(8),
                                  child: const Text(
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
                                      order.value.bagNo,
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
              const Spacer(),
              if (selectedTeacher != null)
                Obx(() => Center(
                      child: imageExistsForSelectedTeacher()
                          ? Image.file(
                              getSelectedTeacherImage()!,
                              height: 200,
                            )
                          : currentImage == null
                              ? InkWell(
                                  onTap: () => _captureImage(),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 100,
                                    color: Colors.blue,
                                  ),
                                )
                              : Image.file(
                                  currentImage!,
                                  height: 200,
                                ),
                    )),
              if (!driverController.hasUploadedBagNoFaculty.value)
                Obx(() => driverController.uploadingFacultyStudent.value
                    ? Center(
                        child: LoadingAnimationWidget.discreteCircle(
                            size: 40,
                            color: Colors.blue,
                            secondRingColor: const Color(0xFF1A1A3F),
                            thirdRingColor: const Color(0xFFEA3799)))
                    : Align(
                        alignment: Alignment.center,
                        child: RoundButtonAnimate(
                          buttonName: 'Finish',
                          onClick: () {
                            Utils.showDialogPopUp(
                                context: context,
                                function: () {
                                  driverController.uploadFacultyBag(
                                      context: context,
                                      status: widget.status,
                                      collectionId: widget.collectionId);
                                },
                                title: 'Finished Adding Bags');
                            // if (driverController.teacherBagNoList
                            //     .every((element) => element.image != null)) {
                            //   Utils.showDialogPopUp(
                            //       context: context,
                            //       function: () {
                            //         driverController.uploadFacultyBag(
                            //             context: context,
                            //             status: widget.status,
                            //             collectionId: widget.collectionId);
                            //       },
                            //       title: 'Finished Adding Bags');
                            // } else {
                            //   Utils.showScaffoldMessageI(
                            //       context: context,
                            //       title: 'Upload all faculty image.');
                            // }
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
