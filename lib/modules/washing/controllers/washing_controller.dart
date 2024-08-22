import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/utils.dart';

import '../../campus_employee/controllers/campus_employee_controller.dart';

class WashingController extends GetxController {
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
  RxList<RemarkDataWashing> washingRemarks = <RemarkDataWashing>[].obs;
  List<WashingTask> washingTasks = <WashingTask>[
    WashingTask(collectionNo: 3, campusName: 'DAV'),
    WashingTask(collectionNo: 22, campusName: 'DPS'),
  ].obs;

  ///day sheet
  var orders = <Order>[
    Order(
        tagNo: 453,
        totalUniforms: 4,
        remarks: '',
        totalCloths: 2,
        missing: 1,
        extra: 0),
    Order(
        tagNo: 124,
        totalUniforms: 14,
        remarks: '',
        totalCloths: 5,
        missing: 3,
        extra: 0),
    Order(
        tagNo: 126,
        totalUniforms: 1,
        remarks: '',
        totalCloths: 6,
        missing: 2,
        extra: 0),
    Order(
        tagNo: 122,
        totalUniforms: 21,
        remarks: '',
        totalCloths: 16,
        missing: 1,
        extra: 0),
  ].obs;
  var teacherOrders = <TeacherOrder>[
    TeacherOrder(teacherName: 'Mr. Raju', totalCloths: 12),
    TeacherOrder(teacherName: 'Mr. Mamth', totalCloths: 22),
    TeacherOrder(teacherName: 'Mr. Suresh', totalCloths: 2),
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
  int tagNo;
  String remarks;
  RemarkDataWashing({required this.tagNo, required this.remarks});
}
