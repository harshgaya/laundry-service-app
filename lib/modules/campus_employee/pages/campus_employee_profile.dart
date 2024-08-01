import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/modules/authentication/controllers/login_controller.dart';

class CampusEmployeeProfile extends StatefulWidget {
  const CampusEmployeeProfile({super.key});

  @override
  State<CampusEmployeeProfile> createState() => _CampusEmployeeProfileState();
}

class _CampusEmployeeProfileState extends State<CampusEmployeeProfile> {
  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
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
          Text(
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
          ),
          ProfileWidget(
            title: 'Mobile',
            icon: Icons.mobile_screen_share_sharp,
          ),
          ProfileWidget(
            title: 'Attendance',
            icon: Icons.keyboard,
          ),
          InkWell(
            onTap: () {
              loginController.logout();
            },
            child: ProfileWidget(
              title: 'Logout',
              icon: Icons.logout,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  const ProfileWidget({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          width: Get.width,
          height: 2,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
