import 'package:flutter/material.dart';
import 'package:laundry_service/modules/drying/pages/drying_history.dart';

import '../../driver/widgets/task_count_widget.dart';
import '../../driver/widgets/task_tile_widget.dart';
import 'package:get/get.dart';

class DryingHistoryPage extends StatefulWidget {
  const DryingHistoryPage({super.key});

  @override
  State<DryingHistoryPage> createState() => _DryingHistoryPageState();
}

class _DryingHistoryPageState extends State<DryingHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 150,
              width: Get.width,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Drying History',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              height: 70,
              bottom: -35,
              left: 10,
              right: 10,
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TaskCountWidget(title: 'Overdue', count: '200'),
                      TaskCountWidget(title: 'To Do', count: '81'),
                      TaskCountWidget(title: 'Open', count: '5'),
                      TaskCountWidget(title: 'Overdue', count: '50'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        TaskTileWidget(
          color1: Colors.red,
          title1: 'Asset',
          title2: 'In progress',
          title3: 'Collection No-1',
          title4: 'Sri Chaitnya',
          icon: Icons.bookmark,
          color2: Colors.green,
          function: () {
            Get.to(() => const DryingHistory());
          },
        ),
      ],
    );
  }
}
