import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry_service/modules/segregation/controler/seg_controller.dart';

class SegregationRemarksPage extends StatefulWidget {
  const SegregationRemarksPage({super.key});

  @override
  State<SegregationRemarksPage> createState() => _SegregationRemarksPageState();
}

class _SegregationRemarksPageState extends State<SegregationRemarksPage> {
  final segController = Get.put(SegController());
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
              'Remarks',
              style: GoogleFonts.roboto(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => Expanded(
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
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'TAG NO',
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
                        ...segController.remarks.asMap().entries.map((order) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      order.value.tagNo.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      '${order.value.remarks}',
                                      style: TextStyle(
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
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
