import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_compare_daysheet.dart';

import 'filter_page_campus_employee/filter_page_campus_employee.dart';

class CampusEmployeeSearchUntakenClothsFromWarehouse extends StatefulWidget {
  const CampusEmployeeSearchUntakenClothsFromWarehouse({super.key});

  @override
  State<CampusEmployeeSearchUntakenClothsFromWarehouse> createState() =>
      _CampusEmployeeSearchUntakenClothsFromWarehouseState();
}

class _CampusEmployeeSearchUntakenClothsFromWarehouseState
    extends State<CampusEmployeeSearchUntakenClothsFromWarehouse> {
  final campusEmployeeController = Get.put(CampusEmployeeController());
  final searchController = TextEditingController();
  String? _selectedValue;
  List<CollectionUntakenClothData> filteredCloths = [];
  bool filterVisibility = false;

  @override
  void initState() {
    super.initState();

    searchController.addListener(_filterCloths);
  }

  void _filterCloths() {
    final searchText = searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      setState(() {
        filterVisibility = false;
        filteredCloths = [];
      });
    } else {
      setState(() {
        filterVisibility = true;
        filteredCloths = campusEmployeeController.untakenCloths.where((cloth) {
          return cloth.tagNo.toString().toLowerCase().contains(searchText);
        }).toList();
      });
    }
    print('filter cloth length ${filteredCloths.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search For Untaken Cloths',
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
            children: [
              Container(
                height: 60,
                width: 50,
                child: Center(child: Text('SKH')),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Search Tag No.',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
              visible: filterVisibility,
              child: InkWell(
                onTap: () async {
                  final result = await Get.to(() => FilterWidget());

                  if (result != null && result.isNotEmpty) {
                    filteredCloths = [];
                    setState(() {});
                    filteredCloths =
                        campusEmployeeController.untakenCloths.where((cloth) {
                      final collectionNoString = cloth.collectionNo;
                      return result.contains(collectionNoString);
                    }).toList();
                    print('filter cloth ${filteredCloths.length}');
                    setState(() {});
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.compare_arrows),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Filter'),
                    ],
                  ),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          if (filteredCloths.isNotEmpty)
            Expanded(
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
                              'Collection No',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'No of Untaken Cloths',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Table rows from the orders list
                    ...filteredCloths.map((order) {
                      return TableRow(
                        children: [
                          TableCell(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => CampusEmployeeCompareDaysheet());
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  order.collectionNo.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '${order.unTakenCloths}',
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
            ),
        ],
      ),
    );
  }
}
