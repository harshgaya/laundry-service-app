import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/remarks/warehouse_remarks_details.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../helpers/utils.dart';
import '../../../driver/widgets/task_count_widget.dart';
import '../../../driver/widgets/task_tile_widget.dart';

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
                child: Center(
                  child: Center(
                      child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TaskCountWidget(
                            title: 'To Do',
                            count:
                                '${campusEmployeeController.employeeCollection.value?.data.where((element) => element.currentStatus == 'READY_TO_PICK').length ?? '0'}'),
                        TaskCountWidget(
                            title: 'Open',
                            count:
                                '${campusEmployeeController.employeeCollection.value?.data.where((element) => element.currentStatus == 'DELIVERED_TO_CAMPUS').length ?? '0'}'),
                        TaskCountWidget(
                            title: 'Finished',
                            count:
                                '${campusEmployeeController.employeeCollection.value?.data.where((element) => element.currentStatus == 'DELIVERED_TO_STUDENT').length ?? '0'}'),
                      ],
                    ),
                  )),
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
            child: campusEmployeeController
                    .loadingEmployeeCollectionHistory.value
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                        size: 40,
                        color: Colors.blue,
                        secondRingColor: const Color(0xFF1A1A3F),
                        thirdRingColor: const Color(0xFFEA3799)),
                  )
                : campusEmployeeController.employeeCollection.value == null
                    ? const SizedBox()
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: campusEmployeeController
                            .employeeCollection.value?.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = campusEmployeeController
                              .employeeCollection.value!.data[index];

                          return TaskTileWidget(
                            color1: Utils.getStatusColor(item.currentStatus!),
                            title1:
                                Utils.formatDate(time: item.createdAt!) ?? '',
                            title2: item.currentStatus ?? '',
                            title3: 'Collection No-${item.id}',
                            title4: item.campus.college.name ?? '',
                            icon: Icons.bookmark,
                            color2: Colors.green,
                            function: () {
                              print(
                                  'student remark ${item.studentRemarks.length}');
                              campusEmployeeController.studentRemarks.clear();
                              Get.to(() {
                                return WarehouseRemarksDetails(
                                  collectionId: item.uid!,
                                  tagId: item.campus.tagName ?? '',
                                  campusId: item.campus.uid ?? '',
                                  studentData: item.studentDaySheet
                                      .where((element) =>
                                          element.delivered == false)
                                      .toList(),
                                  facultyData: item.facultyDaySheet
                                      .where((element) =>
                                          element.delivered == false)
                                      .toList(),
                                  warehouseRemarkList: item.warehouseRemarks,
                                  collectionNo: item.id.toString(),
                                  studentRemark: item.studentRemarks,
                                );
                              });
                            },
                          );
                        },
                      ),
          ),
        ),
        const SizedBox(
          height: 80,
        ),
      ],
    );
  }
}
