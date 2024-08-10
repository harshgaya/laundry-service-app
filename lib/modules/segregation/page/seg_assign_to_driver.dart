import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/widgets/drop_down_widget.dart';
import '../../campus_employee/widgets/round_button_custom.dart';

class SegAssignToDriver extends StatefulWidget {
  const SegAssignToDriver({super.key});

  @override
  State<SegAssignToDriver> createState() => _SegAssignToDriverState();
}

class _SegAssignToDriverState extends State<SegAssignToDriver> {
  List<String> drivers = [
    'Uppal Route Driver',
    'Madahapur Route Driver',
    'Adibatla Route Driver'
  ];
  String? selectedDriver;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
            height: 50,
          ),
          Row(
            children: [
              const Text('Select Driver'),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: DropDownWidget(
                    hintText: 'Assign Driver',
                    selectedText: selectedDriver,
                    listOfString: drivers,
                    onChanged: (val) {
                      setState(() {
                        selectedDriver = val;
                      });
                    }),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          RoundButtonCustom(
            title: 'Assign to Driver',
            image: 'assets/icons/tick.png',
            function: () {
              if (selectedDriver != null) {
                Get.offAll(() => UserState());
              }
            },
          )
        ],
      ),
    );
  }
}
