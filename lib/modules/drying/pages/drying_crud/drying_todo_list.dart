import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/drying/controllers/drying_controller.dart';
import 'package:laundry_service/modules/drying/pages/drying_crud/drying_todo_details.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../helpers/utils.dart';
import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../driver/widgets/home_task_number_page.dart';
import '../../../driver/widgets/task_count_widget.dart';
import '../../../driver/widgets/task_tile_widget.dart';

class DryingToDoPage extends StatefulWidget {
  const DryingToDoPage({super.key});

  @override
  State<DryingToDoPage> createState() => _DryingToDoPageState();
}

class _DryingToDoPageState extends State<DryingToDoPage> {
  final dryingController = Get.put(DryingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dryingController.getUserId();
    dryingController.getDryingToDoList();
  }

  Future<void> refresh() async {
    dryingController.toDo.value = 0;
    dryingController.open.value = 0;
    dryingController.finished.value = 0;
    dryingController.overdue.value = 0;
    dryingController.employeeCollection.value = null;
    dryingController.getDryingToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Column(
        children: [
          Obx(() => HomeTaskNumberPage(
                todo: dryingController.toDo.value,
                open: dryingController.open.value,
                finished: dryingController.finished.value,
                overdue: dryingController.overdue.value,
                title: 'To Do List',
              )),
          const SizedBox(
            height: 50,
          ),
          Obx(() => Expanded(
              child: dryingController.gettingToDo.value
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                          size: 40,
                          color: Colors.blue,
                          secondRingColor: const Color(0xFF1A1A3F),
                          thirdRingColor: const Color(0xFFEA3799)),
                    )
                  : dryingController.employeeCollection.value == null
                      ? const SizedBox()
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: dryingController
                              .employeeCollection.value!.data.length,
                          itemBuilder: (context, index) {
                            return TaskTileWidget(
                              color1: Utils.getStatusColor(dryingController
                                  .employeeCollection
                                  .value!
                                  .data[index]
                                  .currentStatus!),
                              title1: Utils.formatDate(
                                      time: dryingController.employeeCollection
                                          .value!.data[index].createdAt!) ??
                                  '',
                              title2: dryingController.employeeCollection.value!
                                      .data[index].currentStatus ??
                                  '',
                              title3:
                                  'Collection No-${dryingController.employeeCollection.value?.data[index].id}',
                              title4: dryingController.employeeCollection.value!
                                      .data[index].campus.college.name ??
                                  '',
                              icon: Icons.bookmark,
                              color2: Colors.green,
                              function: () {
                                Get.to(() => DryingToDoDetails(
                                      studentData: dryingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .studentDaySheet,
                                      facultyData: dryingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .facultyDaySheet,
                                      campusName: dryingController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .campus
                                              .college
                                              .name ??
                                          '',
                                      date: Utils.formatDate(
                                              time: dryingController
                                                  .employeeCollection
                                                  .value!
                                                  .data[index]
                                                  .createdAt!) ??
                                          '',
                                      collectionNo: dryingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .id
                                          .toString(),
                                      campusCode: dryingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .tagName!,
                                      collectionUid: dryingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .uid!,
                                      status: dryingController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .currentStatus ??
                                          '',
                                      button: true,
                                      dryingCompletedAt: Utils.getTimeForStatus(
                                          'DRYING_DONE',
                                          dryingController.employeeCollection
                                              .value!.data[index].statusEntry,
                                          dryingController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .currentStatus!,
                                          dryingController.employeeCollection
                                              .value!.data[index].updatedAt!),
                                      dryingStartedAt: Utils.getTimeForStatus(
                                          'DRYING',
                                          dryingController.employeeCollection
                                              .value!.data[index].statusEntry,
                                          dryingController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .currentStatus!,
                                          dryingController.employeeCollection
                                              .value!.data[index].updatedAt!),
                                      isUniform: dryingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .uniform,
                                      campusId: dryingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .uid!,
                                      otherCloth: dryingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .otherClothDaySheet,
                                      campusColor: dryingController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .color,
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
