import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constatnts/sharedprefs.dart';
import '../../../network/network_api_services.dart';
import '../../../network/url_constants.dart';
import '../../campus_employee/models/day_sheet_history.dart';
import 'package:http/http.dart' as http;

class SegController extends GetxController {
  final _apiServices = NetworkApiServices();

  ///data
  RxString userId = ''.obs;
  RxString userName = ''.obs;
  RxString mobileNumber = ''.obs;

  ///adata
  ///todo
  RxInt toDo = 0.obs;
  RxInt open = 0.obs;
  RxInt finished = 0.obs;
  RxInt overdue = 0.obs;
  RxBool gettingToDo = false.obs;
  Rx<EmployeeCollections?> employeeCollection = Rx<EmployeeCollections?>(null);
  RxList<SearchTagModel> searchTag = <SearchTagModel>[].obs;
  RxBool uploadingData = false.obs;
  RxBool assignToDriver = false.obs;

  ///

  ///active inactive
  RxBool gettingActiveCollection = false.obs;
  Rx<EmployeeCollections?> activeCollection = Rx<EmployeeCollections?>(null);
  Rx<EmployeeCollections?> inActiveCollection = Rx<EmployeeCollections?>(null);

  ///active inactive

  Future<void> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(SharedPreferenceKey.UserId) ?? '';
    String mobile =
        sharedPreferences.getString(SharedPreferenceKey.mobile) ?? '';
    String? name = sharedPreferences.getString(SharedPreferenceKey.name);
    userName.value = name ?? '';
    mobileNumber.value = mobile;
    userId.value = id;
  }

  List<String> generateRanges(int number) {
    int end = ((number ~/ 100) + 1) * 100;

    List<String> ranges = [];
    int start = 100;
    while (start < end) {
      ranges.add('$start-${start + 100}');
      start += 100;
    }

    return ranges;
  }

  int getHighestNumber(List<String> values) {
    int highestNumber = 0;

    for (String value in values) {
      RegExp regExp = RegExp(r'\d+');
      Match? match = regExp.firstMatch(value);

      if (match != null) {
        int number = int.parse(match.group(0)!);
        if (number > highestNumber) {
          highestNumber = number;
        }
      }
    }

    return highestNumber;
  }

  Future<void> getSegToDoList() async {
    try {
      gettingToDo.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response =
          await _apiServices.getApi('${UrlConstants.getToDoList}/$userId/');

      EmployeeCollections employeeCollections =
          EmployeeCollections.fromJson(response, 'data');
      employeeCollection.value = employeeCollections;
      employeeCollection.refresh();

      toDo.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'DRYING_DONE')
          .length; //
      open.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'IN_SEGREGATION')
          .length;
      finished.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'SEGREGATION_DONE')
          .length;
      overdue.value = employeeCollection.value!.data.where((element) {
        if (element.createdAt != null) {
          DateTime today = DateTime.now();
          DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);
          return DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(element.createdAt!)) ==
              DateFormat('yyyy-MM-dd').format(tomorrow);
        }
        return false;
      }).length;
      gettingToDo.value = false;
    } catch (e) {
      gettingToDo.value = false;
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
      // toDo.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'DRYING_DONE')
      //     .length; //
      // open.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'IN_SEGREGATION')
      //     .length;
      // finished.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'SEGREGATION_DONE')
      //     .length;
      // overdue.value = activeCollection.value!.data.where((element) {
      //   if (element.createdAt != null) {
      //     DateTime today = DateTime.now();
      //     DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);
      //     return DateFormat('yyyy-MM-dd')
      //             .format(DateTime.parse(element.createdAt!)) ==
      //         DateFormat('yyyy-MM-dd').format(tomorrow);
      //   }
      //   return false;
      // }).length;
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
      // toDo.value = inActiveCollection.value!.data
      //     .where((element) => element.currentStatus == 'DRYING_DONE')
      //     .length; //
      // open.value = inActiveCollection.value!.data
      //     .where((element) => element.currentStatus == 'IN_SEGREGATION')
      //     .length;
      // finished.value = inActiveCollection.value!.data
      //     .where((element) => element.currentStatus == 'SEGREGATION_DONE')
      //     .length;
      // overdue.value = inActiveCollection.value!.data.where((element) {
      //   if (element.createdAt != null) {
      //     DateTime today = DateTime.now();
      //     DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);
      //     return DateFormat('yyyy-MM-dd')
      //             .format(DateTime.parse(element.createdAt!)) ==
      //         DateFormat('yyyy-MM-dd').format(tomorrow);
      //   }
      //   return false;
      // }).length;
      //
      // inActiveCollection.value?.data
      //     .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
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

  Future<void> updateNoTagRemark(
      {required String collectionId,
      required BuildContext context,
      required List<Map<String, String>> remark}) async {
    try {
      uploadingData.value = true;
      String url = '${UrlConstants.updateData}$collectionId/';
      var request = http.MultipartRequest('PATCH', Uri.parse(url));
      request.fields['warehouse_remark'] = jsonEncode(remark);
      var response = await request.send();
      if (response.statusCode == 200) {
        Utils.showScaffoldMessageI(
            context: context, title: 'No Tag Remarks added');
        Navigator.of(context).pop();
      } else {
        print('Failed to upload no tag remarks: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
      }
      uploadingData.value = false;
    } catch (e) {
      uploadingData.value = false;
      print('error $e');
    }
  }

  Future<void> updateStatus(
      {required String collectionId,
      required String status,
      required BuildContext context,
      required List<Map<String, dynamic>> studentData,
      required String range,
      required List<Map<String, String>> remark}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      uploadingData.value = true;
      String newStatus = 'IN_SEGREGATION';
      final collection = employeeCollection.value!.data
          .firstWhere((element) => element.uid == collectionId);
      Map<String, bool> rangeMap = {
        ...collection.completedSegRange,
        range: true,
      };

      String url = '${UrlConstants.updateData}$collectionId/';
      var request = http.MultipartRequest('PATCH', Uri.parse(url));
      request.fields['current_status'] = newStatus;
      request.fields['warehouse_remark'] = jsonEncode(remark);
      request.fields['student_day_sheet'] = jsonEncode(studentData);
      request.fields['segregation_supervisor_uid'] = userId!;
      request.fields['completed_segregation_range'] = jsonEncode(rangeMap);
      var response = await request.send();
      if (response.statusCode == 200) {
        collection.currentStatus = newStatus;
        collection.completedSegRange[range] = true;
        employeeCollection.refresh();
        searchTag.value = [];
        Navigator.of(context).pop();
      } else {
        print('Failed to upload bag: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
      }
      uploadingData.value = false;
    } catch (e) {
      uploadingData.value = false;
      print('error $e');
    }
  }

  Future<void> updateStatus2({
    required String collectionId,
    required BuildContext context,
  }) async {
    try {
      assignToDriver.value = true;
      String url = '${UrlConstants.updateData}$collectionId/';
      var request = http.MultipartRequest('PATCH', Uri.parse(url));
      request.fields['current_status'] = 'READY_FOR_DELIVERY';
      var response = await request.send();
      if (response.statusCode == 200) {
        final collection = employeeCollection.value!.data
            .firstWhere((element) => element.uid == collectionId);
        collection.currentStatus = "READY_FOR_DELIVERY";
        employeeCollection.value!.data
            .removeWhere((element) => element.uid == collectionId);
        employeeCollection.refresh();
        searchTag.value = [];
        Navigator.of(context).pop();
      } else {
        print('Failed to upload bag: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
      }
      assignToDriver.value = false;
    } catch (e) {
      assignToDriver.value = false;
      print('error $e');
    }
  }

  List<DryingTask> dryingTask = <DryingTask>[
    DryingTask(collectionNo: 3, campusName: 'DAV'),
    DryingTask(collectionNo: 22, campusName: 'DPS'),
  ].obs;

  RxList<SegRemarks> remarks = <SegRemarks>[
    SegRemarks(remarks: 'Missing', tagNo: 142),
    SegRemarks(remarks: 'Not cleaned', tagNo: 122),
  ].obs;
}

class DryingTask {
  int collectionNo;
  String campusName;
  DryingTask({required this.collectionNo, required this.campusName});
}

class SearchTagModel {
  String tagNo;
  int totalCloths;
  int totalUniforms;
  int totalMissing;
  int totalExtra;
  SearchTagModel(
      {required this.tagNo,
      required this.totalUniforms,
      required this.totalCloths,
      required this.totalExtra,
      required this.totalMissing});
}

class SegRemarks {
  int tagNo;
  String remarks;
  SegRemarks({required this.remarks, required this.tagNo});
}
