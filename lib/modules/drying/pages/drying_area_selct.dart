import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
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
        ),
      ),
    );
  }
}
