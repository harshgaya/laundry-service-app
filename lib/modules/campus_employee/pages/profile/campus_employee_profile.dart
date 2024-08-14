import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/controllers/login_controller.dart';

import '../../widgets/profile_tile.dart';
import 'dart:io';

class CampusEmployeeProfile extends StatefulWidget {
  const CampusEmployeeProfile({super.key});

  @override
  State<CampusEmployeeProfile> createState() => _CampusEmployeeProfileState();
}

class _CampusEmployeeProfileState extends State<CampusEmployeeProfile> {
  final loginController = Get.put(LoginController());
  File? profileImage;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
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
                        ? Icon(
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
                        child: CircleAvatar(
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
              ProfileWidget(
                title: 'Nima',
                icon: Icons.person,
                function: () {},
              ),
              ProfileWidget(
                title: '8096574675',
                icon: Icons.mobile_screen_share_sharp,
                function: () {},
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
      ),
    );
  }
}
