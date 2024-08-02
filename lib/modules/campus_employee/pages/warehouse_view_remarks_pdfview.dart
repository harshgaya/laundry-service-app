import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class WarehouseViewRemarksPdfView extends StatefulWidget {
  const WarehouseViewRemarksPdfView({super.key});

  @override
  State<WarehouseViewRemarksPdfView> createState() =>
      _WarehouseViewRemarksPdfViewState();
}

class _WarehouseViewRemarksPdfViewState
    extends State<WarehouseViewRemarksPdfView> {
  String? _localFilePath;
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
            const Text(
              'View Remarks\nFrom Warehouse',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            _localFilePath != null
                ? Expanded(
                    child: PDFView(
                      filePath: _localFilePath,
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
            const SizedBox(
              height: 20,
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
            )
          ],
        ),
      ),
    );
  }
}
