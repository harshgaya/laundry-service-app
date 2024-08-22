import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/drying/pages/drying_remarks_page.dart';

import '../../../authentication/controllers/login_controller.dart';
import '../../../campus_employee/widgets/profile_tile.dart';

class DryingProfile extends StatefulWidget {
  const DryingProfile({super.key});

  @override
  State<DryingProfile> createState() => _DryingProfileState();
}

class _DryingProfileState extends State<DryingProfile> {
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
              // ProfileWidget(
              //   title: 'Remarks',
              //   icon: Icons.edit,
              //   function: () {
              //     Get.to(() => DryingRemarks());
              //   },
              // ),
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
