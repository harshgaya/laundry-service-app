// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class DryAreaAll extends StatefulWidget {
//   const DryAreaAll({super.key});
//
//   @override
//   State<DryAreaAll> createState() => _DryAreaAllState();
// }
//
// class _DryAreaAllState extends State<DryAreaAll> {
//   final int clothesPerCell = 10;
//   int rows = 9;
//   int column = 5;
//   List<String> dryArea = ['Dry Area 1', 'Dry Area 2', 'Dry Area 3'];
//   String selectedDryArea = 'Dry Area 1';
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Dry Area',
//             style: GoogleFonts.roboto(
//               fontSize: 20,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           DropdownButtonFormField<String>(
//             onChanged: (String? newValue) {
//               setState(() {
//                 selectedDryArea = newValue!;
//                 int index = dryArea.indexOf(newValue);
//
//                 if (index == 0) {
//                   rows = 9;
//                 } else if (index == 1) {
//                   rows = 9;
//                 } else if (index == 2) {
//                   rows = 12;
//                 } else if (index == 3) {
//                   rows = 5;
//                 } else {
//                   rows = 5;
//                 }
//               });
//             },
//             decoration: InputDecoration(
//               hintText: 'Dry Area',
//               hintStyle: const TextStyle(color: Colors.white),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               filled: true,
//               fillColor: Colors.blue,
//             ),
//             validator: (val) {
//               if (val == null || val.isEmpty) {
//                 return 'Please select dry area';
//               }
//               return null;
//             },
//             value: selectedDryArea,
//             dropdownColor: Colors.blue,
//             items: dryArea.map<DropdownMenuItem<String>>((String dryArea) {
//               return DropdownMenuItem<String>(
//                 value: dryArea,
//                 child: Text(
//                   dryArea,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Total Cloths',
//                 style: GoogleFonts.roboto(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 20,
//                 ),
//               ),
//               Text(
//                 '22',
//                 style: GoogleFonts.roboto(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 20,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 9,
//                 crossAxisSpacing: 2.0,
//                 mainAxisSpacing: 2.0,
//               ),
//               itemCount: rows * column,
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   // 1st cell - 100% filled with black
//                   return Container(
//                     color: Colors.black,
//                   );
//                 } else if (index == 1) {
//                   // 2nd cell - 10% filled with black
//                   return FractionallySizedBox(
//                     widthFactor: 1.0,
//                     heightFactor: 0.1,
//                     alignment: Alignment.topCenter,
//                     child: Container(
//                       color: Colors.black,
//                     ),
//                   );
//                 } else if (index == 2) {
//                   // 3rd cell - 100% filled with red
//                   return Container(
//                     color: Colors.red,
//                   );
//                 } else if (index == 3) {
//                   // 4th cell - 20% filled with red
//                   return FractionallySizedBox(
//                     widthFactor: 1.0,
//                     heightFactor: 0.2,
//                     alignment: Alignment.topCenter,
//                     child: Container(
//                       color: Colors.red,
//                     ),
//                   );
//                 } else {
//                   // Remaining cells will be grey
//                   return Container(
//                     color: Colors.grey,
//                   );
//                 }
//               },
//             ),
//           ),
//           Row(
//             children: [
//               Container(
//                 height: 20,
//                 width: 20,
//                 color: Colors.black,
//               ),
//               const SizedBox(width: 10),
//               Text('Shri Chaityna'),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Container(
//                 height: 20,
//                 width: 20,
//                 color: Colors.red,
//               ),
//               const SizedBox(width: 10),
//               Text('DPS'),
//             ],
//           ),
//           const SizedBox(height: 150),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/drying_controller.dart';
import '../models/dry_area_model.dart';

class DryAreaAll extends StatefulWidget {
  const DryAreaAll({super.key});

  @override
  State<DryAreaAll> createState() => _DryAreaAllState();
}

class _DryAreaAllState extends State<DryAreaAll> {
  final dryingController = Get.put(DryingController());
  int totalUnits = 0;
  int unitsPerCell = 10;
  late List<int> filledUnits;
  late Map<int, double> initialFillMap; // Store initially filled units
  String? selectedDryArea;
  int rows = 0;
  int column = 0;
  Map? filledMapFinal;
  String? dryAreaId;
  String? color;
  String? campusName;
  DryArea? selectedDry;

  @override
  void initState() {
    super.initState();
    initialFillMap = {}; // Initialize the map
    dryingController.getDryAreaList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => dryingController.gettingDryArea.value
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 40,
                  color: Colors.blue,
                  secondRingColor: const Color(0xFF1A1A3F),
                  thirdRingColor: const Color(0xFFEA3799)),
            )
          : Padding(
              padding: EdgeInsets.only(
                  left: 8, right: 8, top: MediaQuery.of(context).padding.top),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Dry Area',
                    style: GoogleFonts.roboto(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != null) {
                          // showFillDialog();
                          try {
                            selectedDryArea = newValue;
                            final dryArea = dryingController.dryAreaList
                                .firstWhere((element) =>
                                    element.id == int.parse(selectedDryArea!));
                            selectedDry = dryArea;
                            dryAreaId = dryArea.uid;
                            color = dryArea.fillArea?.campus?.color;
                            campusName = dryArea.fillArea?.campus?.name;

                            rows = dryArea.row;
                            column = dryArea.column;
                            filledUnits = List<int>.filled(rows * column, 0);
                            initialFillMap.clear();

                            if (dryArea.fillArea != null) {
                              dryArea.fillArea!.filled?.forEach((key, value) {
                                int index = int.parse(key.substring(2)) - 1;
                                if (index >= 0 && index < filledUnits.length) {
                                  filledUnits[index] =
                                      (value * unitsPerCell).toInt();
                                  initialFillMap[index] =
                                      value; // Set initial fill
                                }
                              });
                            }
                          } catch (e) {
                            print('error $e');
                          }
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Select Dry Area',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: Colors.blue,
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please select dry area';
                      }
                      return null;
                    },
                    value: selectedDryArea,
                    dropdownColor: Colors.blue,
                    items: dryingController.dryAreaList
                        .map<DropdownMenuItem<String>>((DryArea dryArea) {
                      return DropdownMenuItem<String>(
                        value: dryArea.id.toString(),
                        child: Text(
                          'Dry Area ${dryArea.id}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (selectedDryArea != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 200,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.blue, width: 2.0),
                                left:
                                    BorderSide(color: Colors.blue, width: 2.0),
                                bottom:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: column,
                                crossAxisSpacing: 2.0,
                                mainAxisSpacing: 2.0,
                              ),
                              itemCount: rows * column,
                              itemBuilder: (context, index) {
                                double fillFraction =
                                    filledUnits[index] / unitsPerCell;

                                return GestureDetector(
                                  // onTap: () => _handleTap(index),
                                  child: Container(
                                    color: Colors.grey,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: FractionallySizedBox(
                                        widthFactor: 1.0,
                                        heightFactor: fillFraction,
                                        child: Container(
                                          color: Color(
                                              Utils.getColorWithoutHash(
                                                  color: color ?? '#2196F3FF')),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: const Text(
                            'Front\nFacing',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  const Spacer(),
                  if (selectedDryArea != null &&
                      selectedDry!.fillArea!.filled!.isNotEmpty)
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Color(Utils.getColorWithoutHash(
                                color: color ?? '#2196F3FF')),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(campusName ?? ''),
                      ],
                    ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            )),
    );
  }
}
