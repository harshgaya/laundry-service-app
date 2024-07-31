import 'package:flutter/material.dart';

class ViewRemarksFromWarehouse extends StatefulWidget {
  const ViewRemarksFromWarehouse({super.key});

  @override
  State<ViewRemarksFromWarehouse> createState() =>
      _ViewRemarksFromWarehouseState();
}

class _ViewRemarksFromWarehouseState extends State<ViewRemarksFromWarehouse> {
  List<TagEntry> tagEntries = [
    TagEntry(serialNo: 1, tagNo: 'SKH-300', remarks: 'Cleaned'),
    TagEntry(serialNo: 2, tagNo: 'SKH-301', remarks: 'Pending'),
    // Add more tag entries here
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Warehouse Remarks')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text('S.No')),
              DataColumn(label: Text('Tag No')),
              DataColumn(label: Text('Remarks')),
            ],
            rows: tagEntries.map((tagEntry) {
              return DataRow(cells: [
                DataCell(Text(tagEntry.serialNo.toString())),
                DataCell(Text(tagEntry.tagNo)),
                DataCell(Text(tagEntry.remarks)),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class TagEntry {
  final int serialNo;
  final String tagNo;
  final String remarks;

  TagEntry({
    required this.serialNo,
    required this.tagNo,
    required this.remarks,
  });
}
