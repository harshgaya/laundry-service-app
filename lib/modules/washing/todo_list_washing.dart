import 'dart:math';

import 'package:flutter/material.dart';
import 'package:laundry_service/modules/campus_employee/widgets/white_container.dart';

class ToDoListWashing extends StatefulWidget {
  const ToDoListWashing({super.key});

  @override
  State<ToDoListWashing> createState() => _ToDoListWashingState();
}

class _ToDoListWashingState extends State<ToDoListWashing> {
  final List<String> items = [
    'UB',
    'PG',
    'AC',
    'MB',
    'NB',
  ];
  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WhiteContainer(widget: Text('Id:ede5')),
                WhiteContainer(widget: Text('${DateTime.now()}')),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            WhiteContainer(widget: Text('To Do List')),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    color: getRandomColor(),
                    child: Text(
                      items[index],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Text color
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
