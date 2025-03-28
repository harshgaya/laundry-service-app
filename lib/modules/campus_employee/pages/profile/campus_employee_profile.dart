import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/controllers/login_controller.dart';

import '../../controllers/campus_employee_controller.dart';
import '../../widgets/profile_tile.dart';
import 'dart:io';

class CampusEmployeeProfile extends StatefulWidget {
  const CampusEmployeeProfile({super.key});

  @override
  State<CampusEmployeeProfile> createState() => _CampusEmployeeProfileState();
}

class _CampusEmployeeProfileState extends State<CampusEmployeeProfile> {
  final loginController = Get.put(LoginController());
  final campusEmployeeController = Get.put(CampusEmployeeController());
  File? profileImage;
  String? employeeProfileImage;
  bool uploadingImage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginController.getProfileImage().then((value) {
      print('value image $value');
      employeeProfileImage = value;
      setState(() {});
    });
  }

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
            uploadingImage
                ? const CircularProgressIndicator()
                : Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 50,
                        child: employeeProfileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              )
                            : ClipOval(
                                child: Image.network(
                                  employeeProfileImage!,
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
                              await Utils.captureImage().then((value) async {
                                if (value != null) {
                                  setState(() {
                                    uploadingImage = true;
                                  });
                                  await loginController.updateProfile(
                                      profileImage: value);
                                  await loginController.getProfileImage().then(
                                      (value) => employeeProfileImage = value);
                                  setState(() {
                                    uploadingImage = false;
                                  });
                                }
                              });
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
                title: campusEmployeeController.userName.value,
                icon: Icons.person,
                function: () {},
              ),
            ),
            Obx(
              () => ProfileWidget(
                title: campusEmployeeController.mobileNumber.value,
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
