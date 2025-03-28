import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/drying/controllers/drying_controller.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../authentication/pages/user_state.dart';

class StartDryingPage extends StatefulWidget {
  final String campusName;
  final String date;
  final String collectionNo;
  final String collectionId;
  final String status;
  final String campusId;
  const StartDryingPage(
      {super.key,
      required this.campusName,
      required this.date,
      required this.collectionNo,
      required this.collectionId,
      required this.status,
      required this.campusId});

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
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.campusName,
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
            Obx(() => dryingController.getDryingStatusTime(
                      collectionNo: int.parse(widget.collectionNo),
                    ) !=
                    null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
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
                            '${dryingController.getDryingStatusTime(
                              collectionNo: int.parse(widget.collectionNo),
                            )}',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox()),
            Obx(
              () => dryingController.getDryingStatusTime2(
                        collectionNo: int.parse(widget.collectionNo),
                      ) !=
                      null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
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
                              '${dryingController.getDryingStatusTime2(
                                collectionNo: int.parse(widget.collectionNo),
                              )}',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 50,
            ),
            Obx(() => dryingController.getCurrentStatus(
                      collectionNo: int.parse(widget.collectionNo),
                    ) ==
                    'WASHING_DONE'
                ? Align(
                    alignment: Alignment.center,
                    child: dryingController.updatingStatus.value
                        ? LoadingAnimationWidget.discreteCircle(
                            size: 40,
                            color: Colors.blue,
                            secondRingColor: const Color(0xFF1A1A3F),
                            thirdRingColor: const Color(0xFFEA3799))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () async {
                              await dryingController
                                  .updateStatus(
                                      collectionId: widget.collectionId,
                                      status: "DRYING",
                                      campusId: widget.campusId)
                                  .then((value) {
                                setState(() {
                                  print(
                                      'washing status ${dryingController.getCurrentStatus(collectionNo: int.parse(widget.collectionNo))}');
                                });
                              });
                            },
                            child: const Text(
                              'Start Timer',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  )
                : const SizedBox()),
            Obx(
              () => dryingController.getCurrentStatus(
                        collectionNo: int.parse(widget.collectionNo),
                      ) ==
                      'DRYING'
                  ? Align(
                      alignment: Alignment.center,
                      child: dryingController.updatingStatus.value
                          ? LoadingAnimationWidget.discreteCircle(
                              size: 40,
                              color: Colors.blue,
                              secondRingColor: const Color(0xFF1A1A3F),
                              thirdRingColor: const Color(0xFFEA3799))
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () async {
                                await dryingController
                                    .updateStatus(
                                        collectionId: widget.collectionId,
                                        status: 'DRYING_DONE',
                                        campusId: widget.campusId)
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                              child: const Text(
                                'Stop Timer',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                    )
                  : const SizedBox(),
            ),
            Obx(
              () => dryingController.getCurrentStatus(
                        collectionNo: int.parse(widget.collectionNo),
                      ) ==
                      'DRYING'
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () {
                                Get.offAll(const UserState());
                              },
                              child: const Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
            const Spacer(),
            Obx(() => dryingController.getCurrentStatus(
                      collectionNo: int.parse(widget.collectionNo),
                    ) ==
                    'DRYING_DONE'
                ? Align(
                    alignment: Alignment.center,
                    child: RoundButtonAnimate(
                        buttonName: 'Segregation',
                        onClick: () {
                          Utils.showDialogPopUp(
                              context: context,
                              function: () {
                                Get.offAll(UserState());
                              },
                              title: 'Done?');
                        },
                        image: Image.asset('assets/icons/drying.png')))
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
