import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'dart:io';

import '../../../../helpers/utils.dart';

class DriverExpensed extends StatefulWidget {
  const DriverExpensed({super.key});

  @override
  State<DriverExpensed> createState() => _DriverExpensedState();
}

class _DriverExpensedState extends State<DriverExpensed> {
  String? selectedExpense;
  final expenseAmountController = TextEditingController();
  List<String> expenses = ['Fuel', 'Air', 'Punchure', 'Other'];
  final formKey = GlobalKey<FormState>();
  File? _image;
  final dialogTextController = TextEditingController();
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
              Text(
                'Add Expense',
                style: GoogleFonts.roboto(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      onChanged: (String? newValue) {
                        if (newValue == 'Other') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Enter Expense Name'),
                                content: TextFormField(
                                  controller: dialogTextController,
                                  decoration: InputDecoration(
                                    labelText: 'Expense',
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
                        } else {
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Expense',
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.blue,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please select college';
                        }
                        return null;
                      },
                      value: selectedExpense,
                      dropdownColor: Colors.blue,
                      items: expenses
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
                      controller: expenseAmountController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Amount', // Optional label text
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your expense';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _image == null
                  ? InkWell(
                      onTap: () async {
                        _image = await Utils.captureImage();
                        setState(() {});
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.camera_alt,
                          size: 120,
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        _image = await Utils.captureImage();
                        setState(() {});
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.file(
                          _image!,
                          height: 120,
                        ),
                      )),
              const Spacer(),
              InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                  }
                  if (_image == null) {
                    Utils.showScaffoldMessageI(
                        context: context, title: 'Please select image');
                  } else {
                    // Get.to(() => VehicleInspectionRightSide());
                  }
                },
                child: Align(
                  alignment: Alignment.center,
                  child: RoundButtonAnimate(
                    buttonName: 'done',
                    onClick: () {
                      Get.back();
                    },
                    image: Icon(
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
