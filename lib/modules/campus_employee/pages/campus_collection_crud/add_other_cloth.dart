import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/modules/campus_employee/models/day_sheet_history.dart';

import '../../../../helpers/utils.dart';
import '../../../widegets/round_button_animate.dart';
import '../../controllers/campus_employee_controller.dart';
import 'final_count_page.dart';

class AddOtherCloth extends StatefulWidget {
  const AddOtherCloth({super.key});

  @override
  State<AddOtherCloth> createState() => _AddOtherClothState();
}

class _AddOtherClothState extends State<AddOtherCloth> {
  final clothController = TextEditingController();
  String? selectedClothType;
  List<String> otherCloth = [
    'Bed Sheets',
    'Pillow Covers',
    'Bed Covers',
    'Quilts/Duvets',
    'Table clothes',
    'Table Runners',
    'Dish Towels',
    'Aprons',
    'Pot Holders/ Oven Mitts',
    'Curtains',
    'Cushion Covers',
    'Table Mats',
    'Tapestries',
    'Wall Hangings',
    'Rugs and Carpets',
    'Bath Towels',
    'Face Towels',
    'Bath Mats',
    'Puja Mats',
  ];
  final formKey = GlobalKey<FormState>();
  final campusEmployeeController = Get.put(CampusEmployeeController());
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Select Cloth Type',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.blue,
                ),
                value: selectedClothType,
                onChanged: (String? newValue) {
                  if (newValue == null) {
                    return;
                  }
                  setState(() {
                    selectedClothType = newValue;
                  });
                },
                dropdownColor: Colors.blue,
                items: otherCloth.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              if (selectedClothType != null)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLength: 2,
                        controller: clothController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter total clothes';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                          hintText: 'Enter Total Clothes',
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
                                .addOtherCloth(OtherClothDaySheet(
                              name: selectedClothType!,
                              delivered: false,
                              noOfItems: int.parse(clothController.text),
                              uid: '',
                            ));
                            setState(() {
                              clothController.clear();
                              selectedClothType = null;
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
                                  'TOTAL CLOTHES',
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
                      ...campusEmployeeController.otherClothList
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
                                    order.value.name,
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
                                    '${order.value.noOfItems}',
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
                                  '${campusEmployeeController.otherClothList.length}',
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
                                  '${campusEmployeeController.otherClothList.fold(0, (sum, order) => sum + order.noOfItems)}',
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
              if (selectedClothType == null)
                Obx(() => Align(
                      alignment: Alignment.center,
                      child: RoundButtonAnimate(
                        buttonName:
                            campusEmployeeController.otherClothList.isEmpty
                                ? 'Skip'
                                : 'Finish',
                        onClick: () {
                          Utils.showDialogPopUp(
                              context: context,
                              function: () {
                                Get.to(() => const FinalCountPage());
                              },
                              title: 'Finished Adding other Clothes');
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
