import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/driver/pages/to_do_list_view_driver.dart';

class DriverTaskPageHome extends StatefulWidget {
  const DriverTaskPageHome({super.key});

  @override
  State<DriverTaskPageHome> createState() => _DriverTaskPageHomeState();
}

class _DriverTaskPageHomeState extends State<DriverTaskPageHome> {
  final List<Map<String, String>> data = [
    {"sno": "1", "college": "College A", "task": "Task A"},
    {"sno": "2", "college": "College B", "task": "Task B"},
    {"sno": "3", "college": "College C", "task": "Task C"},
    {"sno": "4", "college": "College D", "task": "Task D"},
    {"sno": "5", "college": "College E", "task": "Task E"},
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Table(
            border: TableBorder.all(),
            columnWidths: {
              0: FlexColumnWidth(0.2),
              1: FlexColumnWidth(0.4),
              2: FlexColumnWidth(0.4),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'S.No',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'College Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Task',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ...data.map((item) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item["sno"]!),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item["college"]!),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => ToDoListViewDriver());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item["task"]!),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}
