import 'package:flutter/material.dart';

class Utils {
  static void showScaffoldMessageI(
      {required BuildContext context, required String title}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }
}
