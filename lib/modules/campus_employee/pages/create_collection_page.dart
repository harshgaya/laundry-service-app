import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_dashboard.dart';
import 'package:laundry_service/modules/campus_employee/pages/profile/campus_employee_profile.dart';

import '../../widegets/round_button_animate.dart';
import 'create_collection_view.dart';

class CreateCollectionPage extends StatefulWidget {
  const CreateCollectionPage({super.key});

  @override
  State<CreateCollectionPage> createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    campusEmployeeController.getUserId();
    campusEmployeeController.getCollege();
    campusEmployeeController.getLatestCollectionId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Login Time :${DateFormat.jm().format(DateTime.now())}'),
                InkWell(
                  onTap: () {
                    Get.to(() => const CampusEmployeeProfile());
                  },
                  child: Row(
                    children: [
                      Obx(
                        () => Text(
                          campusEmployeeController.userName.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Obx(
                        () => CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Text(
                            campusEmployeeController.userName.value.isEmpty
                                ? ''
                                : campusEmployeeController.userName.value[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 80,
            ),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('College Name',
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                        fontSize: 25,
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    campusEmployeeController
                            .collegeCampus.value?.data[0].college.name ??
                        '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Obx(
              () => campusEmployeeController.creatingCollection.value
                  ? const CircularProgressIndicator()
                  : RoundButtonAnimate(
                      buttonName: 'New Collection',
                      onClick: () {
                        Get.to(() => const CreateCollectionView());
                      },
                      image: Image.asset(
                        'assets/gifs/collection.gif',
                        height: 60,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
