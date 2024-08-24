import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/view_remarks_from_warehouse.dart';
import 'package:laundry_service/modules/campus_employee/pages/warehouse_remarks_details.dart';

import '../../driver/widgets/task_count_widget.dart';
import '../../driver/widgets/task_tile_widget.dart';
import 'campus_employee_add_remarks.dart';

class RemarksWarehouse extends StatefulWidget {
  const RemarksWarehouse({super.key});

  @override
  State<RemarksWarehouse> createState() => _RemarksWarehouseState();
}

class _RemarksWarehouseState extends State<RemarksWarehouse> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    campusEmployeeController.getEmployeeCollectionHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 150,
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Remarks',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              height: 70,
              bottom: -35,
              left: 10,
              right: 10,
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TaskCountWidget(title: 'Delievered', count: '200'),
                      TaskCountWidget(title: 'Pending', count: '81'),
                      TaskCountWidget(title: 'Open', count: '5'),
                      TaskCountWidget(title: 'Overdue', count: '50'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Obx(
          () => Expanded(
            child:
                campusEmployeeController.loadingEmployeeCollectionHistory.value
                    ? const Center(child: CircularProgressIndicator())
                    : campusEmployeeController.employeeCollection.value == null
                        ? const SizedBox()
                        : ListView.builder(
                            itemCount: campusEmployeeController
                                .employeeCollection.value?.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TaskTileWidget(
                                color1: Colors.red,
                                title1: 'Asset',
                                title2: 'In progress',
                                title3:
                                    'Collection No-${campusEmployeeController.employeeCollection.value?.data[index].id}',
                                title4: campusEmployeeController
                                    .employeeCollection
                                    .value!
                                    .data[index]
                                    .campus
                                    .college
                                    .name,
                                icon: Icons.bookmark,
                                color2: Colors.green,
                                function: () {
                                  Get.to(() => WarehouseRemarksDetails(
                                        collectionId: campusEmployeeController
                                            .employeeCollection
                                            .value!
                                            .data[index]
                                            .uid,
                                        tagId: campusEmployeeController
                                            .employeeCollection
                                            .value!
                                            .data[index]
                                            .campus
                                            .tagName,
                                        campusId: campusEmployeeController
                                            .employeeCollection
                                            .value!
                                            .data[index]
                                            .campus
                                            .uid,
                                      ));
                                },
                              );
                            },
                          ),
          ),
        ),
      ],
    );
  }
}
