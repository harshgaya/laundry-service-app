import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DryAreaAll extends StatefulWidget {
  const DryAreaAll({super.key});

  @override
  State<DryAreaAll> createState() => _DryAreaAllState();
}

class _DryAreaAllState extends State<DryAreaAll> {
  int totalClothes = 210;
  int redClothes = 110;
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
                '210',
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
                int clothesPerCell = (totalClothes / 81).ceil();
                int remainingClothes = totalClothes - (index * clothesPerCell);
                Color cellColor;

                if (remainingClothes > 0) {
                  if (remainingClothes > redClothes) {
                    cellColor = Colors.black;
                  } else {
                    cellColor = Colors.red;
                  }
                } else {
                  cellColor =
                      Colors.grey; // Default color if no clothes left to fill
                }

                return Container(
                  color: cellColor,
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
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text('Shri Chaityna'),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text('DPS'),
            ],
          ),
          const SizedBox(
            height: 150,
          ),
        ],
      ),
    );
  }
}
