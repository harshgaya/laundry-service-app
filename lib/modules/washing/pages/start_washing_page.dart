import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import 'package:laundry_service/modules/washing/pages/washing_dashboard.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';

import '../../../helpers/utils.dart';
import '../../authentication/pages/user_state.dart';

class StartWashingPage extends StatefulWidget {
  const StartWashingPage({super.key});

  @override
  State<StartWashingPage> createState() => _StartWashingPageState();
}

class _StartWashingPageState extends State<StartWashingPage> {
  final hoursController = TextEditingController();
  final minutesController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    super.dispose();
  }

  final washingController = Get.put(WashingController());

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
            child: const Center(
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
              'Start Washing',
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
                  'Assigned To Machine',
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
              height: 50,
            ),
            Form(
              key: formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: hoursController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: 'Hours',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          // Allow empty hours
                          return null;
                        } else if (int.tryParse(value) == null) {
                          return 'Enter valid hours';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: minutesController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: 'Minutes',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (hoursController.text.isEmpty &&
                            (value == null || value.isEmpty)) {
                          return 'Enter minutes';
                        } else if (value != null &&
                            int.tryParse(value) == null) {
                          return 'Enter valid minutes';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Expanded(
                  //   child: TextFormField(
                  //     controller: timerValueController,
                  //     keyboardType: TextInputType.number,
                  //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  //     decoration: const InputDecoration(
                  //         hintText: 'Enter timer',
                  //         border: OutlineInputBorder()),
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Please enter timer';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  // Expanded(
                  //   child: Obx(() {
                  //     return ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.blue),
                  //       onPressed: washingController.isTimerRunning.value
                  //           ? washingController.stopTimer
                  //           : () {
                  //               if (formKey.currentState!.validate()) {
                  //                 formKey.currentState!.save();
                  //
                  //                 washingController.washingTime.value =
                  //                     int.parse(timerValueController.text);
                  //
                  //                 washingController.startTimerWashing(
                  //                     context: context);
                  //                 timerValueController.clear();
                  //               }
                  //             },
                  //       child: Text(
                  //         washingController.isTimerRunning.value
                  //             ? 'Stop Timer'
                  //             : 'Start Timer',
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     );
                  //   }),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: washingController.isTimerRunning.value
                      ? washingController.stopTimer
                      : () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            int hours = hoursController.text.isEmpty
                                ? 0
                                : int.parse(hoursController.text);
                            int minutes = int.parse(minutesController.text);

                            if (hours == 0 && minutes == 0) {
                              Utils.showScaffoldMessageI(
                                  context: context,
                                  title: 'Please enter valid time');
                              return;
                            }

                            washingController.washingTime.value =
                                (hours * 60 * 60) + (minutes * 60);

                            washingController.startTimerWashing(
                                context: context);
                            hoursController.clear();
                            minutesController.clear();
                          }
                        },
                  child: Text(
                    washingController.isTimerRunning.value
                        ? 'Stop Timer'
                        : 'Start Timer',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                final minutes = washingController.washingTime.value ~/ 60;
                final seconds = washingController.washingTime.value % 60;
                return Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 48),
                );
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: RoundButtonAnimate(
                buttonName: 'To Drying',
                onClick: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Send to Drying?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  Get.offAll(() => const WashingDashboard());
                                  // Get.to(() => RemarksPage());
                                },
                                child: Text('Yes')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel')),
                          ],
                        );
                      });
                },
                image: Image.asset('assets/icons/drying.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
