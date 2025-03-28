import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/modules/washing/controllers/washing_controller.dart';
import 'package:laundry_service/modules/washing/pages/washing_dashboard.dart';
import 'package:laundry_service/modules/widegets/round_button_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../helpers/utils.dart';
import '../../../authentication/pages/user_state.dart';

class StartWashingPage extends StatefulWidget {
  final String campusName;
  final String date;
  final String collectionNo;
  final String collectionId;
  final String status;
  final String updatedTime;
  const StartWashingPage(
      {super.key,
      required this.campusName,
      required this.date,
      required this.collectionNo,
      required this.collectionId,
      required this.status,
      required this.updatedTime});

  @override
  State<StartWashingPage> createState() => _StartWashingPageState();
}

class _StartWashingPageState extends State<StartWashingPage> {
  final hoursController = TextEditingController();
  final minutesController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String status = '';

  @override
  void dispose() {
    hoursController.dispose();
    minutesController.dispose();
    super.dispose();
  }

  final washingController = Get.put(WashingController());
  bool timerStarted = false;
  bool? timerStopped;
  String? startTime;
  String? stopTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.status == 'WASHING') {
      startTime = widget.updatedTime;
    }
    status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    print(
        'helo time ${washingController.getWashingStatusTime(collectionNo: int.parse(widget.collectionNo))}');
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
            Obx(() => washingController.getWashingStatusTime(
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
                            '${washingController.getWashingStatusTime(
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
              () => washingController.getWashingStatusTime2(
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
                              '${washingController.getWashingStatusTime2(
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
            Obx(() => washingController.getCurrentStatus(
                      collectionNo: int.parse(widget.collectionNo),
                    ) ==
                    'DELIVERED_TO_WAREHOUSE'
                ? Align(
                    alignment: Alignment.center,
                    child: washingController.updatingStatus.value
                        ? LoadingAnimationWidget.discreteCircle(
                            size: 40,
                            color: Colors.blue,
                            secondRingColor: const Color(0xFF1A1A3F),
                            thirdRingColor: const Color(0xFFEA3799))
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () async {
                              await washingController
                                  .updateStatus(
                                      collectionId: widget.collectionId,
                                      status: "WASHING")
                                  .then((value) {
                                setState(() {
                                  print(
                                      'washing status ${washingController.getCurrentStatus(collectionNo: int.parse(widget.collectionNo))}');
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
              () => washingController.getCurrentStatus(
                        collectionNo: int.parse(widget.collectionNo),
                      ) ==
                      'WASHING'
                  ? Align(
                      alignment: Alignment.center,
                      child: washingController.updatingStatus.value
                          ? LoadingAnimationWidget.discreteCircle(
                              size: 40,
                              color: Colors.blue,
                              secondRingColor: const Color(0xFF1A1A3F),
                              thirdRingColor: const Color(0xFFEA3799))
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                              onPressed: () async {
                                await washingController
                                    .updateStatus(
                                        collectionId: widget.collectionId,
                                        status: 'WASHING_DONE')
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
              () => washingController.getCurrentStatus(
                        collectionNo: int.parse(widget.collectionNo),
                      ) ==
                      'WASHING'
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
            Obx(() => washingController.getCurrentStatus(
                      collectionNo: int.parse(widget.collectionNo),
                    ) ==
                    'WASHING_DONE'
                ? Align(
                    alignment: Alignment.center,
                    child: RoundButtonAnimate(
                        buttonName: 'Drying',
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
