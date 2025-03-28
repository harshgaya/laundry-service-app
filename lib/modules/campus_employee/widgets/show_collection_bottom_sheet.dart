import 'package:flutter/material.dart';
import 'package:laundry_service/modules/campus_employee/controllers/campus_employee_controller.dart';

import '../models/day_sheet_history.dart';
import 'bottom_scaffold_widget.dart';

void showCollectionDetailsSheet({
  required BuildContext context,
  required String id,
  required String dateCreated,
  required String deliveryStatus,
  required int studentTagCount,
  required int facultyTagCount,
  required List<StudentDaySheet> studentData,
  required List<FacultyDaySheet> facultyData,
  required String uid,
  required String collectionPickupTime,
  required String inTransitFromCampusTime,
  required String deliveryToCampusTime,
  required bool uniform,
  required String inTransitFromWarehouseTime,
  required String pickupFromCampusTime,
  required String deliveredToWarehouse,
  required String washingStartTime,
  required String washingEndTime,
  required String dryingStartTime,
  required String dryingEndTime,
  required String segStartTime,
  required String segEndTime,
  required String employee,
  required List<OtherClothDaySheet> otherCloth,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return CollectionDetailsBottomSheet(
        id: id,
        dateCreated: dateCreated,
        deliveryStatus: deliveryStatus,
        studentTagCount: studentTagCount,
        facultyTagCount: facultyTagCount,
        studentData: studentData,
        facultyData: facultyData,
        uid: uid,
        collectionPickupTime: collectionPickupTime,
        inTransitFromCampusTime: inTransitFromCampusTime,
        deliveryToCampusTime: deliveryToCampusTime,
        uniform: uniform,
        inTransitFromWarehouseTime: inTransitFromWarehouseTime,
        pickupFromCampusTime: pickupFromCampusTime,
        deliveredToWarehouse: deliveredToWarehouse,
        washingStartTime: washingStartTime,
        washingEndTime: washingEndTime,
        dryingStartTime: dryingStartTime,
        dryingEndTime: dryingEndTime,
        segStartTime: segStartTime,
        segEndTime: segEndTime,
        employee: employee,
        otherCloth: otherCloth,
      );
    },
  );
}
