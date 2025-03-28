import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/modules/segregation/controler/seg_controller.dart';

import '../../../../helpers/utils.dart';
import '../../../authentication/controllers/login_controller.dart';
import '../../../campus_employee/widgets/profile_tile.dart';
import '../../../drying/pages/drying_remarks_page.dart';
import 'dart:io';

class SegProfile extends StatefulWidget {
  const SegProfile({super.key});

  @override
  State<SegProfile> createState() => _SegProfileState();
}

class _SegProfileState extends State<SegProfile> {
  final loginController = Get.put(LoginController());
  final segController = Get.put(SegController());
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
                title: segController.userName.value,
                icon: Icons.person,
                function: () {},
              ),
            ),
            Obx(
              () => ProfileWidget(
                title: segController.mobileNumber.value,
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
