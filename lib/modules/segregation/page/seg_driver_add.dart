import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/segregation/page/seg_assign_to_driver.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../helpers/utils.dart';
import '../../campus_employee/controllers/campus_employee_controller.dart';
import '../../driver/widgets/home_task_number_page.dart';
import '../../driver/widgets/task_count_widget.dart';
import '../../driver/widgets/task_tile_widget.dart';
import '../controler/seg_controller.dart';

class SegDriverAdd extends StatefulWidget {
  const SegDriverAdd({super.key});

  @override
  State<SegDriverAdd> createState() => _SegDriverAddState();
}

class _SegDriverAddState extends State<SegDriverAdd> {
  final segController = Get.put(SegController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    segController.getSegToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => HomeTaskNumberPage(
              todo: segController.toDo.value,
              open: segController.open.value,
              finished: segController.finished.value,
              overdue: segController.overdue.value,
              title: 'Segregation History',
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
                        itemCount:
                            segController.employeeCollection.value!.data.length,
                        itemBuilder: (context, index) {
                          return TaskTileWidget(
                            color1: segController.employeeCollection.value!
                                        .data[index].currentStatus ==
                                    'DRYING_DONE'
                                ? Colors.green
                                : segController.employeeCollection.value!
                                            .data[index].currentStatus ==
                                        'DRYING'
                                    ? Colors.yellow
                                    : Colors.deepOrangeAccent,
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
                              List<CampusEmployeeStudentDaySheetCompareData>
                                  studentData = segController.employeeCollection
                                      .value!.data[index].studentDaySheet
                                      .map(
                                        (e) =>
                                            CampusEmployeeStudentDaySheetCompareData(
                                                tagNo: e.tagNumber!,
                                                uid: e.uid!,
                                                warehouseRegularCloth:
                                                    e.wareHouseRegularCloths,
                                                warehouseRegularUniform:
                                                    e.wareHouseUniform,
                                                campusCount: (e.campusUniforms +
                                                    e.campusRegularCloths),
                                                warehouseCount:
                                                    (e.wareHouseRegularCloths +
                                                        e.wareHouseUniform),
                                                delivered: e.delivered,
                                                campusRegularCloth:
                                                    e.campusRegularCloths,
                                                campusRegularUniform:
                                                    e.campusUniforms),
                                      )
                                      .toList();
                              List<CampusEmployeeFacultyDaySheetCompareData>
                                  facultyData = segController.employeeCollection
                                      .value!.data[index].facultyDaySheet
                                      .map((e) =>
                                          CampusEmployeeFacultyDaySheetCompareData(
                                              facultyName: e.faculty?['name'],
                                              uid: e.faculty?['uid'],
                                              campusCount: e.regularCloths,
                                              warehouseCount:
                                                  e.wareHouseRegularCloths,
                                              delivered: e.delivered))
                                      .toList();
                              Get.to(() => SegAssignToDriver(
                                    studentData: studentData,
                                    facultyData: facultyData,
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
                                    campusCode: segController.employeeCollection
                                        .value!.data[index].campus.tagName!,
                                    collectionUid: segController
                                        .employeeCollection
                                        .value!
                                        .data[index]
                                        .uid!,
                                    status: segController.employeeCollection
                                            .value!.data[index].currentStatus ??
                                        '',
                                    button: true,
                                    maxStudentCount: segController
                                            .employeeCollection
                                            .value!
                                            .data[index]
                                            .campus
                                            .maxStudentCount ??
                                        0,
                                    isUniform: segController.employeeCollection
                                        .value!.data[index].campus.uniform,
                                    completedRange: segController
                                        .employeeCollection
                                        .value!
                                        .data[index]
                                        .completedSegRange,
                                  ));
                            },
                          );
                        }))),
        const SizedBox(
          height: 80,
        ),
      ],
    );
  }
}
