import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_service/modules/washing/pages/day_sheet_data.dart';
import '../controllers/campus_employee_controller.dart';
import '../models/day_sheet_history.dart';
import '../pages/campus_employee_pending_delivery_collection_details.dart';
import '../pages/history/campus_employee_compare_daysheet.dart';

class CollectionDetailsBottomSheet extends StatelessWidget {
  final String id;
  final String dateCreated;
  final String deliveryStatus;
  final int studentTagCount;
  final int facultyTagCount;
  final List<StudentDaySheet> studentData;
  final List<FacultyDaySheet> facultyData;
  final List<OtherClothDaySheet> otherCloth;
  final String uid;
  final String collectionPickupTime;
  final String inTransitFromCampusTime;
  final String deliveryToCampusTime;
  final bool uniform;
  final String inTransitFromWarehouseTime;
  final String pickupFromCampusTime;
  final String deliveredToWarehouse;
  final String washingStartTime;
  final String washingEndTime;
  final String dryingStartTime;
  final String dryingEndTime;
  final String segStartTime;
  final String segEndTime;
  final String employee;

  const CollectionDetailsBottomSheet({
    Key? key,
    required this.id,
    required this.dateCreated,
    required this.deliveryStatus,
    required this.studentTagCount,
    required this.facultyTagCount,
    required this.studentData,
    required this.facultyData,
    required this.uid,
    required this.collectionPickupTime,
    required this.inTransitFromCampusTime,
    required this.deliveryToCampusTime,
    required this.uniform,
    required this.inTransitFromWarehouseTime,
    required this.pickupFromCampusTime,
    required this.deliveredToWarehouse,
    required this.washingStartTime,
    required this.washingEndTime,
    required this.dryingStartTime,
    required this.dryingEndTime,
    required this.segStartTime,
    required this.segEndTime,
    required this.employee,
    required this.otherCloth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Collection Details',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: const TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.black,
                      width: 0.2,
                    ),
                  ),
                  children: [
                    _buildTableHeader(),
                    _buildTableRow('ID', id),
                    _buildTableRow('Created Date', dateCreated),
                    _buildTableRow('Current Status', deliveryStatus),
                    if (employee == 'Driver' || employee == 'Campus')
                      _buildTableRow('Collection Pickup', collectionPickupTime),
                    if (employee == 'Driver' || employee == 'Campus')
                      _buildTableRow(
                          'Transit From Campus', inTransitFromCampusTime),

                    ///driver
                    if (employee == 'Driver' || employee == 'Campus')
                      _buildTableRow(
                          'Delivered To Warehouse', deliveredToWarehouse),
                    if (employee == 'Driver' || employee == 'Campus')
                      _buildTableRow(
                          'Transit From Warehouse', inTransitFromWarehouseTime),

                    // if(employee=='Driver')
                    // _buildTableRow('Pickup From Campus', pickupFromCampusTime),

                    if (employee == 'Driver' || employee == 'Campus')
                      _buildTableRow(
                          'Delivered To Campus', deliveryToCampusTime),

                    ///driver

                    ///washing
                    if (employee == 'Washing')
                      _buildTableRow('Washing Started At', washingStartTime),
                    if (employee == 'Washing')
                      _buildTableRow('Washing Completed At', washingEndTime),

                    ///washing

                    ///drying
                    if (employee == 'Drying')
                      _buildTableRow('Drying Started At', dryingStartTime),
                    if (employee == 'Drying')
                      _buildTableRow('Drying Completed At', dryingEndTime),

                    ///drying
                    ///Segregation
                    if (employee == 'Seg')
                      _buildTableRow('Segregation Started At', segStartTime),
                    if (employee == 'Seg')
                      _buildTableRow('Segregation Completed At', segEndTime),

                    ///Segregation
                    _buildTableRow(
                        'Student Tag Count', studentTagCount.toString()),
                    _buildTableRow('Faculty Count', facultyTagCount.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  if (deliveryStatus == "DELIVERED_TO_CAMPUS" &&
                      employee == 'Campus') {
                    Get.to(() => CampusEmployeeCompareDaysheet(
                          studentData: studentData,
                          facultyData: facultyData,
                          collectionId: uid,
                          isFromSearch: false,
                          otherClothList: otherCloth,
                        ));
                  } else {
                    Get.to(() => DaySheetData(
                          studentData: studentData,
                          facultyData: facultyData,
                          isUniform: uniform,
                          otherCloth: otherCloth,
                        ));
                    // Get.to(() => CampusEmployeePendingDeliveryCollectionDetails(
                    //       campusEmployeeStudentDaySheetCompareData: studentData,
                    //       campusEmployeeFacultyDaySheetCompareData: facultyData,
                    //     ));
                  }
                },
                child: Text(
                  deliveryStatus == "DELIVERED_TO_CAMPUS" ? 'Next' : 'Check',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      children: [
        _buildTableCell('Name', isHeader: true),
        _buildTableCell('Value', isHeader: true),
      ],
    );
  }

  TableRow _buildTableRow(String header, String value) {
    return TableRow(
      children: [
        _buildTableCell(header),
        _buildTableCell(value),
      ],
    );
  }

  TableCell _buildTableCell(String text, {bool isHeader = false}) {
    return TableCell(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            text,
            style: TextStyle(
              fontSize: isHeader ? 18 : 16,
              color: isHeader ? Colors.blue : Colors.black,
              fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
