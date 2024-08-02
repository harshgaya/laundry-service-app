import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/modules/campus_employee/pages/add_remarks_to_warehouse.dart';
import 'package:laundry_service/modules/campus_employee/pages/untaken_cloths_to_warehouse.dart';
import 'package:laundry_service/modules/campus_employee/pages/warehouse_view_remarks_pdfview.dart';

class WarehouseRemarksDetails extends StatefulWidget {
  const WarehouseRemarksDetails({super.key});

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
          icon: CircleAvatar(
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
                Get.to(() => WarehouseViewRemarksPdfView());
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
                      Text(
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
                Get.to(() => AddRemarksToWarehouse());
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
                      Text(
                        'Add Remarks',
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
                Get.to(() => UntakenClothsWarehouse());
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
                      Text(
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
