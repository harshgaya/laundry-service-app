import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectTileWidget extends StatelessWidget {
  final String title;
  final String image;
  final Color color;
  final VoidCallback function;
  const SelectTileWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.color,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: Get.width,
        height: 150,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Image.asset(
                image,
                height: 80,
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
