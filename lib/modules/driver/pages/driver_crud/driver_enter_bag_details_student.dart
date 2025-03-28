import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/driver/controllers/driver_controller.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../campus_employee/pages/profile/campus_employee_profile.dart';

class DriverEnterBagDetailsStudents extends StatefulWidget {
  final String campusCode;
  final String campusName;
  final String collectionUid;
  final String status;
  const DriverEnterBagDetailsStudents(
      {super.key,
      required this.campusCode,
      required this.campusName,
      required this.collectionUid,
      required this.status});

  @override
  State<DriverEnterBagDetailsStudents> createState() =>
      _DriverEnterBagDetailsStudentsState();
}

class _DriverEnterBagDetailsStudentsState
    extends State<DriverEnterBagDetailsStudents> {
  final bagNoController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final driverController = Get.put(DriverController());
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Campus Name',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                      fontSize: 25,
                    )),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.campusName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (!driverController.hasUploadedBagNoStudent.value)
              Form(
                key: formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text(widget.campusCode)),
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
                            return 'Enter Bag No';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Enter Bag No',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          hintStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            driverController.addToBagList(
                                context: context,
                                bagNo: int.parse(bagNoController.text));
                            bagNoController.text = '';
                            setState(() {});
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => Expanded(
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
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Campus Code'.toUpperCase(),
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
                                  child: Text(
                                    'Bag No'.toUpperCase(),
                                    style: const TextStyle(
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
                        ...driverController.bagList
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
                                      widget.campusCode,
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
                                      order.value.bagNo.toString(),
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
                  ),
                )),
            if (!driverController.hasUploadedBagNoStudent.value)
              _image == null
                  ? InkWell(
                      onTap: _captureImage,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.camera_alt,
                          size: 100,
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: _captureImage,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.file(
                          _image!,
                          height: 100,
                        ),
                      )),
            if (!driverController.hasUploadedBagNoStudent.value)
              Obx(() => driverController.uploadingBagStudent.value
                  ? LoadingAnimationWidget.discreteCircle(
                      size: 40,
                      color: Colors.blue,
                      secondRingColor: const Color(0xFF1A1A3F),
                      thirdRingColor: const Color(0xFFEA3799))
                  : RoundButtonAnimate(
                      buttonName: 'Finish',
                      onClick: () {
                        if (_image == null) {
                          Utils.showScaffoldMessageI(
                              context: context, title: 'Please upload image');
                          return;
                        }
                        driverController.uploadBag(
                          status: widget.status,
                          bagNo: driverController.bagList
                              .map((element) => {"bag_number": element.bagNo})
                              .toList(),
                          image: _image!,
                          collectionId: widget.collectionUid,
                          context: context,
                        );
                      },
                      image: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
