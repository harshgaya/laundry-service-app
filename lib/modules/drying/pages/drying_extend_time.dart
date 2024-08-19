import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';

import '../../driver/widgets/select_tile_widget.dart';

class DryingExtendTimePage extends StatefulWidget {
  const DryingExtendTimePage({super.key});

  @override
  State<DryingExtendTimePage> createState() => _DryingExtendTimePageState();
}

class _DryingExtendTimePageState extends State<DryingExtendTimePage> {
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
              'Select',
              style: GoogleFonts.roboto(
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SelectTileWidget(
              title: 'Send To Dryer',
              image: 'assets/icons/dryer.png',
              color: Colors.blue,
              function: () {
                Utils.showDialogPopUp(
                    context: context,
                    function: () {
                      Get.offAll(() => const UserState());
                    },
                    title: "Send to Segregation");
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SelectTileWidget(
              title: 'Send To Segregation',
              image: 'assets/icons/segregation.png',
              color: Colors.blue,
              function: () {
                Utils.showDialogPopUp(
                    context: context,
                    function: () {
                      Get.offAll(() => const UserState());
                    },
                    title: "Send to Segregation");
              },
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // SelectTileWidget(
            //   title: 'Extend Time',
            //   image: 'assets/icons/timer.png',
            //   color: Colors.blue,
            //   function: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
