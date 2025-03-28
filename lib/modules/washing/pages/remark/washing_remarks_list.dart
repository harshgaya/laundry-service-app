import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import 'package:laundry_service/modules/washing/pages/remark/washing_remarks_add_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../helpers/utils.dart';
import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../driver/controllers/driver_controller.dart';
import '../../../driver/pages/driver_crud/to_do_list_view_driver.dart';
import '../../../driver/widgets/home_task_number_page.dart';
import '../../../driver/widgets/task_count_widget.dart';
import '../../../driver/widgets/task_tile_widget.dart';

class WashingAddRemarks extends StatefulWidget {
  const WashingAddRemarks({super.key});

  @override
  State<WashingAddRemarks> createState() => _WashingAddRemarksState();
}

class _WashingAddRemarksState extends State<WashingAddRemarks> {
  final washingController = Get.put(WashingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    washingController.getWashingToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => HomeTaskNumberPage(
              todo: washingController.toDo.value,
              open: washingController.open.value,
              finished: washingController.finished.value,
              overdue: washingController.overdue.value,
              title: 'Add Remarks',
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
                            color1: washingController.employeeCollection.value!
                                        .data[index].currentStatus ==
                                    'WASHING_DONE'
                                ? Colors.green
                                : washingController.employeeCollection.value!
                                            .data[index].currentStatus ==
                                        'WASHING'
                                    ? Colors.yellow
                                    : Colors.deepOrangeAccent,
                            title1: Utils.formatDate(
                                    time: washingController.employeeCollection
                                        .value!.data[index].createdAt!) ??
                                '',
                            title2: washingController.employeeCollection.value!
                                    .data[index].currentStatus ??
                                '',
                            title3:
                                'Collection No-${washingController.employeeCollection.value?.data[index].id}',
                            title4: washingController.employeeCollection.value!
                                    .data[index].campus.college.name ??
                                '',
                            icon: Icons.bookmark,
                            color2: Colors.green,
                            function: () {
                              washingController.washingRemarks.clear();
                              Get.to(() => WashingRemarksPage(
                                    collectionId: washingController
                                        .employeeCollection
                                        .value!
                                        .data[index]
                                        .uid!,
                                    tagId: washingController.employeeCollection
                                        .value!.data[index].campus.tagName!,
                                    studentRemark: washingController
                                        .employeeCollection
                                        .value!
                                        .data[index]
                                        .warehouseRemarks,
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
