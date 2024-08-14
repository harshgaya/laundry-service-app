import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String selectedFilter = 'Collection No';
  List<int> selectedCollectionNos = [];
  DateTime? startDate;
  DateTime? endDate;

  final collectionNumbers = [12, 34, 45, 78]; // Sample data

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
      body: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Collection No';
                            });
                          },
                          child: Text('Collection No'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Date';
                            });
                          },
                          child: Text('Date'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          selectedFilter == 'Collection No'
              ? Expanded(child: _buildCollectionNoSelector())
              : Expanded(child: _buildDateRangeSelector()),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            // Handle apply logic here
            print('Selected Filter: $selectedFilter');
            if (selectedFilter == 'Collection No') {
              print('Selected Collection Nos: $selectedCollectionNos');
            } else if (selectedFilter == 'Date') {
              print('Selected Date Range: $startDate to $endDate');
            }
            Get.back(result: selectedCollectionNos);
          },
          child: const Text(
            'Apply',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionNoSelector() {
    return Column(
      children: collectionNumbers.map((collectionNo) {
        return ListTile(
          title: Text(collectionNo.toString()),
          leading: GestureDetector(
            onTap: () {
              setState(() {
                if (selectedCollectionNos.contains(collectionNo)) {
                  selectedCollectionNos.remove(collectionNo);
                } else {
                  selectedCollectionNos.add(collectionNo);
                }
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                shape: BoxShape.rectangle,
                color: selectedCollectionNos.contains(collectionNo)
                    ? Colors.blue
                    : Colors.transparent,
              ),
              child: selectedCollectionNos.contains(collectionNo)
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  _selectDateRange(context);
                },
                child: Text(
                  'Select Date Range',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        if (startDate != null && endDate != null)
          Text(
            'Selected Date Range: ${DateFormat.yMMMd().format(startDate!)} - ${DateFormat.yMMMd().format(endDate!)}',
            style: TextStyle(fontSize: 16),
          ),
      ],
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }
}
