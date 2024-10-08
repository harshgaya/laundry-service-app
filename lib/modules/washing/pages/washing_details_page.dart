import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/washing/pages/day_sheet_data.dart';
import 'package:laundry_service/modules/washing/pages/start_washing_page.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

class WashingDetailsPage extends StatefulWidget {
  const WashingDetailsPage({super.key});

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
                    Get.to(() => DaySheetData());
                  },
                  child: Text(
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
                  'Total Tag Count',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '120',
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
                  '16',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Assigned To Machine',
            //       style: GoogleFonts.roboto(
            //         fontWeight: FontWeight.w700,
            //         fontSize: 20,
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       child: DropdownButtonFormField<String>(
            //         decoration: InputDecoration(
            //           hintText: 'Select',
            //           hintStyle: TextStyle(color: Colors.white),
            //           border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(12.0),
            //           ),
            //           filled: true,
            //           fillColor: Colors.blue,
            //         ),
            //         value: selectedMachine,
            //         onChanged: (String? newValue) {
            //           setState(() {
            //             selectedMachine = newValue;
            //           });
            //         },
            //         dropdownColor: Colors.blue,
            //         items: machines
            //             .map<DropdownMenuItem<String>>((String teacher) {
            //           return DropdownMenuItem<String>(
            //             value: teacher,
            //             child: Text(
            //               teacher,
            //               style: TextStyle(color: Colors.white),
            //             ),
            //           );
            //         }).toList(),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 100,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: RoundButtonAnimate(
                buttonName: 'Start Washing',
                onClick: () {
                  Get.to(() => const StartWashingPage());
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
