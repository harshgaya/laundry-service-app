import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/washing/pages/washing_dashboard.dart';

import '../../../helpers/utils.dart';
import '../../widegets/round_button_animate.dart';
import '../controllers/washing_controller.dart';
import 'dart:io';

class SelectWashingMachinePage extends StatefulWidget {
  const SelectWashingMachinePage({super.key});

  @override
  State<SelectWashingMachinePage> createState() =>
      _SelectWashingMachinePageState();
}

class _SelectWashingMachinePageState extends State<SelectWashingMachinePage> {
  final washingController = Get.put(WashingController());
  List<String> machines = ['Machine 1', 'Machine 2', 'Machine 3'];
  Map<String, File?> machineImages = {
    'Machine 1': null,
    'Machine 2': null,
    'Machine 3': null
  };

  @override
  Widget build(BuildContext context) {
    bool allImagesCaptured =
        machineImages.values.every((image) => image != null);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please make sure all machines are cleaned',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 20),
              for (var machine in machines)
                Column(
                  children: [
                    Text(machine),
                    machineImages[machine] == null
                        ? InkWell(
                            onTap: () async {
                              File? image = await Utils.captureImage();
                              if (image != null) {
                                setState(() {
                                  machineImages[machine] = image;
                                });
                              }
                            },
                            child: const Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.camera_alt,
                                size: 100,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () async {
                              File? image = await Utils.captureImage();
                              if (image != null) {
                                setState(() {
                                  machineImages[machine] = image;
                                });
                              }
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.file(
                                machineImages[machine]!,
                                height: 100,
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              Align(
                alignment: Alignment.center,
                child: Obx(() {
                  final minutes = washingController.timerLeft.value ~/ 60;
                  final seconds = washingController.timerLeft.value % 60;
                  return Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 48),
                  );
                }),
              ),
              const SizedBox(height: 20),
              if (allImagesCaptured)
                Align(
                  alignment: Alignment.center,
                  child: RoundButtonAnimate(
                    buttonName: 'Start',
                    onClick: () {
                      if (washingController.timerLeft.value == 0) {
                        Get.to(() => const WashingDashboard());
                      } else if (washingController.timerLeft.value == 10) {
                        washingController.startTimer(context: context);
                      }
                    },
                    image: Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
