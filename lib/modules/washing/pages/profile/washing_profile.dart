import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../authentication/controllers/login_controller.dart';
import '../../../campus_employee/widgets/profile_tile.dart';
import '../../../driver/pages/profile/driver_details.dart';

class WashingProfile extends StatefulWidget {
  const WashingProfile({super.key});

  @override
  State<WashingProfile> createState() => _WashingProfileState();
}

class _WashingProfileState extends State<WashingProfile> {
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
                title: 'Details',
                icon: Icons.person,
                function: () {
                  Get.to(() => const DriverDetails());
                },
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
