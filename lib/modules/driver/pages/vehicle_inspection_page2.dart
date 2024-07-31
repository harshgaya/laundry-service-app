import 'package:flutter/material.dart';

class VehicleInspectionPage2 extends StatefulWidget {
  const VehicleInspectionPage2({super.key});

  @override
  State<VehicleInspectionPage2> createState() => _VehicleInspectionPage2State();
}

class _VehicleInspectionPage2State extends State<VehicleInspectionPage2> {
  List<String> vehicleParts = [
    'Odometer',
    'Spare Tyre',
    'Front',
    'Right Side',
    'Left Side',
    'Back'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 10.0, // Spacing between rows
          ),
          itemCount: vehicleParts.length, // Number of items
          itemBuilder: (context, index) {
            return Column(
              children: [
                const Icon(
                  Icons.camera_alt,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  vehicleParts[index],
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
