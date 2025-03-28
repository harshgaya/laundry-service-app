import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/modules/campus_employee/pages/remarks/add_remarks_to_warehouse.dart';
import 'package:laundry_service/modules/campus_employee/pages/remarks/untaken_cloths_to_warehouse.dart';
import 'package:laundry_service/modules/campus_employee/pages/remarks/warehouse_view_remarks_pdfview.dart';

import '../../controllers/campus_employee_controller.dart';
import '../../models/day_sheet_history.dart';

class WarehouseRemarksDetails extends StatefulWidget {
  final String collectionId;
  final String tagId;
  final String campusId;
  final List<StudentRemark> studentRemark;
  final List<WarehouseRemark> warehouseRemarkList;
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final String collectionNo;
  const WarehouseRemarksDetails(
      {super.key,
      required this.collectionId,
      required this.tagId,
      required this.campusId,
      required this.studentData,
      required this.facultyData,
      required this.warehouseRemarkList,
      required this.collectionNo,
      required this.studentRemark});

  @override
  State<WarehouseRemarksDetails> createState() =>
      _WarehouseRemarksDetailsState();
}

class _WarehouseRemarksDetailsState extends State<WarehouseRemarksDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Warehouse Remarks Details',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => WarehouseViewRemarksPdfView(
                      warehouseRemarkList: widget.warehouseRemarkList,
                      collectionNo: widget.collectionNo,
                    ));
              },
              child: Container(
                width: Get.width,
                height: 170,
                decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'View Remarks\nFrom Warehouse',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Image.asset(
                        'assets/images/warehouse.png',
                        height: 80,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => AddRemarksToWarehouse(
                      tagName: widget.tagId,
                      campusId: widget.campusId,
                      collectionId: widget.collectionId,
                      studentRemark: widget.studentRemark,
                    ));
              },
              child: Container(
                width: Get.width,
                height: 170,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Add Complain',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Image.asset(
                        'assets/images/add_remark.png',
                        height: 80,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => UntakenClothsWarehouse(
                      studentData: widget.studentData
                          .where((element) => element.delivered == false)
                          .toList(),
                      facultyData: widget.facultyData
                          .where((element) => element.delivered == false)
                          .toList(),
                      collectionId: widget.collectionId,
                    ));
              },
              child: Container(
                width: Get.width,
                height: 170,
                decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Untaken Cloths',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Image.asset(
                        'assets/images/untaken_cloth.png',
                        height: 80,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
