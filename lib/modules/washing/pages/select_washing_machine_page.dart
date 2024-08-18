import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';

import '../../campus_employee/widgets/drop_down_widget.dart';

class SelectWashingMachinePage extends StatefulWidget {
  const SelectWashingMachinePage({super.key});

  @override
  State<SelectWashingMachinePage> createState() =>
      _SelectWashingMachinePageState();
}

class _SelectWashingMachinePageState extends State<SelectWashingMachinePage> {
  final washingController = Get.put(WashingController());
  List<String> machines = ['Machine 1', 'Machine 2', 'Machine 3'];
  String? selectedMachine;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Please make sure all machines are cleaned',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropDownWidget(
                  hintText: 'Select Machine',
                  selectedText: selectedMachine,
                  listOfString: machines,
                  onChanged: (val) {
                    setState(() {
                      selectedMachine = val;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
