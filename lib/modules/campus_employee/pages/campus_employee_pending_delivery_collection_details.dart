import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/campus_employee_controller.dart';

class CampusEmployeePendingDeliveryCollectionDetails extends StatefulWidget {
  const CampusEmployeePendingDeliveryCollectionDetails({super.key});

  @override
  State<CampusEmployeePendingDeliveryCollectionDetails> createState() =>
      _CampusEmployeePendingDeliveryCollectionDetailsState();
}

class _CampusEmployeePendingDeliveryCollectionDetailsState
    extends State<CampusEmployeePendingDeliveryCollectionDetails> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  String? _localFilePath;
  bool studentDaySheetSelected = true;
  bool facultyDaySheetSelected = false;
  Future<void> _downloadFile() async {
    try {
      // Load the file from assets
      final ByteData data = await rootBundle.load('assets/pdfs/warehouse.pdf');

      // Get the path to the local directory (e.g., documents directory)
      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        print('Error getting local directory');
        return;
      }

      // Define the path where you want to save the file
      final String path = '${directory.path}/warehouse.pdf';
      final File file = File(path);

      // Write the file to the local storage
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);

      print('File downloaded to $path');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File downloaded to $path')),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download file')),
      );
    }
  }

  Future<void> _loadPdfFromAssets() async {
    try {
      // Load PDF file from assets
      final ByteData data = await rootBundle.load('assets/pdfs/warehouse.pdf');
      final Directory tempDir = await getTemporaryDirectory();
      final File tempFile = File('${tempDir.path}/warehouse.pdf');
      await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);

      setState(() {
        _localFilePath = tempFile.path;
      });
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPdfFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              studentDaySheetSelected
                  ? 'Student Delivery\nDay Sheet'
                  : 'Faculty Delivery\nDay Sheet',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    setState(() {
                      studentDaySheetSelected = !studentDaySheetSelected;
                      facultyDaySheetSelected = !facultyDaySheetSelected;
                    });
                  },
                  child: Text(
                    facultyDaySheetSelected
                        ? 'Student Day Sheet'
                        : 'Faculty Day Sheet',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            studentDaySheetSelected
                ? Obx(() => Expanded(
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder(
                              horizontalInside:
                                  BorderSide(color: Colors.black, width: 0.2)),
                          children: [
                            // Table header
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'TAG NO.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Campus Count',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Table rows from the orders list
                            ...campusEmployeeController
                                .campusEmployeeStudentDaySheetCompare
                                .asMap()
                                .entries
                                .map((order) {
                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        order.value.tagNo.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${order.value.campusCount}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ))
                : Obx(() => Expanded(
                      child: SingleChildScrollView(
                        child: Table(
                          border: TableBorder(
                              horizontalInside:
                                  BorderSide(color: Colors.black, width: 0.2)),
                          children: [
                            // Table header
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Faculty Name',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Campus Count',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Table rows from the orders list
                            ...campusEmployeeController
                                .campusEmployeeFacultyDaySheetCompare
                                .asMap()
                                .entries
                                .map((order) {
                              return TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        order.value.facultyName.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        '${order.value.campusCount}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    )),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      if (_localFilePath != null) {
                        await Share.shareXFiles([XFile(_localFilePath!)],
                            text: 'Check out this PDF!');
                      } else {
                        print('No file to share.');
                      }
                    },
                    icon: Icon(
                      Icons.share,
                      size: 50,
                    )),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () async {
                      await _downloadFile();
                    },
                    icon: Icon(
                      Icons.download,
                      size: 50,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
