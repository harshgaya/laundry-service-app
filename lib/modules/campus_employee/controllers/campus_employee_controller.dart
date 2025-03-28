import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/campus_employee/models/college_campus_model.dart';
import 'package:laundry_service/modules/campus_employee/models/faculty_model.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_collection_crud/create_collection_view.dart';
import 'package:laundry_service/network/url_constants.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constatnts/sharedprefs.dart';
import '../../../network/network_api_services.dart';
import 'dart:io';

import '../../authentication/pages/user_state.dart';
import '../models/day_sheet_history.dart';

class CampusEmployeeController extends GetxController {
  RxString userId = ''.obs;
  RxString userName = ''.obs;
  RxString mobileNumber = ''.obs;
  RxString collegeName = ''.obs;
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
  RxInt toDo = 0.obs;
  RxInt open = 0.obs;
  RxInt finished = 0.obs;

  RxBool isUniform = false.obs;
  RxInt maxStudentCount = 0.obs;
  RxBool gettingCampusDetails = false.obs;
  RxBool uploadingDaySheet = false.obs;
  RxBool uploadingStudentRemark = false.obs;
  RxBool updatingDeliveryDaySheet = false.obs;
  RxBool gettingCollege = false.obs;
  RxBool updatingUntakenCloth = false.obs;
  RxBool searchingTag = false.obs;
  RxList<OtherClothDaySheet> otherClothList = <OtherClothDaySheet>[].obs;

  ///active inactive
  RxBool gettingActiveCollection = false.obs;
  Rx<EmployeeCollections?> activeCollection = Rx<EmployeeCollections?>(null);
  Rx<EmployeeCollections?> inActiveCollection = Rx<EmployeeCollections?>(null);

  ///active inactive

  ///search

  RxList<EmployeeData> searchData = <EmployeeData>[].obs;

  ///search

  ///

  RxInt collectionNo = 1.obs;
  var orders = <Order>[].obs;
  var teacherOrders = <TeacherOrder>[].obs;
  var warehouseRemarks = <RemarksWarehouseData>[].obs;
  var remarkToWarehouse = <RemarkToWarehouse>[].obs;
  var studentRemarks = <StudentRemark>[].obs;

  void addOrder(int tagNo, int cloths, int uniforms, BuildContext context) {
    int index = orders.indexWhere((order) => order.tagNo == tagNo);

    if (index != -1) {
      final order = orders[index];

      final tagController = TextEditingController();
      tagController.text = tagNo.toString();
      final totalClothController = TextEditingController();
      totalClothController.text = order.totalCloths.toString();
      final totalUniformController = TextEditingController();
      totalUniformController.text = order.totalUniforms.toString();
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
                          if (isUniform.value)
                            TextFormField(
                              controller: totalUniformController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                  label: Text('Uniforms')),
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
                                    int.tryParse(totalUniformController.text) ??
                                        0;
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

  void addRemarkToWareHouse(
      String tagNo, String remarks, bool status, String resolution) {
    // remarkToWarehouse.add(RemarkToWarehouse(tagNo: tagNo, remarks: remarks));
    studentRemarks.add(StudentRemark(
      tagNumber: tagNo,
      remark: remarks,
      remarkStatus: status,
      resolution: resolution,
    ));
    print('added');
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

  void addOtherCloth(OtherClothDaySheet otherCloth) {
    final index =
        otherClothList.indexWhere((order) => order.name == otherCloth.name);

    if (index != -1) {
      otherClothList[index] = otherCloth;
    } else {
      otherClothList.add(otherCloth);
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
    String mobile =
        sharedPreferences.getString(SharedPreferenceKey.mobile) ?? '';
    String? name = sharedPreferences.getString(SharedPreferenceKey.name);
    userName.value = name ?? '';
    mobileNumber.value = mobile;
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
      gettingCollege.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response =
          await _apiServices.getApi('${UrlConstants.getCampus}/$userId');
      CollegeCampusModel collegeCampusModel =
          CollegeCampusModel.fromJson(response);
      collegeCampus.value = collegeCampusModel;
      gettingCollege.value = false;
    } catch (e) {
      gettingCollege.value = false;
      print('error $e');
    }
  }

  ///active inactive
  Future<void> getActiveCollections() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response = await _apiServices
          .getApi('${UrlConstants.getActiveCollection}/$userId/');
      activeCollection.value = null;
      EmployeeCollections employeeCollections =
          EmployeeCollections.fromJson(response, 'active_tasks');
      activeCollection.value = employeeCollections;
      // finished.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'READY_TO_PICK')
      //     .length; //
      // toDo.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'DELIVERED_TO_CAMPUS')
      //     .length;
      // open.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == null)
      //     .length;

      activeCollection.value?.data
          .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> getInActiveCollections() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response = await _apiServices
          .getApi('${UrlConstants.getInActiveCollection}/$userId/');
      inActiveCollection.value = null;
      EmployeeCollections employeeCollections =
          EmployeeCollections.fromJson(response, 'inactive_tasks');
      inActiveCollection.value = employeeCollections;
      activeCollection.value?.data.addAll(inActiveCollection.value!.data);
      activeCollection.refresh();
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> loadActiveInactive() async {
    try {
      if (gettingActiveCollection.value) return;
      gettingActiveCollection.value = true;
      await Future.wait([getActiveCollections(), getInActiveCollections()]);
      gettingActiveCollection.value = false;
    } catch (e) {
      gettingActiveCollection.value = true;
    }
  }

  ///active inactive

  Future<void> getEmployeeCollectionHistory() async {
    try {
      if (loadingEmployeeCollectionHistory.value) return;
      loadingEmployeeCollectionHistory.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response = await _apiServices
          .getApi('${UrlConstants.getEmployeeCollectionHistory}/$userId/');

      EmployeeCollections employeeCollections =
          EmployeeCollections.fromJson(response, 'data');
      employeeCollection.value = employeeCollections;
      finished.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'READY_TO_PICK')
          .length; //
      toDo.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'DELIVERED_TO_CAMPUS')
          .length;
      open.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == null)
          .length;
      loadingEmployeeCollectionHistory.value = false;
      employeeCollection.value?.data
          .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } catch (e) {
      loadingEmployeeCollectionHistory.value = false;
      print('error $e');
    }
  }

  Future<void> getLatestCollectionId() async {
    try {
      var response =
          await _apiServices.getApi(UrlConstants.getLatestCollectionId);
      latestCollectionId.value = response['latest_collection_id'] + 1;
    } catch (e) {
      print('error $e');
    }
  }

  Future<bool> searchTag(
      {required String tag, required String campusId}) async {
    try {
      searchingTag.value = true;
      searchData.value = [];
      var data = {
        "tag_number": tag,
        "campus_uid": campusId,
      };
      var response = await _apiServices.postApi(data, UrlConstants.searchTag);
      searchData.value = [];
      List<EmployeeData> employeeData = (response['collections'] as List)
          .map((data) => EmployeeData.fromJson(data))
          .toList();
      searchData.addAll(employeeData);
      searchingTag.value = false;
      return true;
    } catch (e) {
      searchingTag.value = false;
      return false;
    }
  }

  Future<void> getFacultyList() async {
    try {
      facultyList.value = [];
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

  Future<void> uploadImages({
    required List<File> images,
    required BuildContext context,
  }) async {
    uploadingDaySheet.value = true;
    String totalCloths =
        orders.fold(0, (sum, order) => sum + order.totalCloths).toString();
    String totalUniforms =
        orders.fold(0, (sum, order) => sum + order.totalUniforms).toString();

    final Uri url = Uri.parse('${UrlConstants.BASE_URL}college/collection/');

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);

    var request = http.MultipartRequest('POST', url);

    request.fields['campus_uid'] = selectedCampusId.value;
    request.fields['supervisor_uid'] = userId ?? '';
    request.fields['total_cloths'] = totalCloths;
    request.fields['total_uniforms'] = totalUniforms;
    request.fields['current_status'] = "READY_TO_PICK";
    request.fields['student_day_sheet'] = jsonEncode(orders.map((order) {
      var updatedOrder = order.toJson();
      updatedOrder['tag_number'] =
          '${selectedTag.value}${updatedOrder['tag_number']}';
      return updatedOrder;
    }).toList());
    request.fields['faculty_day_sheet'] =
        jsonEncode(teacherOrders.map((element) => element.toJson()).toList());
    request.fields['other_cloth_daysheet'] =
        jsonEncode(otherClothList.map((element) => element.toJson()).toList());
    var logger = Logger();
    logger.d(
        'other cloth ${otherClothList.map((element) => element.toJson()).toList()}');

    for (var image in images) {
      try {
        var multipartFile = await http.MultipartFile.fromPath(
          'daily_image_sheet',
          image.path,
          filename: basename(image.path),
        );
        request.files.add(multipartFile);
      } catch (e) {
        print('Error adding file: $e');
      }
    }

    try {
      var response = await request.send();
      String responseData = await response.stream.bytesToString();
      logger.d(
        'Response: $responseData',
      );
      uploadingDaySheet.value = false;

      // Handle the response
      if (response.statusCode == 201) {
        orders.value = [];
        facultyList.value = [];
        otherClothList.value = [];
        Get.to(() => const UserState());
        Utils.showDialogPopUp(
          context: context,
          function: () {},
          title: 'Collection uploaded!',
        );
      } else {
        print('Failed to upload. Status code: ${response.statusCode}');
      }
    } catch (e) {
      uploadingDaySheet.value = false;
      print('Error occurred: $e'); // Handle request errors
    }
  }

  Future<void> getCampusDetails({required String campusId}) async {
    try {
      gettingCampusDetails.value = true;
      var response = await _apiServices
          .getApi('${UrlConstants.getCampusDetails}$campusId/');
      maxStudentCount.value = response['max_student_count'] ?? 0;
      isUniform.value = response['uniform'] ?? false;
      gettingCampusDetails.value = false;
    } catch (e) {
      gettingCampusDetails.value = false;
    }
  }

  Future<void> uploadStudentRemarks(
      {required String collectionId,
      required String tagId,
      required List<StudentRemark> list,
      required BuildContext context}) async {
    try {
      if (list.isEmpty) {
        Navigator.of(context).pop();
        return;
      }
      uploadingStudentRemark.value = true;
      List<Map<String, dynamic>> remarksData = list.map((element) {
        return {
          'tag_number': '${element.tagNumber}',
          'remark': element.remark,
        };
      }).toList();
      var data = {'student_remark': jsonEncode(remarksData)};

      var response = await _apiServices.patchApi(
          data, '${UrlConstants.uploadRemarksByCampusEmployee}$collectionId/');
      final item = employeeCollection.value?.data
          .firstWhereOrNull((element) => element.uid == collectionId);
      if (item != null) {
        item.studentRemarks.clear();
        item.studentRemarks.addAll(studentRemarks);
      }
      employeeCollection.refresh();
      uploadingStudentRemark.value = false;
      // remarkToWarehouse.value = [];
      Navigator.of(context).pop();
      Utils.showScaffoldMessageI(context: context, title: 'Remarks added');
    } catch (e) {
      uploadingStudentRemark.value = false;
    }
  }

  Future<void> updateDeliveryDaySheet(
      {required String collectionId,
      required List<StudentDaySheet> student,
      required List<FacultyDaySheet> faculty,
      required bool fromSearch,
      required List<OtherClothDaySheet> otherClothData,
      required BuildContext context}) async {
    try {
      updatingDeliveryDaySheet.value = true;
      List<Map<String, dynamic>> studentDay = student.map((element) {
        return {
          'uid': element.uid!,
          'tag_number': element.tagNumber,
          'campus_regular_cloths': element.campusRegularCloths,
          'campus_regular_uniforms': element.campusUniforms,
          'ware_house_regular_cloths': element.wareHouseRegularCloths,
          'ware_house_uniform': element.wareHouseUniform,
          'delivered': true
        };
      }).toList();
      List<Map<String, dynamic>> facultyDay = faculty.map((element) {
        return {
          'uid': element.uid!,
          'faculty': element.faculty!['name'],
          'regular_cloths': element.regularCloths,
          'ware_house_regular_cloths': element.wareHouseRegularCloths,
          'delivered': true,
          'faculty_uid': element.faculty!['uid'],
        };
      }).toList();
      List<Map<String, dynamic>> otherCloth = otherClothData.map((element) {
        return {
          'uid': element.uid,
          'name': element.name,
          'number_of_items': element.noOfItems,
          'delivered': true,
        };
      }).toList();
      var data = {};
      print('fromsearch $fromSearch');
      if (fromSearch) {
        data = {
          'student_day_sheet': jsonEncode(studentDay),
          'faculty_day_sheet': jsonEncode(facultyDay),
          'other_cloth_daysheet': jsonEncode(otherCloth)
        };
      } else {
        data = {
          'student_day_sheet': jsonEncode(studentDay),
          'faculty_day_sheet': jsonEncode(facultyDay),
          'other_cloth_daysheet': jsonEncode(otherCloth),
          'current_status': 'DELIVERED_TO_STUDENT',
        };
      }
      var response = await _apiServices.patchApi(
          data, '${UrlConstants.uploadRemarksByCampusEmployee}$collectionId/');

      if (!fromSearch) {
        final data2 = activeCollection.value!.data
            .firstWhere((element) => element.uid == collectionId);
        data2.currentStatus = 'DELIVERED_TO_STUDENT';
        activeCollection.refresh();
      }

      updatingDeliveryDaySheet.value = false;
      Utils.showScaffoldMessageI(context: context, title: 'Updated');
      Navigator.of(context).pop();
    } catch (e) {
      print('error $e');
      updatingDeliveryDaySheet.value = false;
    }
  }

  Future<void> updateUntakenCloth(
      {required String collectionId,
      required List<StudentDaySheet> student,
      required BuildContext context}) async {
    try {
      updatingUntakenCloth.value = true;
      List<Map<String, dynamic>> studentDay = student.map((element) {
        return {
          'uid': element.uid,
          'tag_number': element.tagNumber,
          'campus_regular_cloths': element.campusRegularCloths,
          'campus_regular_uniforms': element.campusUniforms,
          'ware_house_regular_cloths': element.wareHouseRegularCloths,
          'ware_house_uniform': element.wareHouseUniform,
          'delivered': true
        };
      }).toList();

      var data = {
        'student_day_sheet': jsonEncode(studentDay),
      };

      var response = await _apiServices.patchApi(
          data, '${UrlConstants.uploadRemarksByCampusEmployee}$collectionId/');
      final item = employeeCollection.value?.data
          .firstWhereOrNull((element) => element.uid == collectionId);
      if (item != null) {
        item.studentDaySheet.forEach((daySheet) {
          final matchingStudent =
              student.firstWhereOrNull((s) => s.uid == daySheet.uid);
          if (matchingStudent != null) {
            daySheet.delivered = true;
          }
        });
      }
      employeeCollection.refresh();
      updatingUntakenCloth.value = false;
      Utils.showScaffoldMessageI(context: context, title: 'Updated');
      Navigator.of(context).pop();
    } catch (e) {
      print('error $e');
      updatingUntakenCloth.value = false;
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
      "ware_house_regular_cloths": 0,
      "ware_house_uniform": 0,
      "delivered": false
    };
  }
}

class TeacherOrder {
  int totalCloths;
  String teacherName;
  String teacherId;

  TeacherOrder({
    required this.teacherName,
    required this.totalCloths,
    required this.teacherId,
  });
  Map<String, dynamic> toJson() {
    return {
      'faculty_uid': teacherId,
      'regular_cloths': totalCloths,
      'ware_house_regular_cloths': 0,
      'delivered': false
    };
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
  String uid;
  int campusCount;
  int warehouseCount;
  bool delivered;
  int campusRegularCloth;
  int campusRegularUniform;
  int warehouseRegularCloth;
  int warehouseRegularUniform;

  CampusEmployeeStudentDaySheetCompareData({
    required this.tagNo,
    required this.campusCount,
    required this.warehouseCount,
    required this.delivered,
    required this.campusRegularCloth,
    required this.campusRegularUniform,
    required this.warehouseRegularCloth,
    required this.warehouseRegularUniform,
    required this.uid,
  });
}

class CampusEmployeeFacultyDaySheetCompareData {
  String facultyName;
  int campusCount;
  int warehouseCount;
  bool delivered;
  String uid;

  CampusEmployeeFacultyDaySheetCompareData({
    required this.facultyName,
    required this.campusCount,
    required this.warehouseCount,
    required this.delivered,
    required this.uid,
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
