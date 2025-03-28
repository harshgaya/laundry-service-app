import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/segregation/controler/seg_controller.dart';
import 'package:laundry_service/modules/segregation/page/seg_crud/seg_enter_tagno.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import '../../../campus_employee/controllers/campus_employee_controller.dart';
import '../../../campus_employee/models/day_sheet_history.dart';
import '../../../campus_employee/widgets/drop_down_widget.dart';
import '../../../washing/pages/day_sheet_data.dart';

class SegToDoDetails extends StatefulWidget {
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final String campusName;
  final String date;
  final String collectionNo;
  final String campusCode;
  final String collectionUid;
  final String status;
  final bool button;
  final int maxStudentCount;
  final bool isUniform;
  final String tagId;
  final String segStarted;
  final String segCompleted;
  final String noTagValue;
  final List<OtherClothDaySheet> otherCloth;
  final Map<String, dynamic> completedRange;
  const SegToDoDetails(
      {super.key,
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
      required this.tagId,
      required this.isUniform,
      required this.segStarted,
      required this.segCompleted,
      required this.completedRange,
      required this.noTagValue,
      required this.otherCloth});

  @override
  State<SegToDoDetails> createState() => _SegToDoDetailsState();
}

class _SegToDoDetailsState extends State<SegToDoDetails> {
  final segController = Get.put(SegController());
  String? selectedTable;
  bool noTag = false;

  String? selectedRange;
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Assigned To Zone',
            //       style: GoogleFonts.roboto(
            //         fontWeight: FontWeight.w700,
            //         fontSize: 20,
            //       ),
            //     ),
            //     Text(
            //       '5',
            //       style: GoogleFonts.roboto(
            //         fontWeight: FontWeight.w400,
            //         fontSize: 20,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // DropDownWidget(
            //   hintText: 'Assign To Table',
            //   selectedText: selectedTable,
            //   listOfString: tables,
            //   onChanged: (newValue) {
            //     setState(() {
            //       selectedTable = newValue;
            //       // You can reset or modify other variables here if needed
            //     });
            //   },
            // ),
            const SizedBox(
              height: 10,
            ),
            if (!widget.button)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Segregation Started At',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.segStarted,
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
                        'Segregation Completed At',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        widget.segCompleted,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (widget.button)
              DropDownWidget(
                hintText: 'Select Range',
                selectedText: selectedRange,
                // listOfString: segController.generateRanges(
                //     segController.getHighestNumber(
                //         widget.studentData.map((e) => e.tagNo).toList())),
                listOfString: [
                  ...segController.generateRanges(
                    segController.getHighestNumber(
                      widget.studentData.map((e) => e.tagNumber!).toList(),
                    ),
                  ),
                  'No Tag',
                ],
                onChanged: (newValue) {
                  if (newValue == 'No Tag') {
                    // Utils.addNoTagDialog(
                    //     context: context, collectionId: widget.collectionUid);

                    setState(() {
                      noTag = true;
                    });
                  } else {
                    setState(() {
                      selectedRange = newValue;
                      noTag = false;
                    });
                  }
                },
              ),
            const Spacer(),
            if (widget.button)
              Align(
                alignment: Alignment.center,
                child: RoundButtonAnimate(
                  buttonName: 'Done',
                  onClick: () {
                    if (noTag) {
                      Get.to(() => SegEnterTagNo(
                            selectedRange: selectedRange ?? '100-200',
                            isUniform: widget.isUniform,
                            studentData: widget.studentData,
                            facultyData: widget.facultyData,
                            collectionId: widget.collectionUid,
                            status: widget.status,
                            tagId: widget.tagId,
                            noTag: noTag,
                            noTagValue: widget.noTagValue,
                          ));
                      return;
                    }
                    if (selectedRange == null) {
                      Utils.showScaffoldMessageI(
                          context: context, title: 'Please select range');
                    } else {
                      final item = segController.employeeCollection.value?.data
                          .firstWhereOrNull(
                              (element) => element.uid == widget.collectionUid);
                      if (item != null) {
                        if (item.completedSegRange.containsKey(selectedRange)) {
                          Utils.showScaffoldMessageI(
                              context: context,
                              title: 'This range already completed.');
                          return;
                        } else {
                          Get.to(() => SegEnterTagNo(
                                selectedRange: selectedRange!,
                                isUniform: widget.isUniform,
                                studentData: widget.studentData,
                                facultyData: widget.facultyData,
                                collectionId: widget.collectionUid,
                                status: widget.status,
                                tagId: widget.tagId,
                                noTag: noTag,
                                noTagValue: widget.noTagValue,
                              ));
                        }
                      } else {
                        Utils.showScaffoldMessageI(
                            context: context,
                            title: 'Collection does not exist!');
                        return;
                      }
                    }
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
    );
  }
}
