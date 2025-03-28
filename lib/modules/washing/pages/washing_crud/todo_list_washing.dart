import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import 'package:laundry_service/modules/washing/pages/washing_crud/washing_details_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../helpers/utils.dart';
import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../driver/widgets/home_task_number_page.dart';
import '../../../driver/widgets/task_count_widget.dart';
import '../../../driver/widgets/task_tile_widget.dart';

class ToDoListWashing extends StatefulWidget {
  const ToDoListWashing({super.key});

  @override
  State<ToDoListWashing> createState() => _ToDoListWashingState();
}

class _ToDoListWashingState extends State<ToDoListWashing> {
  final washingController = Get.put(WashingController());

  @override
  void initState() {
    super.initState();
    washingController.getUserId();
    washingController.getWashingToDoList();
  }

  Future<void> refresh() async {
    washingController.toDo.value = 0;
    washingController.open.value = 0;
    washingController.finished.value = 0;
    washingController.overdue.value = 0;
    washingController.employeeCollection.value = null;
    washingController.getWashingToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Column(
        children: [
          Obx(() => HomeTaskNumberPage(
                todo: washingController.toDo.value,
                open: washingController.open.value,
                finished: washingController.finished.value,
                overdue: washingController.overdue.value,
                title: 'To Do List',
              )),
          const SizedBox(
            height: 50,
          ),
          Obx(() => Expanded(
              child: washingController.gettingToDo.value
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                          size: 40,
                          color: Colors.blue,
                          secondRingColor: const Color(0xFF1A1A3F),
                          thirdRingColor: const Color(0xFFEA3799)),
                    )
                  : washingController.employeeCollection.value == null
                      ? const SizedBox()
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: washingController
                              .employeeCollection.value!.data.length,
                          itemBuilder: (context, index) {
                            return TaskTileWidget(
                              color1: Utils.getStatusColor(washingController
                                  .employeeCollection
                                  .value!
                                  .data[index]
                                  .currentStatus!),
                              title1: Utils.formatDate(
                                      time: washingController.employeeCollection
                                          .value!.data[index].createdAt!) ??
                                  '',
                              title2: washingController.employeeCollection
                                      .value!.data[index].currentStatus ??
                                  '',
                              title3:
                                  'Collection No-${washingController.employeeCollection.value?.data[index].id}',
                              title4: washingController.employeeCollection
                                      .value!.data[index].campus.college.name ??
                                  '',
                              icon: Icons.bookmark,
                              color2: Colors.green,
                              function: () {
                                Get.to(() => WashingDetailsPage(
                                      studentData: washingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .studentDaySheet,
                                      facultyData: washingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .facultyDaySheet,
                                      campusName: washingController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .campus
                                              .college
                                              .name ??
                                          '',
                                      date: Utils.formatDate(
                                              time: washingController
                                                  .employeeCollection
                                                  .value!
                                                  .data[index]
                                                  .createdAt!) ??
                                          '',
                                      collectionNo: washingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .id
                                          .toString(),
                                      campusCode: washingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .tagName!,
                                      collectionUid: washingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .uid!,
                                      status: washingController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .currentStatus ??
                                          '',
                                      button: true,
                                      updatedTime: Utils.formatDate(
                                          time: washingController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .updatedAt!),
                                      washingStartedAt: Utils.getTimeForStatus(
                                          'WASHING',
                                          washingController.employeeCollection
                                              .value!.data[index].statusEntry,
                                          washingController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .currentStatus!,
                                          washingController.employeeCollection
                                              .value!.data[index].updatedAt!),
                                      washingCompletedAt:
                                          Utils.getTimeForStatus(
                                              'WASHING_DONE',
                                              washingController
                                                  .employeeCollection
                                                  .value!
                                                  .data[index]
                                                  .statusEntry,
                                              washingController
                                                  .employeeCollection
                                                  .value!
                                                  .data[index]
                                                  .currentStatus!,
                                              washingController
                                                  .employeeCollection
                                                  .value!
                                                  .data[index]
                                                  .updatedAt!),
                                      isUniform: washingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .uniform,
                                      otherCloth: washingController
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
