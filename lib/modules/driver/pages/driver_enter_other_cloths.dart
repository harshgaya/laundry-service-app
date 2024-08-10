import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../../authentication/pages/user_state.dart';
import '../controllers/driver_controller.dart';
import 'dart:io';

class DriverEnterOtherCloths extends StatefulWidget {
  const DriverEnterOtherCloths({super.key});

  @override
  State<DriverEnterOtherCloths> createState() => _DriverEnterOtherClothsState();
}

class _DriverEnterOtherClothsState extends State<DriverEnterOtherCloths> {
  final driverController = Get.put(DriverController());
  final piecesController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? selectClothType;
  List<String> otherClothType = [
    'Bedhsheet',
    'Pillow Cover',
    'Towel',
  ];
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
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Other Cloths',
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
                        hintText: 'Select Type',
                        hintStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.blue,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please select cloth type';
                        }
                        return null;
                      },
                      value: selectClothType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectClothType = newValue;
                        });
                      },
                      dropdownColor: Colors.blue,
                      items: otherClothType
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
                      controller: piecesController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Enter total piece';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Enter total piece',
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
                        driverController.addOrUpdateOtherCloth(OtherClothData(
                            type: selectClothType!,
                            noOfPiece: piecesController.text));
                        setState(() {
                          selectClothType = null;
                          piecesController.text = '';
                        });
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
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Cloth Type',
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
                                    'Total Piece',
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
                          ...driverController.otherClothList
                              .asMap()
                              .entries
                              .map((order) {
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      order.value.type,
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
                                      '${order.value.noOfPiece}',
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
                height: 20,
              ),
              _image == null
                  ? InkWell(
                      onTap: _captureImage,
                      child: Align(
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
              Align(
                alignment: Alignment.center,
                child: RoundButtonAnimate(
                  buttonName: 'Finish',
                  onClick: () {
                    Utils.showDialogPopUp(
                        context: context,
                        function: () {
                          driverController.otherClothList.value = [];
                          Get.offAll(() => UserState());
                        },
                        title: 'Finished Adding Other cloths');
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
