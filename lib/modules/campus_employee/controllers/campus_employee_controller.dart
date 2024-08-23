import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/campus_employee/models/college_campus_model.dart';
import 'package:laundry_service/modules/campus_employee/models/faculty_model.dart';
import 'package:laundry_service/modules/campus_employee/pages/create_collection_view.dart';
import 'package:laundry_service/network/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constatnts/sharedprefs.dart';
import '../../../network/network_api_services.dart';
import 'dart:io';

import '../../authentication/pages/user_state.dart';
import '../models/day_sheet_history.dart';

class CampusEmployeeController extends GetxController {
  RxString userId = ''.obs;
  RxString userName = ''.obs;
  RxString collegeName = 'Shri Chaitnaya'.obs;
  final _apiServices = NetworkApiServices();
  RxBool creatingCollection = false.obs;

  ///
  Rx<CollegeCampusModel?> collegeCampus = Rx<CollegeCampusModel?>(null);
  RxInt latestCollectionId = 0.obs;
  RxString selectedCampus = ''.obs;
  RxString selectedTag = ''.obs;
  RxString selectedCampusId = ''.obs;
  RxList<Faculty> facultyList = <Faculty>[].obs;
  Rx<EmployeeCollections?> employeeCollection = Rx<EmployeeCollections?>(null);
  RxBool loadingEmployeeCollectionHistory = false.obs;

  ///

  RxInt collectionNo = 1.obs;
  var orders = <Order>[].obs;
  var teacherOrders = <TeacherOrder>[].obs;
  var warehouseRemarks = <RemarksWarehouseData>[].obs;
  var remarkToWarehouse = <RemarkToWarehouse>[].obs;
  var untakenClothToWareHouse = <UntakenClothToWarehouse>[
    UntakenClothToWarehouse(tagNo: 23, totalCloths: 3, ticked: false),
    UntakenClothToWarehouse(tagNo: 6, totalCloths: 1, ticked: false),
    UntakenClothToWarehouse(tagNo: 7, totalCloths: 9, ticked: false),
    UntakenClothToWarehouse(tagNo: 12, totalCloths: 2, ticked: false),
  ].obs;
  var campusEmployeeOrdersFromWarehouse =
      <CampusEmployeeOrderFromWarehouseData>[
    CampusEmployeeOrderFromWarehouseData(
        collectionNo: 12,
        deliveryDate: '12-05-24',
        delivered: true,
        tagCount: 12,
        facultyCount: 2),
    CampusEmployeeOrderFromWarehouseData(
        collectionNo: 10,
        deliveryDate: '12-06-24',
        delivered: false,
        tagCount: 30,
        facultyCount: 10),
    CampusEmployeeOrderFromWarehouseData(
        collectionNo: 16,
        deliveryDate: '12-08-24',
        delivered: true,
        tagCount: 103,
        facultyCount: 34),
  ].obs;

  var campusEmployeeStudentDaySheetCompare =
      <CampusEmployeeStudentDaySheetCompareData>[
    CampusEmployeeStudentDaySheetCompareData(
        tagNo: '122', campusCount: 23, warehouseCount: 23, delivered: false),
    CampusEmployeeStudentDaySheetCompareData(
        tagNo: '132', campusCount: 10, warehouseCount: 10, delivered: false),
    CampusEmployeeStudentDaySheetCompareData(
        tagNo: '142', campusCount: 34, warehouseCount: 34, delivered: false),
  ].obs;

  var campusEmployeeFacultyDaySheetCompare =
      <CampusEmployeeFacultyDaySheetCompareData>[
    CampusEmployeeFacultyDaySheetCompareData(
        facultyName: 'SRi',
        campusCount: 23,
        warehouseCount: 23,
        delivered: false),
    CampusEmployeeFacultyDaySheetCompareData(
        facultyName: 'Raj',
        campusCount: 10,
        warehouseCount: 10,
        delivered: false),
    CampusEmployeeFacultyDaySheetCompareData(
        facultyName: 'Gupta',
        campusCount: 34,
        warehouseCount: 34,
        delivered: false),
  ].obs;

  var untakenCloths = <CollectionUntakenClothData>[
    CollectionUntakenClothData(
      collectionNo: 12,
      unTakenCloths: 2,
      tagNo: 23,
    ),
    CollectionUntakenClothData(
      collectionNo: 34,
      unTakenCloths: 5,
      tagNo: 13,
    ),
    CollectionUntakenClothData(
      collectionNo: 45,
      unTakenCloths: 9,
      tagNo: 2,
    ),
    CollectionUntakenClothData(
      collectionNo: 78,
      unTakenCloths: 67,
      tagNo: 5,
    ),
    CollectionUntakenClothData(
      collectionNo: 12,
      unTakenCloths: 1,
      tagNo: 7,
    ),
  ];

  // Add a new order to the list
  void addOrder(int tagNo, int cloths, int uniforms, BuildContext context) {
    int index = orders.indexWhere((order) => order.tagNo == tagNo);

    if (index != -1) {
      final tagController = TextEditingController();
      tagController.text = tagNo.toString();
      final totalClothController = TextEditingController();
      totalClothController.text = cloths.toString();
      final totalUniformController = TextEditingController();
      totalUniformController.text = uniforms.toString();
      Utils.showDialogPopUp(
          context: context,
          function: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: tagController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration:
                                const InputDecoration(label: Text('Tag No')),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: totalClothController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                                label: Text('Regular Cloth')),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: totalUniformController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration:
                                const InputDecoration(label: Text('Uniforms')),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () {
                                orders[index].tagNo =
                                    int.parse(tagController.text);
                                orders[index].totalCloths =
                                    int.parse(totalClothController.text);
                                orders[index].totalUniforms =
                                    int.parse(totalUniformController.text);
                                orders.refresh();
                                Get.back();
                              },
                              child: const Text(
                                'Replace',
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  );
                });
          },
          title: 'Tag No $tagNo is already added? do you want to replace?');
    } else {
      // Add a new order if tagNo doesn't exist
      orders.add(Order(
        tagNo: tagNo,
        totalCloths: cloths,
        totalUniforms: uniforms,
        remarks: '',
      ));
      orders.sort((a, b) => a.tagNo.compareTo(b.tagNo));
    }
  }

  void addRemarkToWareHouse(int tagNo, String remarks) {
    remarkToWarehouse.add(RemarkToWarehouse(tagNo: tagNo, remarks: remarks));
  }

  void addOrUpdateTeacherOrder(TeacherOrder newOrder) {
    print('teacher ${newOrder.teacherName}');
    final index = teacherOrders
        .indexWhere((order) => order.teacherName == newOrder.teacherName);

    if (index != -1) {
      // Update existing order
      teacherOrders[index] = newOrder;
    } else {
      // Add new order
      teacherOrders.add(newOrder);
    }
  }

  Map<String, int> calculateTotalClothesPerTeacher() {
    Map<String, int> totals = {};

    for (var order in teacherOrders) {
      if (!totals.containsKey(order.teacherName)) {
        totals[order.teacherName] = 0;
      }

      totals[order.teacherName] =
          (totals[order.teacherName] ?? 0) + order.totalCloths;
    }

    return totals;
  }

  Future<void> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(SharedPreferenceKey.UserId) ?? '';
    String college =
        sharedPreferences.getString(SharedPreferenceKey.collegeName) ?? '';
    userId.value = id;
    collegeName.value = college;
  }

  Future<void> createCollectionNo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(SharedPreferenceKey.UserId) ?? '';
    String college =
        sharedPreferences.getString(SharedPreferenceKey.collegeName) ?? '';
    try {
      creatingCollection.value = true;
      var data = {
        "collegeName": collegeName.value,
        "createdBy": id,
      };
      var response =
          await _apiServices.postApi(data, UrlConstants.createCollectionNo);
      collectionNo.value = response['data'][0]['collectionNo'];
      Get.to(() => const CreateCollectionView());

      creatingCollection.value = false;
    } catch (e) {
      creatingCollection.value = false;
    }
  }

  Future<void> getCollege() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response =
          await _apiServices.getApi('${UrlConstants.getCampus}/$userId');
      CollegeCampusModel collegeCampusModel =
          CollegeCampusModel.fromJson(response);
      collegeCampus.value = collegeCampusModel;
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> getEmployeeCollectionHistory() async {
    try {
      loadingEmployeeCollectionHistory.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response = await _apiServices
          .getApi('${UrlConstants.getEmployeeCollectionHistory}/$userId/');

      EmployeeCollections employeeCollections =
          EmployeeCollections.fromJson(response);
      employeeCollection.value = employeeCollections;
      loadingEmployeeCollectionHistory.value = false;
    } catch (e) {
      loadingEmployeeCollectionHistory.value = false;
      print('error $e');
    }
  }

  Future<void> getLatestCollectionId() async {
    try {
      var response =
          await _apiServices.getApi(UrlConstants.getLatestCollectionId);
      latestCollectionId.value = response['latest_collection_id'];
    } catch (e) {
      print('error $e');
    }
  }

  Future<bool> searchTag({required String tag}) async {
    try {
      var data = {
        "tag_number": "${selectedTag.value}$tag",
        "campus_uid": selectedCampusId.value,
      };
      var response = await _apiServices.postApi(data, UrlConstants.searchTag);
      return true;
    } catch (e) {
      print('error $e');
      return false;
    }
  }

  Future<void> getFacultyList() async {
    try {
      var response = await _apiServices
          .getApi('${UrlConstants.getFacultyList}/${selectedCampusId.value}');
      FacultyListModel facultyListModel = FacultyListModel.fromJson(response);
      facultyList.addAll(facultyListModel.data);
    } catch (e) {}
  }

  Future<void> getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? name = sharedPreferences.getString(SharedPreferenceKey.name);
    userName.value = name ?? '';
  }

  Future<void> uploadDaySheet(
      {required List<File> files, required BuildContext context}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);

      var data = {
        "campus_uid": selectedCampusId.value,
        "supervisor_uid": userId ?? '',
        "total_cloths": orders.fold(0, (sum, order) => sum + order.totalCloths),
        "total_uniforms":
            orders.fold(0, (sum, order) => sum + order.totalUniforms),
        "student_day_sheet": orders.map((order) => order.toJson()).toList(),
        "faculty_day_sheet":
            teacherOrders.map((element) => element.toJson()).toList(),
        "daily_image_sheet":
            files.map((e) => Utils.encodeFileToBase64(e)).toList()
      };

      var response =
          await _apiServices.postApi(data, UrlConstants.uploadDaySheet);
      orders.value = [];
      facultyList.value = [];
      Get.to(() => const UserState());
      Utils.showDialogPopUp(
          context: context, function: () {}, title: 'Collection uploaded!');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserName();
  }
}

class Order {
  int tagNo;
  int totalCloths;
  int totalUniforms;
  String remarks = '';
  int? missing = 0;
  int? extra = 0;

  Order(
      {required this.tagNo,
      this.missing,
      this.extra,
      required this.totalUniforms,
      required this.remarks,
      required this.totalCloths});
  Map<String, dynamic> toJson() {
    return {
      'tag_number': tagNo.toString(),
      'campus_regular_cloths': totalCloths,
      'campus_regular_uniforms': totalUniforms,
    };
  }
}

class TeacherOrder {
  int totalCloths;
  String teacherName;

  TeacherOrder({
    required this.teacherName,
    required this.totalCloths,
  });
  Map<String, dynamic> toJson() {
    return {'faculty_name': teacherName, 'total_clth': totalCloths.toString()};
  }
}

class RemarksWarehouseData {
  int collectionId;
  String deliveryTime;
  String remarks;

  RemarksWarehouseData({
    required this.collectionId,
    required this.deliveryTime,
    required this.remarks,
  });
}

class RemarkToWarehouse {
  int tagNo;
  String remarks;

  RemarkToWarehouse({
    required this.tagNo,
    required this.remarks,
  });
}

class UntakenClothToWarehouse {
  int tagNo;
  int totalCloths;
  bool ticked;

  UntakenClothToWarehouse({
    required this.ticked,
    required this.tagNo,
    required this.totalCloths,
  });
}

class CampusEmployeeOrderFromWarehouseData {
  int collectionNo;
  String deliveryDate;
  bool delivered;
  int tagCount;
  int facultyCount;

  CampusEmployeeOrderFromWarehouseData({
    required this.tagCount,
    required this.facultyCount,
    required this.collectionNo,
    required this.deliveryDate,
    required this.delivered,
  });
}

class CampusEmployeeStudentDaySheetCompareData {
  String tagNo;
  int campusCount;
  int warehouseCount;
  bool delivered;

  CampusEmployeeStudentDaySheetCompareData({
    required this.tagNo,
    required this.campusCount,
    required this.warehouseCount,
    required this.delivered,
  });
}

class CampusEmployeeFacultyDaySheetCompareData {
  String facultyName;
  int campusCount;
  int warehouseCount;
  bool delivered;

  CampusEmployeeFacultyDaySheetCompareData({
    required this.facultyName,
    required this.campusCount,
    required this.warehouseCount,
    required this.delivered,
  });
}

class CollectionUntakenClothData {
  int collectionNo;
  int unTakenCloths;
  int tagNo;
  CollectionUntakenClothData({
    required this.tagNo,
    required this.collectionNo,
    required this.unTakenCloths,
  });
}
