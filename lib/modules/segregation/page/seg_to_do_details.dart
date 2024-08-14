import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/campus_employee/widgets/round_button_custom.dart';
import 'package:laundry_service/modules/segregation/page/seg_enter_tagno.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../../campus_employee/widgets/drop_down_widget.dart';

class SegToDoDetails extends StatefulWidget {
  const SegToDoDetails({super.key});

  @override
  State<SegToDoDetails> createState() => _SegToDoDetailsState();
}

class _SegToDoDetailsState extends State<SegToDoDetails> {
  String? selectedTable;
  List<String> tables = ['Table 1', 'Table 2', 'Table 3'];
  String? selectedRange;
  List<String> ranges = [
    '100-200',
    '200-300',
    '300-400',
    '400-500',
    '500-600',
    '600-700',
    '700-800',
    '800-900',
    '900-1000'
  ];
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TO DO\nTask',
              style: GoogleFonts.roboto(
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
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
                Text(
                  'Sri Chaitnaya',
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
                  'Date',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
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
                  '1',
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
                  'Assigned To Zone',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '5',
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
            DropDownWidget(
              hintText: 'Assign To Table',
              selectedText: selectedTable,
              listOfString: tables,
              onChanged: (newValue) {
                setState(() {
                  selectedTable = newValue;
                  // You can reset or modify other variables here if needed
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropDownWidget(
              hintText: 'Select Range',
              selectedText: selectedRange,
              listOfString: ranges,
              onChanged: (newValue) {
                setState(() {
                  selectedRange = newValue;
                  // You can reset or modify other variables here if needed
                });
              },
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: RoundButtonAnimate(
                  buttonName: 'Done',
                  onClick: () {
                    if (selectedTable == null) {
                      Utils.showScaffoldMessageI(
                          context: context, title: 'Please select table');
                    } else {
                      Get.to(() => const SegEnterTagNo());
                    }
                  },
                  image: Icon(
                    Icons.done,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
