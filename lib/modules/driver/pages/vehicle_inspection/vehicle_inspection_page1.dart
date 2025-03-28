import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/driver/controllers/driver_controller.dart';
import 'package:laundry_service/modules/driver/pages/vehicle_inspection/driver_vehicle_inspection_odometer.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../campus_employee/pages/profile/campus_employee_profile.dart';

class VehicleInspectionPage1 extends StatefulWidget {
  const VehicleInspectionPage1({super.key});

  @override
  State<VehicleInspectionPage1> createState() => _VehicleInspectionPageState();
}

class _VehicleInspectionPageState extends State<VehicleInspectionPage1> {
  String selectedVehicle = 'Select Vehicle';
  String? selectedVehicleUid;
  final driverController = Get.put(DriverController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverController.getVehicleList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() => driverController.gettingVehicleList.value
            ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                    size: 40,
                    color: Colors.blue,
                    secondRingColor: const Color(0xFF1A1A3F),
                    thirdRingColor: const Color(0xFFEA3799)),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text('Vehicle Inspection',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                          fontSize: 25,
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: Get.width,
                                    height: 500,
                                    child: Obx(() => ListView.builder(
                                        itemCount: driverController
                                            .vehicleListData.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              selectedVehicle = driverController
                                                  .vehicleListData[index].name;
                                              selectedVehicleUid =
                                                  driverController
                                                      .vehicleListData[index]
                                                      .uid;
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: ListTile(
                                                title: Text(driverController
                                                    .vehicleListData[index]
                                                    .name),
                                              ),
                                            ),
                                          );
                                        })),
                                  ),
                                );
                              });
                        },
                        child: Text(
                          selectedVehicle,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )),
                    const Spacer(),
                    Center(
                      child: RoundButtonAnimate(
                          buttonName: 'Inspection',
                          onClick: () {
                            if (selectedVehicle == 'Select Vehicle') {
                              Utils.showScaffoldMessageI(
                                  context: context,
                                  title: 'Please select vehicle');
                            } else {
                              Get.to(() => DriverVehicleInspectionOdometer(
                                    vehicleUid: selectedVehicleUid!,
                                  ));
                            }
                          },
                          image: const Icon(
                            Icons.car_crash_sharp,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              )),
      ),
    );
  }
}
