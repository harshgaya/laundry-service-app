import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import '../../../../helpers/utils.dart';
import '../../../authentication/controllers/login_controller.dart';
import '../../../campus_employee/widgets/profile_tile.dart';
import '../../../driver/pages/profile/driver_details.dart';
import 'dart:io';

class WashingProfile extends StatefulWidget {
  const WashingProfile({super.key});

  @override
  State<WashingProfile> createState() => _WashingProfileState();
}

class _WashingProfileState extends State<WashingProfile> {
  final loginController = Get.put(LoginController());
  final washingController = Get.put(WashingController());
  File? profileImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: MediaQuery.of(context).padding.top),
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
                title: washingController.userName.value,
                icon: Icons.person,
                function: () {},
              ),
            ),
            Obx(
              () => ProfileWidget(
                title: washingController.mobileNumber.value,
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
