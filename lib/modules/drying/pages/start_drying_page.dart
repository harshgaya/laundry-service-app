import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/drying/controllers/drying_controller.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../../authentication/pages/user_state.dart';
import 'drying_extend_time.dart';

class StartDryingPage extends StatefulWidget {
  const StartDryingPage({super.key});

  @override
  State<StartDryingPage> createState() => _StartDryingPageState();
}

class _StartDryingPageState extends State<StartDryingPage> {
  final timerValueController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final dryingController = Get.put(DryingController());

  final hoursController = TextEditingController();
  final minutesController = TextEditingController();
  bool timerStarted = false;
  bool? timerStopped;
  String? startTime;
  String? stopTime;
  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    super.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Start Drying',
              style: GoogleFonts.roboto(
                fontSize: 20,
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
            if (startTime != null)
              const SizedBox(
                height: 20,
              ),
            if (startTime != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Timer started at',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '$startTime',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            if (stopTime != null)
              const SizedBox(
                height: 20,
              ),
            if (stopTime != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Timer stopped at',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '$stopTime',
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
            if (!timerStarted)
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      setState(() {
                        timerStarted = true;
                        timerStopped = false;
                        startTime = DateFormat('dd-MM-yyyy HH:mm')
                            .format(DateTime.now());
                      });
                    },
                    child: Text(
                      'Start Timer',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
            if (timerStopped == false)
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      setState(() {
                        timerStopped = true;
                        stopTime = DateFormat('dd-MM-yyyy HH:mm')
                            .format(DateTime.now());
                      });
                    },
                    child: Text(
                      'Stop Timer',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
            const SizedBox(
              height: 20,
            ),
            if (timerStopped == false)
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Get.offAll(UserState());
                    },
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ),
            Spacer(),
            if (timerStopped == true)
              Align(
                  alignment: Alignment.center,
                  child: RoundButtonAnimate(
                      buttonName: 'Drying',
                      onClick: () {
                        Utils.showDialogPopUp(
                            context: context,
                            function: () {
                              Get.to(() => const DryingExtendTimePage());
                            },
                            title: 'Done?');
                      },
                      image: Image.asset('assets/icons/drying.png'))),
          ],
        ),
      ),
    );
  }
}
