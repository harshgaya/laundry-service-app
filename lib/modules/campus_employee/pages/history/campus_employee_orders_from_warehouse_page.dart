import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../driver/widgets/task_count_widget.dart';
import '../../../driver/widgets/task_tile_widget.dart';
import '../../widgets/show_collection_bottom_sheet.dart';

class CampusEmployeeOrderFromWarehouse extends StatefulWidget {
  const CampusEmployeeOrderFromWarehouse({super.key});

  @override
  State<CampusEmployeeOrderFromWarehouse> createState() =>
      _CampusEmployeeOrderFromWarehouseState();
}

class _CampusEmployeeOrderFromWarehouseState
    extends State<CampusEmployeeOrderFromWarehouse> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  int? id;
  String? dateCreated;
  String? deliveryStatus;
  int? studentTagCount;
  int? facultyTagCount;
  DateTime? startDate;
  DateTime? endDate;
  bool showDate = false;
  String? uid;
  bool selected1 = true;
  bool selected2 = false;

  @override
  void initState() {
    super.initState();
    campusEmployeeController.loadActiveInactive();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
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
                        'History',
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
                    child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TaskCountWidget(
                          title: 'To Do',
                          count:
                              '${campusEmployeeController.activeCollection.value?.data.where((element) => element.currentStatus == 'READY_TO_PICK').length ?? '0'}'),
                      TaskCountWidget(
                          title: 'Open',
                          count:
                              '${campusEmployeeController.activeCollection.value?.data.where((element) => element.currentStatus == 'DELIVERED_TO_CAMPUS').length ?? '0'}'),
                      TaskCountWidget(
                          title: 'Finished',
                          count:
                              '${campusEmployeeController.activeCollection.value?.data.where((element) => element.currentStatus == 'DELIVERED_TO_STUDENT').length ?? '0'}'),
                    ],
                  ),
                )),
              ),
            ),
          ],
        ),
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
          height: 10,
        ),
        // if (selected1)
        Obx(() {
          return Expanded(
            child: campusEmployeeController.gettingActiveCollection.value
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                        size: 40,
                        color: Colors.blue,
                        secondRingColor: const Color(0xFF1A1A3F),
                        thirdRingColor: const Color(0xFFEA3799)))
                : campusEmployeeController.activeCollection.value == null
                    ? const SizedBox()
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: campusEmployeeController
                                .activeCollection.value?.data.length ??
                            0,
                        itemBuilder: (BuildContext context, int index) {
                          final item = campusEmployeeController
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
                              title1: Utils.formatDate(
                                      time: createdAt.toString()) ??
                                  '',
                              title2: item.currentStatus ?? '',
                              title3: 'Collection No-${item.id}',
                              title4: item.campus.college.name ?? '',
                              icon: Icons.bookmark,
                              color2: Colors.green,
                              function: () {
                                uid = item.uid;

                                setState(() {
                                  id = item.id;
                                  dateCreated = Utils.formatDate(
                                      time: item.studentDaySheet[0].createdAt!);
                                  // dateCreated = DateFormat('dd-MM-yyyy hh:mm a')
                                  //     .format(DateTime.parse(
                                  //         item.studentDaySheet[0].createdAt!))
                                  //     .toString();
                                  deliveryStatus = item.currentStatus;
                                  studentTagCount = item.studentDaySheet.fold(
                                      0,
                                      (previousValue, element) =>
                                          (previousValue ?? 0) +
                                          (element.campusRegularCloths) +
                                          (element.campusUniforms));
                                  facultyTagCount = item.facultyDaySheet.fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue! +
                                          (element.regularCloths));
                                });
                                showCollectionDetailsSheet(
                                  context: context,
                                  id: id.toString(),
                                  dateCreated: dateCreated!,
                                  deliveryStatus: deliveryStatus!,
                                  studentTagCount: studentTagCount!,
                                  facultyTagCount: facultyTagCount!,
                                  studentData: item.studentDaySheet,
                                  facultyData: item.facultyDaySheet,
                                  uid: uid!,
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
                                  employee: 'Campus',
                                  otherCloth: item.otherClothDaySheet,
                                );
                              },
                            );
                          } else {
                            return const SizedBox(); // Hide items outside the range
                          }
                        },
                      ),
          );
        }),

        const SizedBox(
          height: 80,
        ),
      ],
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  _selectDateRange(context);
                },
                child: const Text(
                  'Select Date Range',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (startDate != null && endDate != null)
          Text(
            'Selected Date Range: ${DateFormat.yMMMd().format(startDate!)} - ${DateFormat.yMMMd().format(endDate!)}',
            style: const TextStyle(fontSize: 16),
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
