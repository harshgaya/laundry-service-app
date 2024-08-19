import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/driver/pages/profile/driver_add_complaint.dart';
import 'package:laundry_service/modules/driver/pages/profile/driver_details.dart';
import 'package:laundry_service/modules/driver/pages/profile/driver_expenses.dart';
import '../../../authentication/controllers/login_controller.dart';
import '../../../campus_employee/widgets/profile_tile.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
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
              // ProfileWidget(
              //   title: 'Complaints',
              //   icon: Icons.support_agent,
              //   function: () {
              //     Get.to(() => const DriverAddComplaint());
              //   },
              // ),
              // ProfileWidget(
              //   title: 'Expenses',
              //   icon: Icons.currency_rupee,
              //   function: () {
              //     Get.to(() => DriverExpensed());
              //   },
              // ),
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
