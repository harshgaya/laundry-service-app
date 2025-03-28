import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/driver/pages/driver_crud/pickup_drop_select_student_or_faculty.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../campus_employee/models/day_sheet_history.dart';
import '../../../washing/pages/day_sheet_data.dart';

class ToDoListViewDriver extends StatefulWidget {
  final bool isButton;
  final bool isUniform;
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final String campusName;
  final String date;
  final String collectionNo;
  final String campusCode;
  final String collectionUid;
  final String status;
  final String deliveryFromWarehouse;
  final String intransitFromWarehouse;
  final String deliveredToCampus;
  final String pickupFromCampus;
  final String intransitFromCampus;
  final String deliveredToWarehouse;
  final List<FacultyDaySheet> facultyList;
  final List<OtherClothDaySheet> otherCloth;
  const ToDoListViewDriver(
      {super.key,
      required this.studentData,
      required this.facultyData,
      required this.campusName,
      required this.date,
      required this.collectionNo,
      required this.campusCode,
      required this.collectionUid,
      required this.status,
      required this.isButton,
      required this.facultyList,
      required this.deliveryFromWarehouse,
      required this.intransitFromWarehouse,
      required this.deliveredToCampus,
      required this.pickupFromCampus,
      required this.intransitFromCampus,
      required this.deliveredToWarehouse,
      required this.isUniform,
      required this.otherCloth});

  @override
  State<ToDoListViewDriver> createState() => _ToDoListViewDriverState();
}

class _ToDoListViewDriverState extends State<ToDoListViewDriver> {
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isButton ? 'TO DO\nTask' : 'Task',
                    style: GoogleFonts.roboto(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Get.to(() => DaySheetData(
                            studentData: widget.studentData,
                            facultyData: widget.facultyData,
                            isUniform: widget.isUniform,
                            otherCloth: widget.otherCloth,
                          ));
                    },
                    child: const Text(
                      'Day Sheet',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Campus Name',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      widget.campusName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.date,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Collection No',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.collectionNo,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Tag Count',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.studentData
                        .fold(
                            0,
                            (sum, order) =>
                                sum +
                                order.campusRegularCloths +
                                order.campusUniforms)
                        .toString(),
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Faculty Count',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    widget.facultyData
                        .fold(0, (sum, order) => sum + order.regularCloths)
                        .toString(),
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (!widget.isButton)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery From Warehouse',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.deliveryFromWarehouse,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Intransit From Warehouse',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.intransitFromCampus,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivered To Campus',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.deliveredToCampus,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pickup From Campus',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.pickupFromCampus,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Intransit From Campus',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.intransitFromCampus,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivered To Warehouse',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.deliveredToWarehouse,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(
                height: 100,
              ),
              if (widget.isButton)
                Align(
                  alignment: Alignment.center,
                  child: RoundButtonAnimate(
                    buttonName: 'Pickup',
                    onClick: () {
                      Get.to(() => PickUpDropSelectStudentFaculty(
                            campusCode: widget.campusCode,
                            campusName: widget.campusName,
                            collectionUid: widget.collectionUid,
                            status: widget.status,
                            facultyList: widget.facultyList,
                          ));
                    },
                    image: Image.asset(
                      'assets/icons/pickup.png',
                      height: 60,
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
