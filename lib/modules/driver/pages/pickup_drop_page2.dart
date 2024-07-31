import 'package:flutter/material.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class PickUpDropPage2 extends StatefulWidget {
  const PickUpDropPage2({super.key});

  @override
  State<PickUpDropPage2> createState() => _PickUpDropPage2State();
}

class _PickUpDropPage2State extends State<PickUpDropPage2> {
  final List<Map<String, String>> data = [
    {"college Code": "12A", "Bag No": "5"},
    {"college Code": "13B", "Bag No": "6"},
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('PICKUP'),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WhiteContainer(
                    widget: Text('edf45'),
                  ),
                  WhiteContainer(
                    widget: Text('${DateTime.now()}'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WhiteContainer(
                    widget: Text('Bag No'),
                  ),
                  WhiteContainer(
                    widget: Text('Done'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Table(
                      border: TableBorder.all(),
                      columnWidths: {
                        0: FlexColumnWidth(0.2),
                        1: FlexColumnWidth(0.4),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'College Code',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Bag No',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        ...data.map((item) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item["college Code"]!),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item["Bag No"]!),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
