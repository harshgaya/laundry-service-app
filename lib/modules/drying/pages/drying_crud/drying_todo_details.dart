import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/drying/pages/drying_crud/select_dry_area.dart';
import 'package:laundry_service/modules/drying/pages/drying_crud/start_drying_page.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../campus_employee/models/day_sheet_history.dart';
import '../../../washing/pages/day_sheet_data.dart';

class DryingToDoDetails extends StatefulWidget {
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final String campusName;
  final String date;
  final String collectionNo;
  final String campusCode;
  final String collectionUid;
  final String status;
  final bool button;
  final String dryingStartedAt;
  final String dryingCompletedAt;
  final bool isUniform;
  final String campusId;
  final String campusColor;
  final List<OtherClothDaySheet> otherCloth;
  const DryingToDoDetails(
      {super.key,
      required this.studentData,
      required this.facultyData,
      required this.campusColor,
      required this.campusName,
      required this.date,
      required this.collectionNo,
      required this.campusCode,
      required this.collectionUid,
      required this.status,
      required this.button,
      required this.dryingStartedAt,
      required this.dryingCompletedAt,
      required this.isUniform,
      required this.campusId,
      required this.otherCloth});

  @override
  State<DryingToDoDetails> createState() => _DryingToDoDetailsState();
}

class _DryingToDoDetailsState extends State<DryingToDoDetails> {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TO DO\nTask',
                  style: GoogleFonts.roboto(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
            if (!widget.button)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Drying Started At',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.dryingStartedAt,
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
                        'Drying Completed At',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.dryingCompletedAt,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const Spacer(),
            if (widget.button)
              Align(
                alignment: Alignment.center,
                child: RoundButtonAnimate(
                  buttonName: 'Start Drying',
                  onClick: () {
                    // Get.to(() => const StartDryingPage());
                    if (widget.status == 'DRYING') {
                      Get.to(() => StartDryingPage(
                            campusName: widget.campusName,
                            date: widget.date,
                            collectionNo: widget.collectionNo,
                            collectionId: widget.collectionUid,
                            status: widget.status,
                            campusId: widget.campusId,
                          ));
                    } else {
                      Get.to(() => SelectDryArea(
                            campusName: widget.campusName,
                            date: widget.date,
                            collectionNo: widget.collectionNo,
                            collectionId: widget.collectionUid,
                            status: widget.status,
                            isButton: true,
                            campusId: widget.campusId,
                            campusColor: widget.campusColor,
                          ));
                    }
                  },
                  image: Image.asset(
                    'assets/icons/washing.png',
                    height: 30,
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
