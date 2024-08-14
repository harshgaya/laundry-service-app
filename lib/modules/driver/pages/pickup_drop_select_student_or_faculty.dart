import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/driver/pages/driver_enter_bag_details_faculty.dart';
import 'package:laundry_service/modules/driver/pages/driver_enter_bag_details_student.dart';
import 'package:laundry_service/modules/driver/pages/driver_enter_other_cloths.dart';

import '../../../helpers/utils.dart';
import '../../widegets/round_button_animate.dart';
import '../controllers/driver_controller.dart';

class PickUpDropSelectStudentFaculty extends StatefulWidget {
  const PickUpDropSelectStudentFaculty({super.key});

  @override
  State<PickUpDropSelectStudentFaculty> createState() =>
      _PickUpDropSelectStudentFacultyState();
}

class _PickUpDropSelectStudentFacultyState
    extends State<PickUpDropSelectStudentFaculty> {
  final driverController = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pickup',
                style: GoogleFonts.roboto(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Sri Chaitnya',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => InkWell(
                    onTap: () {
                      if (driverController.bagList.isNotEmpty) {
                        return;
                      }
                      Get.to(() => DriverEnterBagDetailsStudents());
                    },
                    child: Container(
                      width: Get.width,
                      height: 150,
                      decoration: BoxDecoration(
                          color: driverController.bagList.isNotEmpty
                              ? Colors.grey
                              : Colors.brown,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Student Cloths',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Image.asset(
                              'assets/images/warehouse.png',
                              height: 80,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Obx(() => InkWell(
                    onTap: () {
                      if (driverController.teacherBagNoList.isNotEmpty) {
                        return;
                      }
                      Get.to(() => DriverEnterBagDetailsFaculty());
                    },
                    child: Container(
                      width: Get.width,
                      height: 150,
                      decoration: BoxDecoration(
                          color: driverController.teacherBagNoList.isNotEmpty
                              ? Colors.grey
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Faculty Cloths',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Image.asset(
                              'assets/images/add_remark.png',
                              height: 80,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Obx(() => InkWell(
                    onTap: () {
                      if (driverController.otherClothList.isNotEmpty) {
                        return;
                      }
                      Get.to(() => DriverEnterOtherCloths());
                    },
                    child: Container(
                      width: Get.width,
                      height: 150,
                      decoration: BoxDecoration(
                          color: driverController.otherClothList.isNotEmpty
                              ? Colors.grey
                              : Colors.cyan,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Other Cloths',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Image.asset(
                              'assets/images/untaken_cloth.png',
                              height: 80,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: RoundButtonAnimate(
                  buttonName: 'Finish',
                  onClick: () {
                    Utils.showDialogPopUp(
                        context: context,
                        function: () {
                          Get.offAll(() => UserState());
                        },
                        title: 'Finished Adding all cloths');
                  },
                  image: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
