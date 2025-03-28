import 'package:flutter/material.dart';

class ButtonNoRadius extends StatelessWidget {
  final bool isSelected;
  final String buttonText;
  final VoidCallback function;
  const ButtonNoRadius(
      {super.key,
      required this.isSelected,
      required this.buttonText,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Border radius
          ),
        ),
        onPressed: function,
        child: Text(
          buttonText,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ));
  }
}
