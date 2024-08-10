import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/driver/pages/vehicle_inspection/driver_vehicle_inspection_odometer.dart';

import '../../../campus_employee/pages/campus_employee_profile.dart';

class VehicleInspectionPage1 extends StatefulWidget {
  const VehicleInspectionPage1({super.key});

  @override
  State<VehicleInspectionPage1> createState() => _VehicleInspectionPageState();
}

class _VehicleInspectionPageState extends State<VehicleInspectionPage1> {
  String selectedVehicle = 'Select Vehicle';
  List<String> vehicles = ['Bicycle', 'Motorcycle', 'Vans', 'Pickup Trucks'];
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
                  Text('Login Time :${DateFormat.jm().format(DateTime.now())}'),
                  InkWell(
                    onTap: () {
                      Get.to(() => CampusEmployeeProfile());
                    },
                    child: Row(
                      children: [
                        Text(
                          'Nima',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Text(
                            'N',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                              child: ListView.builder(
                                  itemCount: vehicles.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        selectedVehicle = vehicles[index];
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ListTile(
                                          title: Text(vehicles[index]),
                                        ),
                                      ),
                                    );
                                  }),
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
              InkWell(
                onTap: () {
                  if (selectedVehicle == 'Select Vehicle') {
                    Utils.showScaffoldMessageI(
                        context: context, title: 'Please select vehicle');
                  } else {
                    Get.to(() => DriverVehicleInspectionOdometer());
                  }
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Start Inspection',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
