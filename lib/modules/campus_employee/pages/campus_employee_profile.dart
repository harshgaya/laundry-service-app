import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/modules/authentication/controllers/login_controller.dart';

import '../widgets/profile_tile.dart';

class CampusEmployeeProfile extends StatefulWidget {
  const CampusEmployeeProfile({super.key});

  @override
  State<CampusEmployeeProfile> createState() => _CampusEmployeeProfileState();
}

class _CampusEmployeeProfileState extends State<CampusEmployeeProfile> {
  final loginController = Get.put(LoginController());
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
              const CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
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
                title: 'Name',
                icon: Icons.person,
                function: () {},
              ),
              ProfileWidget(
                title: 'Mobile',
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
