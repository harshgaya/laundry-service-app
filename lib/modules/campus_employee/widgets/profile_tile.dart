import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback function;
  const ProfileWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: Get.width,
            height: 2,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
