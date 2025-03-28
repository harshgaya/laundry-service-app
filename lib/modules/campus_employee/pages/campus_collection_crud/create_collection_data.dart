import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_collection_crud/faculty_cloths.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CreateCollectionData extends StatefulWidget {
  const CreateCollectionData({super.key});

  @override
  State<CreateCollectionData> createState() => _CreateCollectionDataState();
}

class _CreateCollectionDataState extends State<CreateCollectionData> {
  final TextEditingController tagController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final totalCloths = TextEditingController();
  final totalUniforms = TextEditingController();
  final campusEmployeeController = Get.put(CampusEmployeeController());
  bool enterClothVisible = false;
  final formKey = GlobalKey<FormState>();
  final FocusNode _secondFocusNode = FocusNode();
  final FocusNode _thirdFocusNode = FocusNode();
  final FocusNode _firstFocusNode = FocusNode();
  bool finishButtonVisible = false;
  bool doneButtonVisible = true;
  bool tagNoVisible = true;
  bool cancelButtonVisible = false;

  final campuseEmployeeController = Get.put(CampusEmployeeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    campuseEmployeeController.getCampusDetails(
        campusId: campuseEmployeeController.selectedCampusId.value);
    campusEmployeeController.getFacultyList();
    tagController.addListener(() {
      if (tagController.text.isEmpty) {}
      if (tagController.text.length >= 3 &&
          tagController.text.length <=
              campuseEmployeeController.maxStudentCount.value
                  .toString()
                  .length) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (tagController.text.length >= 3 &&
              tagController.text.length <=
                  campuseEmployeeController.maxStudentCount.value
                      .toString()
                      .length) {
            _secondFocusNode.requestFocus();
            setState(() {
              enterClothVisible = true;
            });
          }
        });
      }
    });
    totalCloths.addListener(() {
      if (totalCloths.text.length == 2 &&
          campusEmployeeController.isUniform.value) {
        _thirdFocusNode.requestFocus();
      }
      if (totalCloths.text.length == 2 &&
          campusEmployeeController.isUniform.value) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    tagController.dispose();
    _secondFocusNode.dispose();
    super.dispose();
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
      body: Obx(() => campusEmployeeController.gettingCampusDetails.value
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 40,
                  color: Colors.blue,
                  secondRingColor: const Color(0xFF1A1A3F),
                  thirdRingColor: const Color(0xFFEA3799)),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New Collection',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: tagNoVisible,
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Obx(() => Text(
                                  campuseEmployeeController.selectedTag.value)),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: _firstFocusNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: tagController,
                              onChanged: (value) async {
                                if (value.isEmpty) {
                                  setState(() {
                                    enterClothVisible = false;
                                  });
                                } else {
                                  // int enteredValue = int.tryParse(value) ?? 0;
                                  // if (enteredValue >= 101 &&
                                  //     enteredValue <=
                                  //         campuseEmployeeController
                                  //             .maxStudentCount.value) {
                                  //   _secondFocusNode.requestFocus();
                                  //   setState(() {
                                  //     enterClothVisible = true;
                                  //   });
                                  //
                                  // }
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Enter Tag No',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                hintStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: enterClothVisible,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Form(
                          key: formKey,
                          child: SizedBox(
                            width: Get.width,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        focusNode: _secondFocusNode,
                                        maxLength: 2,
                                        controller: totalCloths,
                                        keyboardType: TextInputType.number,
                                        onFieldSubmitted: (val) {
                                          if (campusEmployeeController
                                              .isUniform.value) {
                                            return;
                                          }
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            campusEmployeeController.addOrder(
                                                int.parse(tagController.text),
                                                int.parse(totalCloths.text),
                                                0,
                                                context);
                                            campusEmployeeController.orders
                                                .sort((a, b) =>
                                                    a.tagNo.compareTo(b.tagNo));
                                            campusEmployeeController.orders
                                                .refresh();

                                            tagController.text = '';
                                            totalCloths.text = '';
                                            // enterClothVisible = false;
                                            _firstFocusNode.requestFocus();
                                            setState(() {
                                              enterClothVisible = false;
                                            });
                                          }
                                        },
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
                                    if (campusEmployeeController
                                        .isUniform.value)
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    if (campusEmployeeController
                                        .isUniform.value)
                                      Expanded(
                                        child: TextFormField(
                                          focusNode: _thirdFocusNode,
                                          controller: totalUniforms,
                                          maxLength: 2,
                                          onFieldSubmitted: (val) {
                                            if (formKey.currentState!
                                                .validate()) {
                                              formKey.currentState!.save();
                                              campusEmployeeController.addOrder(
                                                  int.parse(tagController.text),
                                                  int.parse(totalCloths.text),
                                                  int.parse(totalUniforms.text),
                                                  context);
                                              campusEmployeeController.orders
                                                  .sort((a, b) => a.tagNo
                                                      .compareTo(b.tagNo));
                                              campusEmployeeController.orders
                                                  .refresh();

                                              tagController.text = '';
                                              totalCloths.text = '';
                                              totalUniforms.text = '';
                                              // enterClothVisible = false;
                                              _firstFocusNode.requestFocus();
                                              setState(() {
                                                enterClothVisible = false;
                                              });
                                            }
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Enter total uniforms';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: const InputDecoration(
                                            hintText: 'Enter Total Uniforms',
                                            counterText: '',
                                            border: OutlineInputBorder(),
                                            hintStyle: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
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
                    Obx(
                      () => SingleChildScrollView(
                        child: Table(
                          border: const TableBorder(
                            horizontalInside:
                                BorderSide(color: Colors.black, width: 0.2),
                          ),
                          children: [
                            // Table header
                            TableRow(
                              children: [
                                TableCell(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Text(
                                        'TAG NO.',
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
                                        'REGULAR CLOTHES',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (campusEmployeeController.isUniform.value)
                                  TableCell(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          'UNIFORMS',
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
                            ...campusEmployeeController.orders
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
                                          order.value.tagNo.toString(),
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
                                  if (campusEmployeeController.isUniform.value)
                                    TableCell(
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            '${order.value.totalUniforms}',
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
                                        '${campusEmployeeController.orders.length}',
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
                                        '${campusEmployeeController.orders.fold(0, (sum, order) => sum + order.totalCloths)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (campusEmployeeController.isUniform.value)
                                  TableCell(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '${campusEmployeeController.orders.fold(0, (sum, order) => sum + order.totalUniforms)}',
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
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: doneButtonVisible,
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                finishButtonVisible = true;
                                doneButtonVisible = false;
                                tagNoVisible = false;
                                enterClothVisible = false;
                                cancelButtonVisible = true;
                              });
                            },
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: cancelButtonVisible,
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      finishButtonVisible = false;
                      doneButtonVisible = true;
                      tagNoVisible = true;
                      enterClothVisible = true;
                      cancelButtonVisible = false;
                    });
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: finishButtonVisible,
            child: RoundButtonAnimate(
              buttonName: 'Finish',
              onClick: () {
                Utils.showDialogPopUp(
                    context: context,
                    function: () {
                      Get.to(() => const FacultyCloth());
                    },
                    title: 'Finished Adding Cloth');
              },
              image: const Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
