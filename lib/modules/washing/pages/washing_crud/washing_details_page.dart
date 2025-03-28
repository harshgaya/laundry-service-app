import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import 'package:laundry_service/modules/washing/pages/day_sheet_data.dart';
import 'package:laundry_service/modules/washing/pages/washing_crud/start_washing_page.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../campus_employee/models/day_sheet_history.dart';

class WashingDetailsPage extends StatefulWidget {
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final String campusName;
  final String date;
  final String collectionNo;
  final String campusCode;
  final String collectionUid;
  final String status;
  final bool button;
  final String updatedTime;
  final String washingStartedAt;
  final String washingCompletedAt;
  final bool isUniform;
  final List<OtherClothDaySheet> otherCloth;
  const WashingDetailsPage({
    super.key,
    required this.studentData,
    required this.facultyData,
    required this.campusName,
    required this.date,
    required this.collectionNo,
    required this.campusCode,
    required this.collectionUid,
    required this.status,
    required this.button,
    required this.updatedTime,
    required this.washingStartedAt,
    required this.washingCompletedAt,
    required this.isUniform,
    required this.otherCloth,
  });

  @override
  State<WashingDetailsPage> createState() => _WashingDetailsPageState();
}

class _WashingDetailsPageState extends State<WashingDetailsPage> {
  String? selectedMachine;
  List<String> machines = ['Machine 1', 'Machine 2', 'Machine 3', 'Machine 4'];
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
            if (!widget.button)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Washing Started At',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.washingStartedAt,
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
                        'Washing Completed At',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.washingCompletedAt,
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
                child: Column(
                  children: [
                    RoundButtonAnimate(
                      buttonName: 'Start Washing',
                      onClick: () {
                        Get.to(() => StartWashingPage(
                              campusName: widget.campusName,
                              date: widget.date,
                              collectionNo: widget.collectionNo,
                              collectionId: widget.collectionUid,
                              status: widget.status,
                              updatedTime: widget.updatedTime,
                            ));
                      },
                      image: Image.asset(
                        'assets/icons/washing.png',
                        height: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          Utils.addNoTagDialog(
                            context: context,
                            collectionId: widget.collectionUid,
                          );
                        },
                        child: const Text(
                          'No Tag',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
