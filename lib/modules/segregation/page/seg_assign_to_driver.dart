import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/widgets/drop_down_widget.dart';
import 'package:laundry_service/modules/segregation/controler/seg_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../campus_employee/controllers/campus_employee_controller.dart';
import '../../campus_employee/widgets/round_button_custom.dart';
import '../../widegets/round_button_animate.dart';

class SegAssignToDriver extends StatefulWidget {
  final List<CampusEmployeeStudentDaySheetCompareData> studentData;
  final List<CampusEmployeeFacultyDaySheetCompareData> facultyData;
  final String campusName;
  final String date;
  final String collectionNo;
  final String campusCode;
  final String collectionUid;
  final String status;
  final bool button;
  final int maxStudentCount;
  final bool isUniform;
  final Map<String, dynamic> completedRange;
  const SegAssignToDriver({
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
    required this.maxStudentCount,
    required this.isUniform,
    required this.completedRange,
  });

  @override
  State<SegAssignToDriver> createState() => _SegAssignToDriverState();
}

class _SegAssignToDriverState extends State<SegAssignToDriver> {
  final segController = Get.put(SegController());
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
            Text(
              'Assign to Driver',
              style: GoogleFonts.roboto(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 20,
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
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 20,
            ),
            const Spacer(),
            Obx(
              () => segController.assignToDriver.value
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                          size: 40,
                          color: Colors.blue,
                          secondRingColor: const Color(0xFF1A1A3F),
                          thirdRingColor: const Color(0xFFEA3799)),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: RoundButtonAnimate(
                        buttonName: 'Assign to Driver',
                        onClick: () async {
                          final listOfRanges = [
                            ...segController.generateRanges(
                              segController.getHighestNumber(
                                widget.studentData.map((e) => e.tagNo).toList(),
                              ),
                            )
                          ];
                          print('ranges $listOfRanges');
                          print('completd range ${widget.completedRange}');
                          listOfRanges.forEach((element) async {
                            if (widget.completedRange.containsKey(element)) {
                              print('range completed');
                              await segController.updateStatus2(
                                  collectionId: widget.collectionUid,
                                  context: context);
                            } else {
                              print('range not completed');
                            }
                          });
                        },
                        image: const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
