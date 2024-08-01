import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';
import 'package:laundry_service/modules/washing/washing_dashboard.dart';

class SelectWashingMachinePage extends StatefulWidget {
  const SelectWashingMachinePage({super.key});

  @override
  State<SelectWashingMachinePage> createState() =>
      _SelectWashingMachinePageState();
}

class _SelectWashingMachinePageState extends State<SelectWashingMachinePage> {
  final List<String> washingMachines = [
    'Washing Machine 1',
    'Washing Machine 2',
    'Washing Machine 3',
    'Washing Machine 4',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Please Make Sure that All Machines are Cleaned'),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Washing Machine',
                  border: OutlineInputBorder(),
                ),
                value: washingMachines[0], // Initial selected value
                items: washingMachines.map((String machine) {
                  return DropdownMenuItem<String>(
                    value: machine,
                    child: Text(machine),
                  );
                }).toList(),
                onChanged: (newValue) {
                  // Handle change
                  print('Selected machine: $newValue');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a washing machine';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Icon(
                Icons.camera_alt,
                size: 80,
              ),
              const SizedBox(
                height: 20,
              ),
              const WhiteContainer(widget: Text('After Cleaning')),
              const Spacer(),
              InkWell(
                  onTap: () {
                    Get.to(() => WashingDashboard());
                  },
                  child: const WhiteContainer(widget: Text('START'))),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
