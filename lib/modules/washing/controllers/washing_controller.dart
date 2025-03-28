import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constatnts/sharedprefs.dart';
import '../../../network/network_api_services.dart';
import '../../../network/url_constants.dart';
import '../../campus_employee/controllers/campus_employee_controller.dart';
import '../../campus_employee/models/day_sheet_history.dart';

class WashingController extends GetxController {
  final _apiServices = NetworkApiServices();

  ///data
  RxString userId = ''.obs;
  RxString userName = ''.obs;
  RxString mobileNumber = ''.obs;

  ///todo
  RxInt toDo = 0.obs;
  RxInt open = 0.obs;
  RxInt finished = 0.obs;
  RxInt overdue = 0.obs;
  RxBool gettingToDo = false.obs;
  Rx<EmployeeCollections?> employeeCollection = Rx<EmployeeCollections?>(null);
  RxBool uploadingRemarks = false.obs;
  RxBool updatingStatus = false.obs;

  ///
  ///active inactive
  RxBool gettingActiveCollection = false.obs;
  Rx<EmployeeCollections?> activeCollection = Rx<EmployeeCollections?>(null);
  Rx<EmployeeCollections?> inActiveCollection = Rx<EmployeeCollections?>(null);

  ///active inactive

  ///data
  Timer? timer;
  Timer? washingTimer;
  final timerLeft = 10.obs;
  final washingTime = 0.obs;
  RxBool timerStarted = false.obs;
  RxBool isTimerRunning = false.obs;
  RxString machine1ImageBeforeWash = ''.obs;
  RxString machine2ImageBeforeWash = ''.obs;
  RxString machine3ImageBeforeWash = ''.obs;
  RxString machine1ImageAfterWash = ''.obs;
  RxString machine2ImageAfterWash = ''.obs;
  RxString machine3ImageAfterWash = ''.obs;
  // RxList<RemarkDataWashing> washingRemarks = <RemarkDataWashing>[].obs;
  var washingRemarks = <WarehouseRemark>[].obs;

  ///day sheet

  var teacherOrders = <TeacherOrder>[
    TeacherOrder(teacherName: 'Mr. Raju', totalCloths: 12, teacherId: ''),
    TeacherOrder(teacherName: 'Mr. Mamth', totalCloths: 22, teacherId: ''),
    TeacherOrder(teacherName: 'Mr. Suresh', totalCloths: 2, teacherId: ''),
  ].obs;

  ///day sheet

  void startTimer({
    required BuildContext context,
    required VoidCallback onCompleted,
  }) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerLeft.value > 0) {
        timerStarted.value = true;
        timerLeft.value--;
      } else {
        // Utils.showScaffoldMessageI(
        //     context: context,
        //     title: 'Cleaning done! please take pic of machine');
        timerStarted.value = false;
        timer.cancel();
        onCompleted();
      }
    });
  }

  String? getWashingStatusTime({required int collectionNo}) {
    final item = employeeCollection.value?.data
        .firstWhereOrNull((element) => element.id == collectionNo);
    if (item != null && item.currentStatus == 'WASHING') {
      print('time ${Utils.formatDate(time: item.updatedAt!)}');
      return Utils.formatDate(time: item.updatedAt!);
    }

    if (item != null && item.currentStatus == 'WASHING_DONE') {
      print('current status ${item.statusEntry.map((e) => e.status)}');
      print('time2 ${Utils.getTimeForStatus3('WASHING', item.statusEntry)}');
      return Utils.getTimeForStatus3(
        'WASHING',
        item.statusEntry,
      );
    }
    return null;
  }

  String? getWashingStatusTime2({required int collectionNo}) {
    final item = employeeCollection.value?.data
        .firstWhereOrNull((element) => element.id == collectionNo);
    if (item != null && item.currentStatus == 'WASHING_DONE') {
      return Utils.formatDate(time: item.updatedAt!);
    }
    return null;
  }

  String? getCurrentStatus({required int collectionNo}) {
    final item = employeeCollection.value?.data
        .firstWhereOrNull((element) => element.id == collectionNo);
    if (item != null) {
      return item.currentStatus;
    }
    return null;
  }

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

  Future<void> getWashingToDoList() async {
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
          .where((element) => element.currentStatus == 'DELIVERED_TO_WAREHOUSE')
          .length;
      open.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'WASHING')
          .length;
      finished.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'WASHING_DONE')
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
      // toDo.value = employeeCollection.value!.data
      //     .where((element) => element.currentStatus == 'DELIVERED_TO_WAREHOUSE')
      //     .length;
      // open.value = employeeCollection.value!.data
      //     .where((element) => element.currentStatus == 'WASHING')
      //     .length;
      // finished.value = employeeCollection.value!.data
      //     .where((element) => element.currentStatus == 'WASHING_DONE')
      //     .length;
      // overdue.value = employeeCollection.value!.data.where((element) {
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
      // toDo.value = employeeCollection.value!.data
      //     .where((element) => element.currentStatus == 'DELIVERED_TO_WAREHOUSE')
      //     .length;
      // open.value = employeeCollection.value!.data
      //     .where((element) => element.currentStatus == 'WASHING')
      //     .length;
      // finished.value = employeeCollection.value!.data
      //     .where((element) => element.currentStatus == 'WASHING_DONE')
      //     .length;
      // overdue.value = employeeCollection.value!.data.where((element) {
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

  Future<void> updateStatus(
      {required String collectionId, required String status}) async {
    try {
      updatingStatus.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var data = {
        'current_status': status,
        'washing_supervisor_uid': userId,
      };
      var response = await _apiServices.patchApi(
          data, '${UrlConstants.updateData}$collectionId/');

      final collection = employeeCollection.value!.data
          .firstWhere((element) => element.uid == collectionId);

      if (status == 'WASHING') {
        collection.currentStatus = status;
        print('washing status in status update ${collection.currentStatus}');
        collection.updatedAt = DateTime.now().toString();
        print(
            'washing status list before washing ${collection.statusEntry.map((e) => e.status).toList()}');

        collection.statusEntry.add(StatusEntry(
            status: 'WASHING', updatedTime: DateTime.now().toString()));
        print(
            'washing status list after washing ${collection.statusEntry.map((e) => e.status).toList()}');
      } else {
        String washingTime = Utils.getTimeForStatus3(
          'WASHING',
          collection.statusEntry,
        );
        if (washingTime.isEmpty) {
          String washingUpdatedTime = collection.updatedAt!;
          collection.currentStatus = status;
          collection.statusEntry.add(
              StatusEntry(status: 'WASHING', updatedTime: washingUpdatedTime));
          collection.statusEntry.add(StatusEntry(
              status: 'WASHING_DONE', updatedTime: DateTime.now().toString()));
          collection.updatedAt = DateTime.now().toString();
        } else {
          collection.currentStatus = status;
          collection.updatedAt = DateTime.now().toString();
          collection.statusEntry.add(StatusEntry(
              status: 'WASHING_DONE', updatedTime: DateTime.now().toString()));
        }

        // employeeCollection.value!.data
        //     .removeWhere((element) => element.uid == collectionId);
      }
      employeeCollection.refresh();

      updatingStatus.value = false;
    } catch (e) {
      updatingStatus.value = false;

      print('error $e');
    }
  }

  Future<void> addNoTag(
      {required String collectionId,
      required String noTagCount,
      required BuildContext context}) async {
    try {
      var data = {
        'no_tag': noTagCount,
      };
      var response = await _apiServices.patchApi(
          data, '${UrlConstants.updateData}$collectionId/');
      Utils.showScaffoldMessageI(context: context, title: 'No tag added');
    } catch (e) {
      print('error notag entry $e');
    }
  }

  Future<void> uploadWashingRemarks(
      {required String collectionId,
      required BuildContext context,
      required List<WarehouseRemark> warehouseRem}) async {
    try {
      if (washingRemarks.isEmpty) {
        Navigator.of(context).pop();
        return;
      }
      uploadingRemarks.value = true;
      List<Map<String, dynamic>> remarksData = warehouseRem.map((element) {
        return {
          'tag_number': element.tagNumber,
          'remark': element.remark,
          'employee': element.employee
        };
      }).toList();
      var data = {'warehouse_remark': jsonEncode(remarksData)};

      var response = await _apiServices.patchApi(
          data, '${UrlConstants.uploadRemarksByCampusEmployee}$collectionId/');
      uploadingRemarks.value = false;
      final item = employeeCollection.value?.data
          .firstWhereOrNull((element) => element.uid == collectionId);
      if (item != null) {
        item.warehouseRemarks.clear();
        item.warehouseRemarks.addAll(washingRemarks);
      }
      employeeCollection.refresh();
      // washingRemarks.value = [];
      Navigator.of(context).pop();
      Utils.showScaffoldMessageI(context: context, title: 'Remarks added');
    } catch (e) {
      uploadingRemarks.value = false;
    }
  }

  void startTimerWashing({required BuildContext context}) {
    if (isTimerRunning.value) {
      // If the timer is already running, do nothing
      return;
    }

    isTimerRunning.value = true;

    washingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (washingTime.value > 0) {
        washingTime.value--;
      } else {
        washingTimer?.cancel();
        isTimerRunning.value = false;
      }
    });
  }

  void stopTimer() {
    washingTimer?.cancel();
    isTimerRunning.value = false;
  }

  void resetTimer() {
    washingTimer?.cancel();
    washingTime.value = 0;
    isTimerRunning.value = false;
  }

  @override
  void onClose() {
    timer?.cancel();
    timerStarted.value = false;
    washingTimer?.cancel();
    super.onClose();
  }
}

class WashingTask {
  int collectionNo;
  String campusName;
  WashingTask({required this.collectionNo, required this.campusName});
}

class RemarkDataWashing {
  String tagNo;
  String remarks;
  RemarkDataWashing({required this.tagNo, required this.remarks});
}
