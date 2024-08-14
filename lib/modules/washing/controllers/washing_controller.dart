import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/utils.dart';

class WashingController extends GetxController {
  Timer? timer;
  Timer? washingTimer;
  final timerLeft = 10.obs;
  final washingTime = 0.obs;
  RxBool timerStarted = false.obs;
  RxBool isTimerRunning = false.obs;
  List<WashingTask> washingTasks = <WashingTask>[
    WashingTask(collectionNo: 3, campusName: 'DAV'),
    WashingTask(collectionNo: 22, campusName: 'DPS'),
  ].obs;

  void startTimer({required BuildContext context}) {
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
