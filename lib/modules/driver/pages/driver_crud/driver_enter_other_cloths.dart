import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../authentication/pages/user_state.dart';
import '../../controllers/driver_controller.dart';
import 'dart:io';

class DriverEnterOtherCloths extends StatefulWidget {
  final String status;
  final String collectionId;
  final String campusCode;
  const DriverEnterOtherCloths(
      {super.key,
      required this.status,
      required this.collectionId,
      required this.campusCode});

  @override
  State<DriverEnterOtherCloths> createState() => _DriverEnterOtherClothsState();
}

class _DriverEnterOtherClothsState extends State<DriverEnterOtherCloths> {
  final driverController = Get.put(DriverController());
  final bagNoController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? currentImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> _captureImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      print('image ${pickedFile?.path}');

      if (pickedFile != null) {
        currentImage = File(pickedFile.path);
        setState(() {});
        print('image selected.');
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('error $e');
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
                'Other Clothes',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (!driverController.hasUploadedBagNoOther.value)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            // if (currentImage == null) {
                            //   Utils.showScaffoldMessageI(
                            //       context: context, title: 'Upload Bag Image');
                            //   return;
                            // }
                            driverController.bagListOtherCloth.add(
                                DriverBagData(
                                    campusId: widget.campusCode,
                                    bagNo: int.parse(bagNoController.text)));
                            setState(() {
                              bagNoController.text = '';
                              // currentImage = null;
                            });
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              if (!driverController.hasUploadedBagNoOther.value)
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
                                    'CAMPUS CODE',
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
                        ...driverController.bagListOtherCloth
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
                  )),
              const Spacer(),
              if (!driverController.hasUploadedBagNoOther.value)
                Center(
                  child: currentImage == null
                      ? InkWell(
                          onTap: () => _captureImage(),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 100,
                            color: Colors.blue,
                          ),
                        )
                      : InkWell(
                          onTap: () => _captureImage(),
                          child: Image.file(
                            currentImage!,
                            height: 200,
                          ),
                        ),
                ),
              if (!driverController.hasUploadedBagNoOther.value)
                Obx(() => driverController.uploadingBagOther.value
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
                            if (currentImage == null) {
                              Utils.showScaffoldMessageI(
                                  context: context, title: 'Upload image');
                              return;
                            }
                            Utils.showDialogPopUp(
                                context: context,
                                function: () {
                                  driverController.uploadOtherBag(
                                      context: context,
                                      status: widget.status,
                                      collectionId: widget.collectionId,
                                      image: currentImage!);
                                },
                                title: 'Finished Adding Bags');
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
