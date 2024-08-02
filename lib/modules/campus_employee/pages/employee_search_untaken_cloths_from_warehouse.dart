import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_compare_daysheet.dart';

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
  List<CollectionUntakenClothData> filteredCloths = [];

  @override
  void initState() {
    super.initState();

    searchController.addListener(_filterCloths);
  }

  void _filterCloths() {
    final searchText = searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      setState(() {
        filteredCloths = [];
      });
    } else {
      setState(() {
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
                    prefixIcon: Image.asset('assets/icons/search.png'),
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
