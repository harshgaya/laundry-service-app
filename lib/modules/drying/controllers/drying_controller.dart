import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/drying/pages/drying_extend_time.dart';

import '../../../helpers/utils.dart';

class DryingController extends GetxController {
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

  void startTimerWashing({required BuildContext context}) {
    if (isTimerRunning.value) {
      // If the timer is already running, do nothing
      return;
    }

    isTimerRunning.value = true;

    washingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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
