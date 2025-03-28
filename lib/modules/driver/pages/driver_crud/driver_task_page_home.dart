import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/driver/controllers/driver_controller.dart';
import 'package:laundry_service/modules/driver/pages/driver_crud/to_do_list_view_driver.dart';
import 'package:laundry_service/modules/driver/widgets/home_task_number_page.dart';
import 'package:laundry_service/modules/driver/widgets/task_count_widget.dart';
import 'package:laundry_service/modules/driver/widgets/task_tile_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../helpers/utils.dart';
import '../../../campus_employee/controllers/campus_employee_controller.dart';

class DriverTaskPageHome extends StatefulWidget {
  const DriverTaskPageHome({super.key});

  @override
  State<DriverTaskPageHome> createState() => _DriverTaskPageHomeState();
}

class _DriverTaskPageHomeState extends State<DriverTaskPageHome> {
  final driverController = Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverController.getUserId();
    driverController.getDriverToDoList();
  }

  Future<void> refresh() async {
    driverController.toDo.value = 0;
    driverController.open.value = 0;
    driverController.finished.value = 0;
    driverController.overdue.value = 0;
    driverController.employeeCollection.value = null;
    driverController.getDriverToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Column(
        children: [
          Obx(() => HomeTaskNumberPage(
                todo: driverController.toDo.value,
                open: driverController.open.value,
                finished: driverController.finished.value,
                overdue: driverController.overdue.value,
                title: 'To Do Task',
              )),
          const SizedBox(
            height: 50,
          ),
          Obx(() => Expanded(
              child: driverController.gettingToDo.value
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                          size: 40,
                          color: Colors.blue,
                          secondRingColor: const Color(0xFF1A1A3F),
                          thirdRingColor: const Color(0xFFEA3799)),
                    )
                  : driverController.employeeCollection.value == null
                      ? const SizedBox()
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: driverController
                              .employeeCollection.value!.data.length,
                          itemBuilder: (context, index) {
                            return TaskTileWidget(
                              color1: Utils.getStatusColor(driverController
                                  .employeeCollection
                                  .value!
                                  .data[index]
                                  .currentStatus!),
                              title1: Utils.formatDate(
                                      time: driverController.employeeCollection
                                          .value!.data[index].createdAt!) ??
                                  '',
                              title2: driverController.employeeCollection.value!
                                      .data[index].currentStatus ??
                                  '',
                              title3:
                                  'Collection No-${driverController.employeeCollection.value?.data[index].id}',
                              title4: driverController.employeeCollection.value!
                                      .data[index].campus.college.name ??
                                  '',
                              icon: Icons.bookmark,
                              color2: Colors.green,
                              function: () {
                                Get.to(() => ToDoListViewDriver(
                                      status: driverController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .currentStatus ??
                                          '',
                                      campusCode: driverController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .tagName!,
                                      collectionUid: driverController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .uid!,
                                      studentData: driverController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .studentDaySheet,
                                      facultyData: driverController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .facultyDaySheet,
                                      campusName: driverController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .campus
                                              .college
                                              .name ??
                                          '',
                                      date: Utils.formatDate(
                                              time: driverController
                                                  .employeeCollection
                                                  .value!
                                                  .data[index]
                                                  .createdAt!) ??
                                          '',
                                      collectionNo: driverController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .id
                                          .toString(),
                                      facultyList: driverController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .facultyDaySheet,
                                      isButton: true,
                                      deliveryFromWarehouse: '',
                                      intransitFromWarehouse: '',
                                      deliveredToCampus: '',
                                      pickupFromCampus: '',
                                      intransitFromCampus: '',
                                      deliveredToWarehouse: '',
                                      isUniform: driverController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .uniform,
                                      otherCloth: driverController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .otherClothDaySheet,
                                    ));
                              },
                            );
                          }))),
          const SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }
}
