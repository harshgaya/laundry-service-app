import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:laundry_service/helpers/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../widegets/round_button_animate.dart';
import '../../controllers/driver_controller.dart';

class DriverVehicleInspectionOdometer extends StatefulWidget {
  final String vehicleUid;
  const DriverVehicleInspectionOdometer({super.key, required this.vehicleUid});

  @override
  State<DriverVehicleInspectionOdometer> createState() =>
      _DriverVehicleInspectionOdometerState();
}

class _DriverVehicleInspectionOdometerState
    extends State<DriverVehicleInspectionOdometer> {
  File? _image;
  final driverController = Get.put(DriverController());

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
              'Odometer',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Please take a photo of the\nOdometer of the Vehicle',
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
            Obx(() => driverController.updatingVehicle.value
                ? Center(
                    child: LoadingAnimationWidget.discreteCircle(
                        size: 40,
                        color: Colors.blue,
                        secondRingColor: const Color(0xFF1A1A3F),
                        thirdRingColor: const Color(0xFFEA3799)),
                  )
                : Center(
                    child: RoundButtonAnimate(
                        buttonName: 'Home',
                        onClick: () {
                          if (_image == null) {
                            Utils.showScaffoldMessageI(
                                context: context,
                                title: 'Please upload odometer image!');
                          } else {
                            driverController.updateVehicle(
                                vehicleUid: widget.vehicleUid,
                                image: _image!,
                                context: context);
                          }
                        },
                        image: const Icon(
                          Icons.delivery_dining,
                          color: Colors.white,
                        )),
                  )),
          ],
        ),
      ),
    );
  }
}
