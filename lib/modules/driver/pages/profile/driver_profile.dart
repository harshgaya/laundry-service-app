import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/driver/controllers/driver_controller.dart';
import 'package:laundry_service/modules/driver/pages/profile/driver_add_complaint.dart';
import 'package:laundry_service/modules/driver/pages/profile/driver_details.dart';
import 'package:laundry_service/modules/driver/pages/profile/driver_expenses.dart';
import '../../../../helpers/utils.dart';
import '../../../authentication/controllers/login_controller.dart';
import '../../../campus_employee/widgets/profile_tile.dart';
import 'dart:io';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  final loginController = Get.put(LoginController());
  final driverController = Get.put(DriverController());
  File? profileImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 50,
                  child: profileImage == null
                      ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        )
                      : ClipOval(
                          child: Image.file(
                            profileImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () async {
                        profileImage = await Utils.captureImage();
                        setState(() {});
                      },
                      child: const CircleAvatar(
                        child: Icon(Icons.edit),
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Obx(
              () => ProfileWidget(
                title: driverController.userName.value,
                icon: Icons.person,
                function: () {},
              ),
            ),
            Obx(
              () => ProfileWidget(
                title: driverController.mobileNumber.value,
                icon: Icons.mobile_screen_share_sharp,
                function: () {},
              ),
            ),
            ProfileWidget(
              title: 'Attendance',
              icon: Icons.keyboard,
              function: () {},
            ),
            ProfileWidget(
              title: 'Logout',
              icon: Icons.logout,
              function: () {
                loginController.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
