// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:laundry_service/modules/drying/controllers/drying_controller.dart';
// import 'package:laundry_service/modules/drying/models/dry_area_model.dart';
// import 'package:laundry_service/modules/drying/pages/drying_crud/start_drying_page.dart';
//
// import '../../../widegets/round_button_animate.dart';
//
// class SelectDryArea extends StatefulWidget {
//   final String campusName;
//   final String date;
//   final String collectionNo;
//   final String collectionId;
//   final String status;
//   const SelectDryArea(
//       {super.key,
//       required this.campusName,
//       required this.date,
//       required this.collectionNo,
//       required this.collectionId,
//       required this.status});
//
//   @override
//   State<SelectDryArea> createState() => _SelectDryAreaState();
// }
//
// class _SelectDryAreaState extends State<SelectDryArea> {
//   final dryingController = Get.put(DryingController());
//   int totalUnits = 0;
//   int unitsPerCell = 10;
//   late List<int> filledUnits;
//   String? selectedDryArea;
//   int rows = 0;
//   int column = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     filledUnits = List<int>.filled(rows * column, 0);
//     dryingController.getDryAreaList();
//   }
//
//   Future<void> showFillDialog() async {
//     TextEditingController controller = TextEditingController();
//
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'How many cloths?',
//             style: TextStyle(fontSize: 12),
//           ),
//           content: TextField(
//             keyboardType: TextInputType.number,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             controller: controller,
//             decoration: const InputDecoration(
//               hintText: 'Enter total cloths',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Submit'),
//               onPressed: () {
//                 totalUnits = int.parse(controller.text);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _handleTap(int index) {
//     setState(() {
//       if (totalUnits > 0 && filledUnits[index] < unitsPerCell) {
//         int unitsToAdd = unitsPerCell - filledUnits[index];
//         if (totalUnits >= unitsToAdd) {
//           filledUnits[index] += unitsToAdd;
//           totalUnits -= unitsToAdd;
//         } else {
//           filledUnits[index] += totalUnits;
//           totalUnits = 0;
//         }
//       }
//       Map<String, double> fillMap = {};
//       for (int i = 0; i < filledUnits.length; i++) {
//         if (filledUnits[i] > 0) {
//           fillMap['id$i'] = filledUnits[i] / unitsPerCell;
//         }
//       }
//
//       // Convert the map to the formatted string
//       String formattedString = jsonEncode(fillMap);
//       print('Updated Filled Units: $formattedString');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: const CircleAvatar(
//               backgroundColor: Colors.blue,
//               child: Center(
//                 child: Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.white,
//                   size: 16,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         body: Obx(() => dryingController.gettingDryArea.value
//             ? const Center(
//                 child: LoadingAnimationWidget.discreteCircle(
//                             size: 40,
//                             color: Colors.blue,
//                             secondRingColor: const Color(0xFF1A1A3F),
//                             thirdRingColor: const Color(0xFFEA3799)
//                           ),
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Select Dry Area',
//                       style: GoogleFonts.roboto(
//                         fontSize: 40,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DropdownButtonFormField<String>(
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           if (newValue != null) {
//                             showFillDialog();
//                             try {
//                               selectedDryArea = newValue;
//                               final dryArea = dryingController.dryAreaList
//                                   .firstWhere((element) =>
//                                       element.id ==
//                                       int.parse(selectedDryArea!));
//
//                               rows = dryArea.row;
//                               column = dryArea.column;
//                               filledUnits = List<int>.filled(rows * column, 0);
//                               dryArea.fillArea.filled.forEach((key, value) {
//                                 int index = int.parse(key.substring(2)) - 1;
//                                 if (index >= 0 && index < filledUnits.length) {
//                                   filledUnits[index] = (value * 10).toInt();
//                                 }
//                               });
//                             } catch (e) {
//                               print('error $e');
//                             }
//                           }
//                         });
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'Select Dry Area',
//                         hintStyle: const TextStyle(color: Colors.white),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         filled: true,
//                         fillColor: Colors.blue,
//                       ),
//                       validator: (val) {
//                         if (val == null || val.isEmpty) {
//                           return 'Please select dry area';
//                         }
//                         return null;
//                       },
//                       value: selectedDryArea,
//                       dropdownColor: Colors.blue,
//                       items: dryingController.dryAreaList
//                           .map<DropdownMenuItem<String>>((DryArea dryArea) {
//                         return DropdownMenuItem<String>(
//                           value: dryArea.id.toString(),
//                           child: Text(
//                             'Dry Area ${dryArea.id}',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     if (selectedDryArea != null)
//                       Expanded(
//                         child: GridView.builder(
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: rows,
//                             crossAxisSpacing: 2.0,
//                             mainAxisSpacing: 2.0,
//                           ),
//                           itemCount: rows * column,
//                           itemBuilder: (context, index) {
//                             double fillFraction =
//                                 filledUnits[index] / unitsPerCell;
//
//                             return GestureDetector(
//                               onTap: () => _handleTap(index),
//                               child: Container(
//                                 color: Colors.grey,
//                                 child: Align(
//                                   alignment: Alignment.topRight,
//                                   child: FractionallySizedBox(
//                                     widthFactor: 1.0,
//                                     heightFactor: fillFraction,
//                                     child: Container(
//                                       color: Colors.blue,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     if (selectedDryArea != null)
//                       Row(
//                         children: [
//                           Container(
//                             height: 20,
//                             width: 20,
//                             decoration: const BoxDecoration(
//                               color: Colors.blue,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(widget.campusName),
//                         ],
//                       ),
//                     const SizedBox(
//                       height: 100,
//                     ),
//                   ],
//                 ),
//               )),
//         bottomSheet: selectedDryArea == null
//             ? const SizedBox()
//             : RoundButtonAnimate(
//                 buttonName: 'Start Drying',
//                 onClick: () {
//                   Get.to(() => StartDryingPage(
//                         campusName: widget.campusName,
//                         date: widget.date,
//                         collectionNo: widget.collectionNo,
//                         collectionId: widget.collectionId,
//                         status: widget.status,
//                       ));
//                 },
//                 image: Image.asset(
//                   'assets/icons/washing.png',
//                   height: 30,
//                   color: Colors.white,
//                 ),
//               ),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/drying/controllers/drying_controller.dart';
import 'package:laundry_service/modules/drying/models/dry_area_model.dart';
import 'package:laundry_service/modules/drying/pages/drying_crud/start_drying_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widegets/round_button_animate.dart';

// class SelectDryArea extends StatefulWidget {
//   final String campusName;
//   final String date;
//   final String collectionNo;
//   final String collectionId;
//   final String status;
//   final bool isButton;
//   const SelectDryArea(
//       {super.key,
//       required this.campusName,
//       required this.date,
//       required this.collectionNo,
//       required this.collectionId,
//       required this.status,
//       required this.isButton});
//
//   @override
//   State<SelectDryArea> createState() => _SelectDryAreaState();
// }
//
// class _SelectDryAreaState extends State<SelectDryArea> {
//   final dryingController = Get.put(DryingController());
//   int totalUnits = 0;
//   int unitsPerCell = 1;
//   late List<int> filledUnits;
//   late Map<int, double> initialFillMap;
//   String? selectedDryArea;
//   int rows = 0;
//   int column = 0;
//   Map? filledMapFinal;
//   String? dryAreaId;
//
//   @override
//   void initState() {
//     super.initState();
//     initialFillMap = {}; // Initialize the map
//     dryingController.getDryAreaList();
//   }
//
//   Future<void> showFillDialog() async {
//     TextEditingController controller = TextEditingController();
//
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'How many sections do you want to fill?',
//             style: TextStyle(fontSize: 12),
//           ),
//           content: TextField(
//             // keyboardType: TextInputType.number,
//             keyboardType: const TextInputType.numberWithOptions(decimal: true),
//             // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             inputFormatters: [
//               FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
//             ],
//             controller: controller,
//             decoration: const InputDecoration(
//               hintText: 'Enter total sections',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Submit'),
//               onPressed: () {
//                 totalUnits = int.parse(controller.text);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _handleTap(int index) {
//     setState(() {
//       if (totalUnits > 0 && filledUnits[index] < unitsPerCell) {
//         int unitsToAdd = unitsPerCell - filledUnits[index];
//         if (totalUnits >= unitsToAdd) {
//           filledUnits[index] += unitsToAdd;
//           totalUnits -= unitsToAdd;
//         } else {
//           filledUnits[index] += totalUnits;
//           totalUnits = 0;
//         }
//       }
//
//       // Generate the new map with only newly added units
//       Map<String, double> fillMap = {};
//       for (int i = 0; i < filledUnits.length; i++) {
//         double initialFill = initialFillMap[i] ?? 0.0;
//         double currentFill = filledUnits[i] / unitsPerCell;
//         if (currentFill > initialFill) {
//           fillMap['id$i'] = currentFill - initialFill;
//         }
//       }
//       filledMapFinal = fillMap;
//       String formattedString = jsonEncode(fillMap);
//       print('Updated Filled Units: $formattedString');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const CircleAvatar(
//             backgroundColor: Colors.blue,
//             child: Center(
//               child: Icon(
//                 Icons.arrow_back_ios_new,
//                 color: Colors.white,
//                 size: 16,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() => dryingController.gettingDryArea.value
//           ? const Center(
//               child: LoadingAnimationWidget.discreteCircle(
//                             size: 40,
//                             color: Colors.blue,
//                             secondRingColor: const Color(0xFF1A1A3F),
//                             thirdRingColor: const Color(0xFFEA3799)
//                           ),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Select Dry Area',
//                     style: GoogleFonts.roboto(
//                       fontSize: 40,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   DropdownButtonFormField<String>(
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         if (newValue != null) {
//                           showFillDialog();
//                           try {
//                             selectedDryArea = newValue;
//                             final dryArea = dryingController.dryAreaList
//                                 .firstWhere((element) =>
//                                     element.id == int.parse(selectedDryArea!));
//                             dryAreaId = dryArea.uid;
//
//                             rows = dryArea.row;
//                             column = dryArea.column;
//                             filledUnits = List<int>.filled(rows * column, 0);
//                             initialFillMap.clear(); // Clear initial map
//
//                             // Initialize filled units from API response
//                             dryArea.fillArea.filled.forEach((key, value) {
//                               int index = int.parse(key.substring(2)) - 1;
//                               if (index >= 0 && index < filledUnits.length) {
//                                 filledUnits[index] =
//                                     (value * unitsPerCell).toInt();
//                                 initialFillMap[index] =
//                                     value; // Set initial fill
//                               }
//                             });
//                           } catch (e) {
//                             print('error $e');
//                           }
//                         }
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Select Dry Area',
//                       hintStyle: const TextStyle(color: Colors.white),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       filled: true,
//                       fillColor: Colors.blue,
//                     ),
//                     validator: (val) {
//                       if (val == null || val.isEmpty) {
//                         return 'Please select dry area';
//                       }
//                       return null;
//                     },
//                     value: selectedDryArea,
//                     dropdownColor: Colors.blue,
//                     items: dryingController.dryAreaList
//                         .map<DropdownMenuItem<String>>((DryArea dryArea) {
//                       return DropdownMenuItem<String>(
//                         value: dryArea.id.toString(),
//                         child: Text(
//                           'Dry Area ${dryArea.id}',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   if (selectedDryArea != null)
//                     Expanded(
//                       child: GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: rows,
//                           crossAxisSpacing: 2.0,
//                           mainAxisSpacing: 2.0,
//                         ),
//                         itemCount: rows * column,
//                         itemBuilder: (context, index) {
//                           double fillFraction =
//                               filledUnits[index] / unitsPerCell;
//
//                           return GestureDetector(
//                             onTap: () => _handleTap(index),
//                             child: Container(
//                               color: Colors.grey,
//                               child: Align(
//                                 alignment: Alignment.topRight,
//                                 child: FractionallySizedBox(
//                                   widthFactor: 1.0,
//                                   heightFactor: fillFraction,
//                                   child: Container(
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   if (selectedDryArea != null)
//                     Row(
//                       children: [
//                         Container(
//                           height: 20,
//                           width: 20,
//                           decoration: const BoxDecoration(
//                             color: Colors.blue,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(widget.campusName),
//                       ],
//                     ),
//                   const SizedBox(
//                     height: 100,
//                   ),
//                 ],
//               ),
//             )),
//       bottomSheet: !widget.isButton
//           ? const SizedBox()
//           : selectedDryArea == null
//               ? const SizedBox()
//               : Obx(() => dryingController.updateDryArea.value
//                   ? const LoadingAnimationWidget.discreteCircle(
//                             size: 40,
//                             color: Colors.blue,
//                             secondRingColor: const Color(0xFF1A1A3F),
//                             thirdRingColor: const Color(0xFFEA3799)
//                           )
//                   : RoundButtonAnimate(
//                       buttonName: 'Start Drying',
//                       onClick: () {
//                         if (filledMapFinal != null) {
//                           dryingController
//                               .updateFilledArea(
//                                   dryAreaId: dryAreaId!,
//                                   mapData: filledMapFinal)
//                               .then((value) {
//                             Get.to(() => StartDryingPage(
//                                   campusName: widget.campusName,
//                                   date: widget.date,
//                                   collectionNo: widget.collectionNo,
//                                   collectionId: widget.collectionId,
//                                   status: widget.status,
//                                 ));
//                           });
//                         } else {
//                           Utils.showScaffoldMessageI(
//                               context: context,
//                               title: 'Please fill all dry area');
//                         }
//                       },
//                       image: Image.asset(
//                         'assets/icons/washing.png',
//                         height: 30,
//                         color: Colors.white,
//                       ),
//                     )),
//     );
//   }
// }
class SelectDryArea extends StatefulWidget {
  final String campusName;
  final String campusColor;
  final String campusId;
  final String date;
  final String collectionNo;
  final String collectionId;
  final String status;
  final bool isButton;
  const SelectDryArea(
      {super.key,
      required this.campusName,
      required this.date,
      required this.collectionNo,
      required this.collectionId,
      required this.status,
      required this.isButton,
      required this.campusId,
      required this.campusColor});

  @override
  State<SelectDryArea> createState() => _SelectDryAreaState();
}

class _SelectDryAreaState extends State<SelectDryArea> {
  final dryingController = Get.put(DryingController());
  double totalUnits = 0.0; // Changed to double
  int unitsPerCell = 1;
  late List<double> filledUnits; // Changed to List<double>
  late Map<int, double> initialFillMap;
  String? selectedDryArea;
  int rows = 0;
  int column = 0;
  Map<String, double>? filledMapFinal;
  String? dryAreaId;
  String? color;
  String? campusName;

  @override
  void initState() {
    super.initState();
    initialFillMap = {};
    dryingController.getDryAreaList();
  }

  Future<void> showFillDialog() async {
    TextEditingController controller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'How many sections do you want to fill?',
            style: TextStyle(fontSize: 12),
          ),
          content: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter total sections',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                setState(() {
                  totalUnits = double.parse(controller.text); // Updated
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleTap(int index) {
    setState(() {
      if (totalUnits > 0 && filledUnits[index] < unitsPerCell) {
        double unitsToAdd = unitsPerCell - filledUnits[index];
        if (totalUnits >= unitsToAdd) {
          filledUnits[index] += unitsToAdd;
          totalUnits -= unitsToAdd;
        } else {
          filledUnits[index] += totalUnits;
          totalUnits = 0;
        }
      }

      // Generate the new map with only newly added units
      Map<String, double> fillMap = {};
      for (int i = 0; i < filledUnits.length; i++) {
        double initialFill = initialFillMap[i] ?? 0.0;
        double currentFill = filledUnits[i] / unitsPerCell;
        if (currentFill > initialFill) {
          fillMap['id$i'] = currentFill - initialFill;
        }
      }
      filledMapFinal = fillMap;
      String formattedString = jsonEncode(fillMap);
      print('Updated Filled Units: $formattedString');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('campus id ${widget.campusId}');
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
      body: Obx(() => dryingController.gettingDryArea.value
          ? Center(
              child: LoadingAnimationWidget.discreteCircle(
                  size: 40,
                  color: Colors.blue,
                  secondRingColor: const Color(0xFF1A1A3F),
                  thirdRingColor: const Color(0xFFEA3799)),
            )
          : Padding(
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
                  DropdownButtonFormField<String>(
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != null) {
                          showFillDialog();
                          try {
                            selectedDryArea = newValue;
                            final dryArea = dryingController.dryAreaList
                                .firstWhere((element) =>
                                    element.id == int.parse(selectedDryArea!));
                            dryAreaId = dryArea.uid;
                            color = dryArea.fillArea?.campus?.color;
                            campusName = dryArea.fillArea?.campus?.name;

                            rows = dryArea.row;
                            column = dryArea.column;
                            filledUnits =
                                List<double>.filled(rows * column, 0.0);
                            initialFillMap.clear();

                            if (dryArea.fillArea != null) {
                              dryArea.fillArea!.filled?.forEach((key, value) {
                                int index = int.parse(key.substring(2)) - 1;
                                if (index >= 0 && index < filledUnits.length) {
                                  filledUnits[index] =
                                      (value?.toDouble() ?? 0.0) *
                                          unitsPerCell; // Convert to double
                                  initialFillMap[index] = value?.toDouble() ??
                                      0.0; // Convert to double
                                }
                              });
                            }
                          } catch (e) {
                            print('error $e');
                          }
                        }
                      });

                      // setState(() {
                      //   if (newValue != null) {
                      //     showFillDialog();
                      //     try {
                      //       selectedDryArea = newValue;
                      //       final dryArea = dryingController.dryAreaList
                      //           .firstWhere((element) =>
                      //               element.id == int.parse(selectedDryArea!));
                      //       dryAreaId = dryArea.uid;
                      //
                      //       rows = dryArea.row;
                      //       column = dryArea.column;
                      //       filledUnits =
                      //           List<double>.filled(rows * column, 0.0);
                      //       initialFillMap.clear();
                      //
                      //       if (dryArea.fillArea != null) {
                      //         dryArea.fillArea!.filled?.forEach((key, value) {
                      //           int index = int.parse(key.substring(2)) - 1;
                      //           if (index >= 0 && index < filledUnits.length) {
                      //             filledUnits[index] = value * unitsPerCell;
                      //             initialFillMap[index] = value;
                      //           }
                      //         });
                      //       }
                      //     } catch (e) {
                      //       print('error $e');
                      //     }
                      //   }
                      // });
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
                                bool isPrefilled = filledUnits[index] > 0;
                                double fillFraction =
                                    filledUnits[index] / unitsPerCell;
                                Color cellColor = isPrefilled
                                    ? Color(Utils.getColorWithoutHash(
                                        color: color ?? '#2196F3FF'))
                                    : Color(Utils.getColorWithoutHash(
                                        color:
                                            widget.campusColor ?? '#2196F3FF'));

                                return GestureDetector(
                                  onTap: () => _handleTap(index),
                                  child: Container(
                                    color: Colors.grey,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: FractionallySizedBox(
                                        widthFactor: 1.0,
                                        heightFactor: fillFraction,
                                        child: Container(color: cellColor),
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
                  if (selectedDryArea != null)
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
      bottomSheet: !widget.isButton
          ? const SizedBox()
          : selectedDryArea == null
              ? const SizedBox()
              : Obx(() => dryingController.updateDryArea.value
                  ? LoadingAnimationWidget.discreteCircle(
                      size: 40,
                      color: Colors.blue,
                      secondRingColor: const Color(0xFF1A1A3F),
                      thirdRingColor: const Color(0xFFEA3799))
                  : RoundButtonAnimate(
                      buttonName: 'Start Drying',
                      onClick: () {
                        print(
                            'dry area id$dryAreaId $initialFillMap${widget.campusId}');
                        if (filledMapFinal != null) {
                          dryingController
                              .updateFilledArea(
                                  dryAreaId: dryAreaId!,
                                  mapData: filledMapFinal!,
                                  campusId: widget.campusId)
                              .then((value) {
                            Get.to(() => StartDryingPage(
                                  campusName: widget.campusName,
                                  date: widget.date,
                                  collectionNo: widget.collectionNo,
                                  collectionId: widget.collectionId,
                                  status: widget.status,
                              campusId: widget.campusId,
                                ));
                          });
                        } else {
                          Utils.showScaffoldMessageI(
                              context: context,
                              title: 'Please fill all dry area');
                        }
                      },
                      image: Image.asset(
                        'assets/icons/washing.png',
                        height: 30,
                        color: Colors.white,
                      ),
                    )),
    );
  }
}
