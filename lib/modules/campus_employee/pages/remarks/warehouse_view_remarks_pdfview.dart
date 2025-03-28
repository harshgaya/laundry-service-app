import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/day_sheet_history.dart';

class WarehouseViewRemarksPdfView extends StatefulWidget {
  final String collectionNo;
  final List<WarehouseRemark> warehouseRemarkList;
  const WarehouseViewRemarksPdfView(
      {super.key,
      required this.warehouseRemarkList,
      required this.collectionNo});

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
          icon: const CircleAvatar(
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
      body: SingleChildScrollView(
        child: Padding(
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
              const SizedBox(
                height: 20,
              ),
              Table(
                border: const TableBorder(
                    horizontalInside:
                        BorderSide(color: Colors.black, width: 0.2)),
                children: [
                  // Table header
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'S.NO.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'TAG NO.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'REMARKS',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Table rows from the orders list
                  ...widget.warehouseRemarkList.asMap().entries.map((order) {
                    return TableRow(
                      children: [
                        TableCell(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${order.key + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                Utils.extractNumber(order.value.tagNumber)
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                order.value.remark,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              // _localFilePath != null
              //     ? Expanded(
              //         child: PDFView(
              //           filePath: _localFilePath,
              //         ),
              //       )
              //     : const Center(child: CircularProgressIndicator()),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () async {
                // if (_localFilePath != null) {
                //   await Share.shareXFiles([XFile(_localFilePath!)],
                //       text: 'Check out this PDF!');
                // } else {
                //   print('No file to share.');
                // }
                final pdf = pw.Document();

                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Remarks From Warehouse',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Text(
                            'Collection No-${widget.collectionNo}',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                          pw.SizedBox(height: 20),
                          pw.Table.fromTextArray(
                            headers: ['S.No', 'Tag No', 'Remarks'],
                            data: List<List<String>>.generate(
                              widget.warehouseRemarkList.length,
                              (index) => [
                                (index + 1).toString(),
                                widget.warehouseRemarkList[index].tagNumber,
                                widget.warehouseRemarkList[index].remark,
                              ],
                            ),
                            border: pw.TableBorder.all(
                              color: PdfColors.black,
                              width: 1,
                            ),
                            cellAlignment: pw.Alignment.centerLeft,
                            headerStyle: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                            cellStyle: const pw.TextStyle(
                              fontSize: 12,
                            ),
                            headerDecoration: const pw.BoxDecoration(
                              color: PdfColors.grey300,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );

                // Save or share the PDF file
                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => pdf.save(),
                );
              },
              icon: const Icon(
                Icons.download,
                size: 50,
              )),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () async {
                // await _downloadFile();
                final pdf = pw.Document();

                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Remarks From Warehouse',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Text(
                            'Collection No-${widget.collectionNo}',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.normal,
                            ),
                          ),
                          pw.SizedBox(height: 20),
                          pw.Table.fromTextArray(
                            headers: ['S.No', 'Tag No', 'Remarks'],
                            data: List<List<String>>.generate(
                              widget.warehouseRemarkList.length,
                              (index) => [
                                (index + 1).toString(),
                                widget.warehouseRemarkList[index].tagNumber,
                                widget.warehouseRemarkList[index].remark,
                              ],
                            ),
                            border: pw.TableBorder.all(
                              color: PdfColors.black,
                              width: 1,
                            ),
                            cellAlignment: pw.Alignment.centerLeft,
                            headerStyle: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                            cellStyle: const pw.TextStyle(
                              fontSize: 12,
                            ),
                            headerDecoration: const pw.BoxDecoration(
                              color: PdfColors.grey300,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );

                // Save the PDF to the device
                final output = await getTemporaryDirectory();
                final file = File(
                    "${output.path}/warehouse_remarks_collection_${widget.collectionNo}.pdf");
                await file.writeAsBytes(await pdf.save());

                // Share the PDF
                await Share.shareFiles([file.path],
                    text: 'Here are the warehouse remarks.');
              },
              icon: const Icon(
                Icons.share,
                size: 50,
              ))
        ],
      ),
    );
  }
}
