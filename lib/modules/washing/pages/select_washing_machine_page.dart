import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'dart:io';

import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import 'package:laundry_service/modules/washing/pages/washing_dashboard.dart';

class SelectWashingMachinePage extends StatefulWidget {
  const SelectWashingMachinePage({super.key});

  @override
  State<SelectWashingMachinePage> createState() =>
      _SelectWashingMachinePageState();
}

class _SelectWashingMachinePageState extends State<SelectWashingMachinePage> {
  String? selectedWashingMachine;
  final washingController = Get.put(WashingController());
  List<String> machines = ['Machine 1', 'Machine 2', 'Machine 3'];
  File? beforeCleaningImage;
  File? afterCleaningImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please make sure all machines are cleaned',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 80),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Select Machine',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.blue,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please select machine';
                  }
                  return null;
                },
                value: selectedWashingMachine,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWashingMachine = newValue;
                  });
                },
                dropdownColor: Colors.blue,
                items: machines.map<DropdownMenuItem<String>>((String machine) {
                  return DropdownMenuItem<String>(
                    value: machine,
                    child: Text(
                      machine,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              beforeCleaningImage == null
                  ? InkWell(
                      onTap: () async {
                        beforeCleaningImage = await Utils.captureImage();
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
                        beforeCleaningImage = await Utils.captureImage();
                        setState(() {});
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.file(
                          beforeCleaningImage!,
                          height: 100,
                        ),
                      )),
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
              const Spacer(),
              InkWell(
                onTap: () {
                  if (selectedWashingMachine == null) {
                    Utils.showScaffoldMessageI(
                        context: context,
                        title: 'Please select washing machine');
                    return;
                  }
                  if (beforeCleaningImage == null) {
                    Utils.showScaffoldMessageI(
                        context: context,
                        title: 'Please take washing machine pic');
                    return;
                  }
                  if (washingController.timerLeft.value == 0) {
                    Get.to(() => const WashingDashboard());
                    return;
                  }
                  if (washingController.timerLeft.value == 10) {
                    washingController.startTimer(context: context);
                  }
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Start',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
