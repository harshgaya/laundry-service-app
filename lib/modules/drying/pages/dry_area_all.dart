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
//   final int totalClothes = 210;
//   final int clothesPerCell = 10;
//   final int redClothes = 110;
//   final int blackClothes = 100;
//   int rows = 9;
//   int column = 5;
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
//                 '210',
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
//               itemCount: 9 * 5,
//               itemBuilder: (context, index) {
//                 if (index < (redClothes / clothesPerCell).ceil()) {
//                   // Fill with red color for first 11 cells (110/10)
//                   return Container(
//                     color: Colors.red,
//                   );
//                 } else if (index <
//                     ((redClothes + blackClothes) / clothesPerCell).ceil()) {
//                   // Fill with black color for the next 10 cells
//                   return Container(
//                     color: Colors.black,
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
//                 height: 10,
//                 width: 10,
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Text('Shri Chaityna'),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             children: [
//               Container(
//                 height: 10,
//                 width: 10,
//                 decoration: const BoxDecoration(
//                   color: Colors.red,
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Text('DPS'),
//             ],
//           ),
//           const SizedBox(
//             height: 150,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DryAreaAll extends StatefulWidget {
  const DryAreaAll({super.key});

  @override
  State<DryAreaAll> createState() => _DryAreaAllState();
}

class _DryAreaAllState extends State<DryAreaAll> {
  final int clothesPerCell = 10;
  int rows = 9;
  int column = 5;
  List<String> dryArea = ['Dry Area 1', 'Dry Area 2', 'Dry Area 3'];
  String selectedDryArea = 'Dry Area 1';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dry Area',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButtonFormField<String>(
            onChanged: (String? newValue) {
              setState(() {
                selectedDryArea = newValue!;
                int index = dryArea.indexOf(newValue);

                if (index == 0) {
                  rows = 9;
                } else if (index == 1) {
                  rows = 9;
                } else if (index == 2) {
                  rows = 12;
                } else if (index == 3) {
                  rows = 5;
                } else {
                  rows = 5;
                }
              });
            },
            decoration: InputDecoration(
              hintText: 'Dry Area',
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
            items: dryArea.map<DropdownMenuItem<String>>((String dryArea) {
              return DropdownMenuItem<String>(
                value: dryArea,
                child: Text(
                  dryArea,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
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
                '22',
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
              itemCount: rows * column,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // 1st cell - 100% filled with black
                  return Container(
                    color: Colors.black,
                  );
                } else if (index == 1) {
                  // 2nd cell - 10% filled with black
                  return FractionallySizedBox(
                    widthFactor: 1.0,
                    heightFactor: 0.1,
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: Colors.black,
                    ),
                  );
                } else if (index == 2) {
                  // 3rd cell - 100% filled with red
                  return Container(
                    color: Colors.red,
                  );
                } else if (index == 3) {
                  // 4th cell - 20% filled with red
                  return FractionallySizedBox(
                    widthFactor: 1.0,
                    heightFactor: 0.2,
                    alignment: Alignment.topCenter,
                    child: Container(
                      color: Colors.red,
                    ),
                  );
                } else {
                  // Remaining cells will be grey
                  return Container(
                    color: Colors.grey,
                  );
                }
              },
            ),
          ),
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Text('Shri Chaityna'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              Text('DPS'),
            ],
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }
}
