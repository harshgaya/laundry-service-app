import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/history/campus_employee_compare_daysheet.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../filter_page_campus_employee/filter_page_campus_employee.dart';

class CampusEmployeeSearchUntakenClothsFromWarehouse extends StatefulWidget {
  const CampusEmployeeSearchUntakenClothsFromWarehouse({super.key});

  @override
  State<CampusEmployeeSearchUntakenClothsFromWarehouse> createState() =>
      _CampusEmployeeSearchUntakenClothsFromWarehouseState();
}

class _CampusEmployeeSearchUntakenClothsFromWarehouseState
    extends State<CampusEmployeeSearchUntakenClothsFromWarehouse> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  final searchController = TextEditingController();
  Timer? _debounce;
  String? _selectedValue;
  List<CollectionUntakenClothData> filteredCloths = [];
  bool filterVisibility = false;
  bool tableVisible = true;

  @override
  void initState() {
    super.initState();
    campusEmployeeController.getCollege();

    //searchController.addListener(_filterCloths);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => campusEmployeeController.gettingCollege.value
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                size: 40,
                color: Colors.blue,
                secondRingColor: const Color(0xFF1A1A3F),
                thirdRingColor: const Color(0xFFEA3799),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search For Untaken Cloths',
                  textAlign: TextAlign.start,
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
                    Obx(
                      () => Container(
                        height: 60,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Text(
                                '${campusEmployeeController.collegeCampus.value?.data[0].campuses[0].tagName}')),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        // onChanged: (value) async {
                        //   // Cancel the previous debounce timer if it exists
                        //   if (_debounce?.isActive ?? false) {
                        //     _debounce!.cancel();
                        //   }
                        //
                        //   // Start a new debounce timer
                        //   _debounce = Timer(const Duration(milliseconds: 500), () async {
                        //     if (value.isEmpty) {
                        //       campusEmployeeController.searchData.value = [];
                        //       setState(() {
                        //         tableVisible = false;
                        //       });
                        //       return;
                        //     } else {
                        //       await campusEmployeeController.searchTag(
                        //         tag:
                        //         '${campusEmployeeController.collegeCampus.value?.data[0].campuses[0].tagName}$value',
                        //         campusId: campusEmployeeController
                        //             .collegeCampus.value!.data[0].campuses[0].uid,
                        //       );
                        //       setState(() {
                        //         tableVisible = true;
                        //       });
                        //     }
                        //   });
                        // },
                        onChanged: (value) async {
                          if (_debounce?.isActive ?? false) {
                            _debounce!.cancel();
                          }

                          _debounce = Timer(const Duration(milliseconds: 300),
                              () async {
                            if (value.isEmpty) {
                              campusEmployeeController.searchData.value = [];
                              setState(() {
                                tableVisible = false;
                              });
                              return;
                            } else {
                              await campusEmployeeController.searchTag(
                                tag:
                                    '${campusEmployeeController.collegeCampus.value?.data[0].campuses[0].tagName}$value',
                                campusId: campusEmployeeController.collegeCampus
                                    .value!.data[0].campuses[0].uid,
                              );
                              setState(() {
                                tableVisible = true;
                              });
                            }
                          });
                        },
                        controller: searchController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Search Tag No.',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // Visibility(
                //     visible: filterVisibility,
                //     child: InkWell(
                //       onTap: () async {
                //         final result = await Get.to(() => FilterWidget());
                //
                //         if (result != null && result.isNotEmpty) {
                //           filteredCloths = [];
                //           setState(() {});
                //           filteredCloths =
                //               campusEmployeeController.untakenCloths.where((cloth) {
                //             final collectionNoString = cloth.collectionNo;
                //             return result.contains(collectionNoString);
                //           }).toList();
                //           print('filter cloth ${filteredCloths.length}');
                //           setState(() {});
                //         }
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //           border: Border.all(color: Colors.grey),
                //           borderRadius: BorderRadius.circular(5),
                //         ),
                //         child: const Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Icon(Icons.compare_arrows),
                //             SizedBox(
                //               width: 10,
                //             ),
                //             Text('Filter'),
                //           ],
                //         ),
                //       ),
                //     )),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: tableVisible,
                  child: Obx(() => campusEmployeeController.searchingTag.value
                      ? Center(
                          child: LoadingAnimationWidget.discreteCircle(
                            size: 40,
                            color: Colors.blue,
                            secondRingColor: const Color(0xFF1A1A3F),
                            thirdRingColor: const Color(0xFFEA3799),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Table(
                              border: const TableBorder(
                                  horizontalInside: BorderSide(
                                      color: Colors.black, width: 0.2)),
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          'Collection No',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          'No of Untaken Cloths',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ...campusEmployeeController.searchData
                                    .map((order) {
                                  final totalCampusRegularCloths = order
                                      .studentDaySheet
                                      .where((element) =>
                                          element.delivered == false)
                                      .fold(
                                        0,
                                        (sum, student) =>
                                            sum + student.campusRegularCloths,
                                      );

                                  final totalCampusUniforms = order
                                      .studentDaySheet
                                      .where((element) =>
                                          element.delivered == false)
                                      .fold(
                                        0,
                                        (sum, student) =>
                                            sum + student.campusUniforms,
                                      );
                                  return TableRow(
                                    children: [
                                      TableCell(
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(
                                              () =>
                                                  CampusEmployeeCompareDaysheet(
                                                studentData: order
                                                    .studentDaySheet
                                                    .where((element) =>
                                                        element.delivered ==
                                                        false)
                                                    .toList(),
                                                facultyData: order
                                                    .facultyDaySheet
                                                    .where((element) =>
                                                        element.delivered ==
                                                        false)
                                                    .toList(),
                                                collectionId: order.uid!,
                                                isFromSearch: true,
                                                otherClothList: order
                                                    .otherClothDaySheet
                                                    .where((element) =>
                                                        element.delivered ==
                                                        false)
                                                    .toList(),
                                              ),
                                            );
                                            campusEmployeeController
                                                .searchData.value = [];
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              order.id.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(() =>
                                                CampusEmployeeCompareDaysheet(
                                                  studentData: order
                                                      .studentDaySheet
                                                      .where((element) =>
                                                          element.delivered ==
                                                          false)
                                                      .toList(),
                                                  facultyData: order
                                                      .facultyDaySheet
                                                      .where((element) =>
                                                          element.delivered ==
                                                          false)
                                                      .toList(),
                                                  collectionId: order.uid!,
                                                  isFromSearch: true,
                                                  otherClothList: order
                                                      .otherClothDaySheet
                                                      .where((element) =>
                                                          element.delivered ==
                                                          false)
                                                      .toList(),
                                                ));
                                            campusEmployeeController
                                                .searchData.value = [];
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              '${totalCampusRegularCloths + totalCampusUniforms}',
                                              style: const TextStyle(
                                                fontSize: 12,
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
                ),
              ],
            )),
    );
  }
}
