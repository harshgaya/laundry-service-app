import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/drying/models/dry_area_model.dart';
import 'package:laundry_service/modules/drying/pages/drying_extend_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constatnts/sharedprefs.dart';
import '../../../helpers/utils.dart';
import '../../../network/network_api_services.dart';
import '../../../network/url_constants.dart';
import '../../campus_employee/models/day_sheet_history.dart';

class DryingController extends GetxController {
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
  RxBool gettingDryArea = false.obs;
  RxList<DryArea> dryAreaList = <DryArea>[].obs;
  RxBool updateDryArea = false.obs;
  RxBool updatingStatus = false.obs;

  ///
  ///active inactive
  RxBool gettingActiveCollection = false.obs;
  Rx<EmployeeCollections?> activeCollection = Rx<EmployeeCollections?>(null);
  Rx<EmployeeCollections?> inActiveCollection = Rx<EmployeeCollections?>(null);

  ///active inactive
  Timer? timer;
  Timer? washingTimer;
  final timerLeft = 10.obs;
  final washingTime = 0.obs;
  RxBool timerStarted = false.obs;
  RxBool isTimerRunning = false.obs;
  List<DryingTask> dryingTask = <DryingTask>[
    DryingTask(collectionNo: 3, campusName: 'DAV'),
    DryingTask(collectionNo: 22, campusName: 'DPS'),
  ].obs;

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

  Future<void> getDryingToDoList() async {
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
          .where((element) => element.currentStatus == 'WASHING_DONE')
          .length;
      open.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'DRYING')
          .length;
      finished.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'DRYING_DONE')
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

  String? getDryingStatusTime({required int collectionNo}) {
    try {
      final item = employeeCollection.value?.data
          .firstWhereOrNull((element) => element.id == collectionNo);
      if (item != null && item.currentStatus == 'DRYING') {
        print('updated time ${Utils.formatDate(time: item.updatedAt!)}');
        return Utils.formatDate(time: item.updatedAt!);
      }
      if (item != null && item.currentStatus == 'DRYING_DONE') {
        print('drying time ${Utils.getTimeForStatus3(
          'DRYING',
          item.statusEntry,
        )}');
        return Utils.getTimeForStatus3(
          'DRYING',
          item.statusEntry,
        );
      }
      return null;
    } catch (e) {
      print('error in getting drying status time $e');
      return null;
    }
  }

  String? getDryingStatusTime2({required int collectionNo}) {
    final item = employeeCollection.value?.data
        .firstWhereOrNull((element) => element.id == collectionNo);
    if (item != null && item.currentStatus == 'DRYING_DONE') {
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
      //     .where((element) => element.currentStatus == 'WASHING_DONE')
      //     .length;
      // open.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'DRYING')
      //     .length;
      // finished.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'DRYING_DONE')
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
      gettingActiveCollection.value = false;
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
      //     .where((element) => element.currentStatus == 'WASHING_DONE')
      //     .length;
      // open.value = inActiveCollection.value!.data
      //     .where((element) => element.currentStatus == 'DRYING')
      //     .length;
      // finished.value = inActiveCollection.value!.data
      //     .where((element) => element.currentStatus == 'DRYING_DONE')
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
      print('error in inactive $e');
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

  Future<void> getDryAreaList() async {
    try {
      dryAreaList.value = [];
      gettingDryArea.value = true;
      final response = await _apiServices.getApi2(UrlConstants.getDryArea);

      dryAreaList.value =
          (response as List).map((json) => DryArea.fromJson(json)).toList();

      gettingDryArea.value = false;
    } catch (e) {
      print('error here $e');
      gettingDryArea.value = false;
    }
  }

  Future<void> updateFilledArea(
      {required String dryAreaId,
      required mapData,
      required String campusId}) async {
    try {
      updateDryArea.value = true;
      var data = {'campus': campusId, 'filled': jsonEncode(mapData)};
      var response = await _apiServices.patchApi(
          data, '${UrlConstants.updateDryAreaFilled}$dryAreaId/');
      await saveDryAreaId(dryAreaId: dryAreaId);
      print('response $response');
      updateDryArea.value = false;
    } catch (e) {
      updateDryArea.value = false;
      print('error $e');
    }
  }

  Future<void> saveDryAreaId({required String dryAreaId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferenceKey.dryAreaId, dryAreaId);
  }

  Future<void> emptyFilledArea({required String campusId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? dryAreaId =
        sharedPreferences.getString(SharedPreferenceKey.dryAreaId);
    if (dryAreaId != null) {
      var data = {'campus': campusId, 'filled': {}};
      var response = await _apiServices.patchApi(
          data, '${UrlConstants.updateDryAreaFilled}$dryAreaId/');
      sharedPreferences.remove(SharedPreferenceKey.dryAreaId);
    }
  }

  Future<void> updateStatus(
      {required String collectionId,
      required String status,
      required String campusId}) async {
    try {
      updatingStatus.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      print('status to patch ${status}');
      var data = {
        'current_status': status,
        'drying_supervisor_uid': userId,
      };
      var response = await _apiServices.patchApi(
          data, '${UrlConstants.updateData}$collectionId/');

      final collection = employeeCollection.value!.data
          .firstWhere((element) => element.uid == collectionId);
      if (status == 'DRYING_DONE') {
        emptyFilledArea(campusId: campusId);
      }

      if (status == 'DRYING') {
        collection.currentStatus = status;
        collection.updatedAt = DateTime.now().toString();
        collection.statusEntry.add(StatusEntry(
            status: 'DRYING', updatedTime: DateTime.now().toString()));
      } else {
        String dryingTime = Utils.getTimeForStatus3(
          'DRYING',
          collection.statusEntry,
        );
        if (dryingTime.isEmpty) {
          String dryingUpdatedTime = collection.updatedAt!;
          collection.updatedAt = DateTime.now().toString();
          collection.currentStatus = status;
          collection.statusEntry.add(
              StatusEntry(status: 'DRYING', updatedTime: dryingUpdatedTime));
          collection.statusEntry.add(StatusEntry(
              status: 'DRYING_DONE', updatedTime: DateTime.now().toString()));
          collection.updatedAt = DateTime.now().toString();
        } else {
          collection.currentStatus = status;
          collection.updatedAt = DateTime.now().toString();
          collection.statusEntry.add(StatusEntry(
              status: 'DRYING_DONE', updatedTime: DateTime.now().toString()));
        }

        // employeeCollection.value!.data
        //     .removeWhere((element) => element.uid == collectionId);
      }
      employeeCollection.refresh();
      updatingStatus.value = false;
    } catch (e) {
      updatingStatus.value = false;
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
        Utils.showDialogPopUp(
            context: context,
            function: () {
              Get.to(() => const DryingExtendTimePage());
            },
            title: 'Done drying');
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

class DryingTask {
  int collectionNo;
  String campusName;
  DryingTask({required this.collectionNo, required this.campusName});
}
