import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/modules/driver/pages/driver_dashboard.dart';
import 'dart:io';

import '../../../../helpers/utils.dart';

class VehicleInspectionBack extends StatefulWidget {
  const VehicleInspectionBack({super.key});

  @override
  State<VehicleInspectionBack> createState() => _VehicleInspectionBackState();
}

class _VehicleInspectionBackState extends State<VehicleInspectionBack> {
  File? _image;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Back Side',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Please take a photo of the\nBack of the Vehicle',
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _image == null
                ? InkWell(
                    onTap: () async {
                      _image = await Utils.captureImage();
                      setState(() {});
                    },
                    child: const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.camera_alt,
                        size: 120,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      _image = await Utils.captureImage();
                      setState(() {});
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.file(
                        _image!,
                        height: 120,
                      ),
                    )),
            const Spacer(),
            InkWell(
              onTap: () {
                if (_image == null) {
                  Utils.showScaffoldMessageI(
                      context: context, title: 'Please select back image');
                } else {
                  Get.offAll(() => DriverDashboard());
                  //Get.to(() => DriverVehicleInspectionOdometer());
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
                              'Next',
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
    );
  }
}
