import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/modules/drying/pages/start_drying_page.dart';

import '../../widegets/round_button_animate.dart';

class SelectDryArea extends StatefulWidget {
  const SelectDryArea({super.key});

  @override
  State<SelectDryArea> createState() => _SelectDryAreaState();
}

class _SelectDryAreaState extends State<SelectDryArea> {
  int totalUnits = 90; // Total units to be distributed among cells
  int unitsPerCell = 40; // Maximum units each cell can hold
  late List<int> filledUnits; // Track how many units each cell has filled

  @override
  void initState() {
    super.initState();
    filledUnits = List<int>.filled(81, 0); // Initially all cells are empty
  }

  void _handleTap(int index) {
    setState(() {
      if (totalUnits > 0 && filledUnits[index] < unitsPerCell) {
        int unitsToAdd = unitsPerCell - filledUnits[index];
        if (totalUnits >= unitsToAdd) {
          filledUnits[index] += unitsToAdd;
          totalUnits -= unitsToAdd;
        } else {
          filledUnits[index] += totalUnits;
          totalUnits = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                'Select Dry Area',
                style: GoogleFonts.roboto(
                  fontSize: 40,
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
                    'Total Cloths',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '90',
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
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                  ),
                  itemCount: 81, // 9 * 9 = 81 cells
                  itemBuilder: (context, index) {
                    double fillFraction = filledUnits[index] / unitsPerCell;

                    return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Container(
                        color: Colors.grey,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FractionallySizedBox(
                            widthFactor: 1.0,
                            heightFactor: fillFraction,
                            child: Container(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Shri Chaityna'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: RoundButtonAnimate(
                  buttonName: 'Start Drying',
                  onClick: () {
                    Get.to(() => const StartDryingPage());
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
      ),
    );
  }
}
