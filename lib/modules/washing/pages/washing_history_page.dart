import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:laundry_service/modules/washing/pages/washing_crud/washing_details_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../helpers/utils.dart';
import '../../campus_employee/controllers/campus_employee_controller.dart';
import '../../campus_employee/widgets/show_collection_bottom_sheet.dart';
import '../../driver/controllers/driver_controller.dart';
import '../../driver/widgets/home_task_number_page.dart';
import '../../driver/widgets/task_count_widget.dart';
import '../../driver/widgets/task_tile_widget.dart';
import '../controllers/washing_controller.dart';

class WashingHistoryPage extends StatefulWidget {
  const WashingHistoryPage({super.key});

  @override
  State<WashingHistoryPage> createState() => _WashingHistoryPageState();
}

class _WashingHistoryPageState extends State<WashingHistoryPage> {
  final washingController = Get.put(WashingController());
  bool selected1 = true;
  bool selected2 = false;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    washingController.loadActiveInactive();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => HomeTaskNumberPage(
              todo: washingController.activeCollection.value?.data
                      .where((element) =>
                          element.currentStatus == 'DELIVERED_TO_WAREHOUSE')
                      .length ??
                  0,
              open: washingController.activeCollection.value?.data
                      .where((element) => element.currentStatus == 'WASHING')
                      .length ??
                  0,
              finished: washingController.activeCollection.value?.data
                      .where(
                          (element) => element.currentStatus == 'WASHING_DONE')
                      .length ??
                  0,
              overdue: 0,
              title: 'History',
            )),
        const SizedBox(
          height: 50,
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                _selectDateRange(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.compare_arrows),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Filter By Date'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            if (startDate != null && endDate != null)
              InkWell(
                onTap: () {
                  setState(() {
                    startDate = null;
                    endDate = null;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.clear),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Clear Filter'),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Obx(() => Expanded(
            child: washingController.gettingActiveCollection.value
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                        size: 40,
                        color: Colors.blue,
                        secondRingColor: const Color(0xFF1A1A3F),
                        thirdRingColor: const Color(0xFFEA3799)),
                  )
                : washingController.activeCollection.value == null
                    ? const SizedBox()
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: washingController
                            .activeCollection.value!.data.length,
                        itemBuilder: (context, index) {
                          final item = washingController
                              .activeCollection.value!.data[index];
                          final createdAt = DateTime.parse(item.createdAt!);
                          final isWithinDateRange =
                              startDate != null && endDate != null
                                  ? createdAt != null &&
                                      createdAt.isAfter(startDate!) &&
                                      createdAt.isBefore(
                                          endDate!.add(const Duration(days: 1)))
                                  : true;
                          if (isWithinDateRange) {
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
                                showCollectionDetailsSheet(
                                  otherCloth: item.otherClothDaySheet,
                                  context: context,
                                  id: 'Collection No-${item.id}',
                                  dateCreated:
                                      Utils.formatDate(time: item.createdAt!),
                                  deliveryStatus: item.currentStatus!,
                                  studentTagCount: item.studentDaySheet.fold(
                                      0,
                                      (previousValue, element) =>
                                          (previousValue ?? 0) +
                                          (element.campusRegularCloths) +
                                          (element.campusUniforms)),
                                  facultyTagCount: item.facultyDaySheet.fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue +
                                          (element.regularCloths)),
                                  studentData: item.studentDaySheet,
                                  facultyData: item.facultyDaySheet,
                                  uid: item.uid!,
                                  collectionPickupTime: Utils.getTimeForStatus(
                                      'READY_TO_PICK',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  inTransitFromCampusTime:
                                      Utils.getTimeForStatus(
                                          'INTRANSIT_FROM_cAMPUS',
                                          item.statusEntry,
                                          item.currentStatus!,
                                          item.updatedAt!),
                                  deliveryToCampusTime: Utils.getTimeForStatus(
                                      'DELIVERED_TO_CAMPUS',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  uniform: item.campus.uniform,
                                  inTransitFromWarehouseTime:
                                      Utils.getTimeForStatus(
                                          'INTRANSIT_FROM_WAREHOUSE',
                                          item.statusEntry,
                                          item.currentStatus!,
                                          item.updatedAt!),
                                  pickupFromCampusTime: Utils.getTimeForStatus(
                                      'READY_TO_PICK',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  deliveredToWarehouse: Utils.getTimeForStatus(
                                      'DELIVERED_TO_WAREHOUSE',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  washingStartTime: Utils.getTimeForStatus(
                                      'WASHING',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  washingEndTime: Utils.getTimeForStatus(
                                      'WASHING_DONE',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  dryingStartTime: Utils.getTimeForStatus(
                                      'DRYING',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  dryingEndTime: Utils.getTimeForStatus(
                                      'DRYING_DONE',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  segStartTime: Utils.getTimeForStatus(
                                      'IN_SEGREGATION',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  segEndTime: Utils.getTimeForStatus(
                                      'SEGREGATION_DONE',
                                      item.statusEntry,
                                      item.currentStatus!,
                                      item.updatedAt!),
                                  employee: 'Washing',
                                );
                                // Get.to(() => WashingDetailsPage(
                                //       washingStartedAt: Utils.getTimeForStatus(
                                //           'WASHING',
                                //           washingController.employeeCollection
                                //               .value!.data[index].statusEntry),
                                //       washingCompletedAt:
                                //           Utils.getTimeForStatus(
                                //               'WASHING_DONE',
                                //               washingController
                                //                   .employeeCollection
                                //                   .value!
                                //                   .data[index]
                                //                   .statusEntry),
                                //       studentData: studentData,
                                //       facultyData: facultyData,
                                //       campusName:
                                //           item.campus.college.name ?? '',
                                //       date: Utils.formatDate(
                                //               time: item.createdAt!) ??
                                //           '',
                                //       collectionNo: item.id.toString(),
                                //       campusCode: item.campus.tagName!,
                                //       collectionUid: item.uid!,
                                //       status: item.currentStatus ?? '',
                                //       button: false,
                                //       updatedTime: Utils.formatDate(
                                //           time: item.updatedAt!),
                                //       isUniform: item.campus.uniform,
                                //     ));
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        }))),
        const SizedBox(
          height: 80,
        ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }
}
