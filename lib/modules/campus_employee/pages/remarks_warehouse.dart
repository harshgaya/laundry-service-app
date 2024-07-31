import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/pages/view_remarks_from_warehouse.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class RemarksWarehouse extends StatefulWidget {
  const RemarksWarehouse({super.key});

  @override
  State<RemarksWarehouse> createState() => _RemarksWarehouseState();
}

class _RemarksWarehouseState extends State<RemarksWarehouse> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
              onTap: () {
                Get.to(() => ViewRemarksFromWarehouse());
              },
              child:
                  WhiteContainer(widget: Text('View Remarks\nFrom Warehouse'))),
          WhiteContainer(widget: Text('Add Remarks')),
          WhiteContainer(widget: Text('Untaken Cloths')),
        ],
      ),
    );
  }
}
