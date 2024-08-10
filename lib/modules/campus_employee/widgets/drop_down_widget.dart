import 'package:flutter/material.dart';

class DropDownWidget extends StatelessWidget {
  final String hintText;
  final String? selectedText;
  final List<String> listOfString;
  final ValueChanged<String?> onChanged;

  const DropDownWidget({
    super.key,
    required this.hintText,
    required this.selectedText,
    required this.listOfString,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.blue,
      ),
      value: selectedText,
      onChanged: onChanged,
      dropdownColor: Colors.blue,
      items: listOfString.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
