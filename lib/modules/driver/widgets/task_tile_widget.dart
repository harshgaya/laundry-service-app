import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskTileWidget extends StatelessWidget {
  final VoidCallback function;
  final Color color1;
  final String title1;
  final String title2;
  final String title3;
  final String title4;
  final IconData icon;
  final Color color2;
  const TaskTileWidget(
      {super.key,
      required this.function,
      required this.color1,
      required this.title1,
      required this.title2,
      required this.title3,
      required this.title4,
      required this.icon,
      required this.color2});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
          width: Get.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 10,
                decoration: BoxDecoration(
                  color: color1,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width - 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              icon,
                              color: Colors.grey,
                            ),
                            Text(
                              'Asset',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: const BoxDecoration(
                                  color: Colors.green, shape: BoxShape.circle),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('In Progress'),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title3,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title4,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
