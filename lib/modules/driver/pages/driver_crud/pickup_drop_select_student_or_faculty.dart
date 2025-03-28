import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/driver/pages/driver_crud/driver_enter_bag_details_faculty.dart';
import 'package:laundry_service/modules/driver/pages/driver_crud/driver_enter_bag_details_student.dart';
import 'package:laundry_service/modules/driver/pages/driver_crud/driver_enter_other_cloths.dart';

import '../../../../helpers/utils.dart';
import '../../../campus_employee/models/day_sheet_history.dart';
import '../../../widegets/round_button_animate.dart';
import '../../controllers/driver_controller.dart';

class PickUpDropSelectStudentFaculty extends StatefulWidget {
  final String campusCode;
  final String campusName;
  final String collectionUid;
  final String status;
  final List<FacultyDaySheet> facultyList;
  const PickUpDropSelectStudentFaculty(
      {super.key,
      required this.campusCode,
      required this.campusName,
      required this.collectionUid,
      required this.status,
      required this.facultyList});

  @override
  State<PickUpDropSelectStudentFaculty> createState() =>
      _PickUpDropSelectStudentFacultyState();
}

class _PickUpDropSelectStudentFacultyState
    extends State<PickUpDropSelectStudentFaculty> {
  final driverController = Get.put(DriverController());
  String pickOrDrop() {
    if (widget.status == 'READY_FOR_DELIVERY') {
      return 'Pick Up From Warehouse';
    }
    if (widget.status == 'INTRANSIT_FROM_WAREHOUSE') {
      return 'Drop To Campus';
    }
    if (widget.status == 'READY_TO_PICK') {
      return 'Pick Up From Campus';
    }
    if (widget.status == 'INTRANSIT_FROM_cAMPUS') {
      return 'Drop To Warehouse';
    }
    return 'Not Defined';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const CircleAvatar(
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
                pickOrDrop(),
                style: GoogleFonts.roboto(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.campusName,
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
                      // if (driverController.bagList.isNotEmpty) {
                      //   return;
                      // }
                      Get.to(() => DriverEnterBagDetailsStudents(
                            campusCode: widget.campusCode,
                            campusName: widget.campusName,
                            collectionUid: widget.collectionUid,
                            status: widget.status,
                          ));
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
                            const Text(
                              'Student Clothes',
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
                      // if (driverController.teacherBagNoList.isNotEmpty) {
                      //   return;
                      // }
                      Get.to(() => DriverEnterBagDetailsFaculty(
                            facultyData: widget.facultyList,
                            status: widget.status,
                            collectionId: widget.collectionUid,
                          ));
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
                            const Text(
                              'Faculty Clothes',
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
                      // if (driverController.otherClothList.isNotEmpty) {
                      //   return;
                      // }
                      Get.to(() => DriverEnterOtherCloths(
                            status: widget.status,
                            collectionId: widget.collectionUid,
                            campusCode: widget.campusCode,
                          ));
                    },
                    child: Container(
                      width: Get.width,
                      height: 150,
                      decoration: BoxDecoration(
                          color: driverController.bagListOtherCloth.isNotEmpty
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
                            const Text(
                              'Other Clothes',
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
                          driverController.hasUploadedBagNoFaculty.value =
                              false;
                          driverController.hasUploadedBagNoStudent.value =
                              false;
                          driverController.hasUploadedBagNoOther.value = false;
                          Get.offAll(() => const UserState());
                        },
                        title: 'Finished Adding all clothes');
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
