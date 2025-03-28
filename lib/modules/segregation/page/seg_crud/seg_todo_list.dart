import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/segregation/controler/seg_controller.dart';
import 'package:laundry_service/modules/segregation/page/profile/seg_profile.dart';
import 'package:laundry_service/modules/segregation/page/seg_crud/seg_to_do_details.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../helpers/utils.dart';
import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../driver/widgets/home_task_number_page.dart';
import '../../../driver/widgets/task_count_widget.dart';
import '../../../driver/widgets/task_tile_widget.dart';

class SegToDoList extends StatefulWidget {
  const SegToDoList({super.key});

  @override
  State<SegToDoList> createState() => _SegToDoListState();
}

class _SegToDoListState extends State<SegToDoList> {
  final segController = Get.put(SegController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    segController.getUserId();
    segController.getSegToDoList();
  }

  Future<void> refresh() async {
    segController.toDo.value = 0;
    segController.open.value = 0;
    segController.finished.value = 0;
    segController.overdue.value = 0;
    segController.employeeCollection.value = null;
    segController.getSegToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: Column(
        children: [
          Obx(() => HomeTaskNumberPage(
                todo: segController.toDo.value,
                open: segController.open.value,
                finished: segController.finished.value,
                overdue: segController.overdue.value,
                title: 'To Do List',
              )),
          const SizedBox(
            height: 50,
          ),
          Obx(() => Expanded(
              child: segController.gettingToDo.value
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                          size: 40,
                          color: Colors.blue,
                          secondRingColor: const Color(0xFF1A1A3F),
                          thirdRingColor: const Color(0xFFEA3799)),
                    )
                  : segController.employeeCollection.value == null
                      ? const SizedBox()
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: segController
                              .employeeCollection.value!.data.length,
                          itemBuilder: (context, index) {
                            return TaskTileWidget(
                              color1: Utils.getStatusColor(segController
                                  .employeeCollection
                                  .value!
                                  .data[index]
                                  .currentStatus!),
                              title1: Utils.formatDate(
                                      time: segController.employeeCollection
                                          .value!.data[index].createdAt!) ??
                                  '',
                              title2: segController.employeeCollection.value!
                                      .data[index].currentStatus ??
                                  '',
                              title3:
                                  'Collection No-${segController.employeeCollection.value?.data[index].id}',
                              title4: segController.employeeCollection.value!
                                      .data[index].campus.college.name ??
                                  '',
                              icon: Icons.bookmark,
                              color2: Colors.green,
                              function: () {
                                Get.to(() => SegToDoDetails(
                                      studentData: segController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .studentDaySheet,
                                      facultyData: segController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .facultyDaySheet,
                                      campusName: segController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .campus
                                              .college
                                              .name ??
                                          '',
                                      date: Utils.formatDate(
                                              time: segController
                                                  .employeeCollection
                                                  .value!
                                                  .data[index]
                                                  .createdAt!) ??
                                          '',
                                      collectionNo: segController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .id
                                          .toString(),
                                      campusCode: segController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .tagName!,
                                      collectionUid: segController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .uid!,
                                      status: segController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .currentStatus ??
                                          '',
                                      button: true,
                                      maxStudentCount: segController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .campus
                                              .maxStudentCount ??
                                          0,
                                      isUniform: segController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .campus
                                          .uniform,
                                      tagId: segController.employeeCollection
                                          .value!.data[index].campus.tagName!,
                                      segStarted: Utils.getTimeForStatus(
                                          'IN_SEGREGATION',
                                          segController.employeeCollection
                                              .value!.data[index].statusEntry,
                                          segController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .currentStatus!,
                                          segController.employeeCollection
                                              .value!.data[index].updatedAt!),
                                      segCompleted: Utils.getTimeForStatus(
                                          'SEGREGATION_DONE',
                                          segController.employeeCollection
                                              .value!.data[index].statusEntry,
                                          segController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .currentStatus!,
                                          segController.employeeCollection
                                              .value!.data[index].updatedAt!),
                                      completedRange: segController
                                          .employeeCollection
                                          .value!
                                          .data[index]
                                          .completedSegRange,
                                      noTagValue: segController
                                              .employeeCollection
                                              .value!
                                              .data[index]
                                              .noTag ??
                                          '0',
                                      otherCloth: segController
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
