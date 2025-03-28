import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../modules/campus_employee/models/day_sheet_history.dart';
import '../modules/washing/controllers/washing_controller.dart';

class Utils {
  static void showScaffoldMessageI(
      {required BuildContext context, required String title}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }

  static Future<File?> captureImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  static showDialogPopUp(
      {required BuildContext context,
      required VoidCallback function,
      required String title}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    function();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }

  static String encodeFileToBase64(File file) {
    List<int> fileBytes = file.readAsBytesSync();
    return base64Encode(fileBytes);
  }

  // static String formatDate({required String time}) {
  //   return DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(time));
  // }
  static String formatDate({required String time}) {
    DateTime utcDateTime = DateTime.parse(time);
    DateTime istDateTime =
        utcDateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd-MM-yyyy hh:mm a').format(istDateTime);
  }

  static bool checkIfToday(String dateString) {
    DateTime date1 = DateTime.parse(dateString);
    DateTime date = date1.toUtc().add(const Duration(hours: 5, minutes: 30));
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case "READY_TO_PICK":
        return Colors.orange;
      case "INTRANSIT_FROM_cAMPUS":
        return Colors.blue;
      case "DELIVERED_TO_WAREHOUSE":
        return Colors.green;
      case "WASHING":
        return Colors.indigo;
      case "WASHING_DONE":
        return Colors.lightBlue;
      case "DRYING":
        return Colors.yellow;
      case "DRYING_DONE":
        return Colors.deepOrange;
      case "IN_SEGREGATION":
        return Colors.purple;
      case "SEGREGATION_DONE":
        return Colors.pink;
      case "READY_FOR_DELIVERY":
        return Colors.teal;
      case "INTRANSIT_FROM_WAREHOUSE":
        return Colors.cyan;
      case "DELIVERED_TO_CAMPUS":
        return Colors.red;
      case "DELIVERED_TO_STUDENT":
        return Colors.lime;
      default:
        return Colors.grey; // Default color for unknown statuses
    }
  }

  static String getTimeForStatus(String status, List<StatusEntry> statusEntry,
      String currentStatus, String updatedTime) {
    print('current status ${currentStatus} $status');
    if (status == currentStatus) {
      print('this called ${updatedTime}');
      return formatDate(time: updatedTime);
    }
    for (var entry in statusEntry) {
      if (entry.status == status) {
        print('get time for status ${formatDate(time: entry.updatedTime)}');
        return formatDate(time: entry.updatedTime);
      }
    }

    return '';
  }

  static String getTimeForStatus3(
      String status, List<StatusEntry> statusEntry) {
    for (var entry in statusEntry) {
      if (entry.status == status) {
        print('get time for status ${formatDate(time: entry.updatedTime)}');
        return formatDate(time: entry.updatedTime);
      }
    }

    return '';
  }

  static String extractNumber(String input) {
    final RegExp regex = RegExp(r'\d+');
    final Match? match = regex.firstMatch(input);

    if (match != null) {
      return match.group(0)!; // Return the matched number as a string
    } else {
      return ''; // Return an empty string if no numbers are found
    }
  }

  static addNoTagDialog(
      {required BuildContext context, required String collectionId}) {
    showDialog(
        context: context,
        builder: (context) {
          final textController = TextEditingController();
          final washingController = Get.put(WashingController());
          return AlertDialog(
            title: const Text('Enter no tag clothes'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      hintText: 'Enter total no tag clothes'),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    washingController.addNoTag(
                        collectionId: collectionId,
                        noTagCount: textController.text,
                        context: context);
                  }
                  textController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
  }

  static getColorWithoutHash({required String color}) {
    String removedHash = color.replaceFirst('#', '');
    return int.tryParse("0xFF$removedHash");
  }
}
