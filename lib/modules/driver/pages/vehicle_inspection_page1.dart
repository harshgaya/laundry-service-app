import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';
import 'package:laundry_service/modules/driver/pages/driver_dashboard.dart';
import 'package:laundry_service/modules/driver/pages/vehicle_inspection_page2.dart';

class VehicleInspectionPage1 extends StatefulWidget {
  const VehicleInspectionPage1({super.key});

  @override
  State<VehicleInspectionPage1> createState() => _VehicleInspectionPageState();
}

class _VehicleInspectionPageState extends State<VehicleInspectionPage1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WhiteContainer(widget: Text('User Id')),
                  WhiteContainer(widget: Text('${DateTime.now().toString()}'))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const VehicleInspectionPage2());
                },
                child: const WhiteContainer(
                    widget:
                        Text('Vehicle Inspection\nBefore Starting Delivery')),
              ),
              const SizedBox(
                height: 20,
              ),
              const WhiteContainer(widget: Text('Meter Reading')),
              const SizedBox(
                height: 20,
              ),
              const WhiteContainer(
                widget: Column(
                  children: [Icon(Icons.camera_alt_rounded), Text('Capture')],
                ),
              ),
              const SizedBox(
                height: 200,
              ),
              InkWell(
                  onTap: () {
                    Get.offAll(() => DriverDashboard());
                  },
                  child: WhiteContainer(widget: Text('Finish'))),
            ],
          ),
        ),
      ),
    );
  }
}
