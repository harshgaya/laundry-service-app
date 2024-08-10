import 'package:get/get.dart';
import 'package:laundry_service/modules/campus_employee/pages/create_collection_view.dart';
import 'package:laundry_service/network/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constatnts/sharedprefs.dart';
import '../../../network/network_api_services.dart';

class CampusEmployeeController extends GetxController {
  RxString userId = ''.obs;
  RxString collegeName = 'Shri Chaitnaya'.obs;
  final _apiServices = NetworkApiServices();
  RxBool creatingCollection = false.obs;
  RxInt collectionNo = 1.obs;
  var orders = <Order>[].obs;
  var teacherOrders = <TeacherOrder>[].obs;
  var warehouseRemarks = <RemarksWarehouseData>[].obs;
  var remarkToWarehouse = <RemarkToWarehouse>[].obs;
  var untakenClothToWareHouse = <UntakenClothToWarehouse>[
    UntakenClothToWarehouse(tagNo: 23, totalCloths: 3, ticked: false),
    UntakenClothToWarehouse(tagNo: 6, totalCloths: 1, ticked: false),
    UntakenClothToWarehouse(tagNo: 7, totalCloths: 9, ticked: false),
    UntakenClothToWarehouse(tagNo: 12, totalCloths: 2, ticked: false),
  ].obs;
  var campusEmployeeOrdersFromWarehouse =
      <CampusEmployeeOrderFromWarehouseData>[
    CampusEmployeeOrderFromWarehouseData(
        collectionNo: 12,
        deliveryDate: '12-05-24',
        delivered: true,
        tagCount: 12,
        facultyCount: 2),
    CampusEmployeeOrderFromWarehouseData(
        collectionNo: 10,
        deliveryDate: '12-06-24',
        delivered: false,
        tagCount: 30,
        facultyCount: 10),
    CampusEmployeeOrderFromWarehouseData(
        collectionNo: 16,
        deliveryDate: '12-08-24',
        delivered: true,
        tagCount: 103,
        facultyCount: 34),
  ].obs;

  var campusEmployeeStudentDaySheetCompare =
      <CampusEmployeeStudentDaySheetCompareData>[
    CampusEmployeeStudentDaySheetCompareData(
        tagNo: 122, campusCount: 23, warehouseCount: 23, delivered: false),
    CampusEmployeeStudentDaySheetCompareData(
        tagNo: 132, campusCount: 10, warehouseCount: 10, delivered: false),
    CampusEmployeeStudentDaySheetCompareData(
        tagNo: 142, campusCount: 34, warehouseCount: 34, delivered: false),
  ].obs;

  var campusEmployeeFacultyDaySheetCompare =
      <CampusEmployeeFacultyDaySheetCompareData>[
    CampusEmployeeFacultyDaySheetCompareData(
        facultyName: 'SRi',
        campusCount: 23,
        warehouseCount: 23,
        delivered: false),
    CampusEmployeeFacultyDaySheetCompareData(
        facultyName: 'Raj',
        campusCount: 10,
        warehouseCount: 10,
        delivered: false),
    CampusEmployeeFacultyDaySheetCompareData(
        facultyName: 'Gupta',
        campusCount: 34,
        warehouseCount: 34,
        delivered: false),
  ].obs;

  var untakenCloths = <CollectionUntakenClothData>[
    CollectionUntakenClothData(
      collectionNo: 12,
      unTakenCloths: 2,
      tagNo: 23,
    ),
    CollectionUntakenClothData(
      collectionNo: 34,
      unTakenCloths: 5,
      tagNo: 13,
    ),
    CollectionUntakenClothData(
      collectionNo: 45,
      unTakenCloths: 9,
      tagNo: 2,
    ),
    CollectionUntakenClothData(
      collectionNo: 78,
      unTakenCloths: 67,
      tagNo: 5,
    ),
    CollectionUntakenClothData(
      collectionNo: 12,
      unTakenCloths: 1,
      tagNo: 7,
    ),
  ];

  // Add a new order to the list
  void addOrder(String tagNo, int cloths, int uniforms) {
    // Check if the tagNo already exists in the orders list
    int index = orders.indexWhere((order) => order.tagNo == tagNo);

    if (index != -1) {
      // Update the existing order with the new values
      orders[index].totalCloths = cloths;
      orders[index].totalUniforms = uniforms;
    } else {
      // Add a new order if tagNo doesn't exist
      orders.add(Order(
        tagNo: tagNo,
        totalCloths: cloths,
        totalUniforms: uniforms,
        remarks: '',
      ));
    }
  }

  void addRemarkToWareHouse(int tagNo, String remarks) {
    remarkToWarehouse.add(RemarkToWarehouse(tagNo: tagNo, remarks: remarks));
  }

  void addOrUpdateTeacherOrder(TeacherOrder newOrder) {
    print('teacher ${newOrder.teacherName}');
    final index = teacherOrders
        .indexWhere((order) => order.teacherName == newOrder.teacherName);

    if (index != -1) {
      // Update existing order
      teacherOrders[index] = newOrder;
    } else {
      // Add new order
      teacherOrders.add(newOrder);
    }
  }

  Map<String, int> calculateTotalClothesPerTeacher() {
    Map<String, int> totals = {};

    for (var order in teacherOrders) {
      if (!totals.containsKey(order.teacherName)) {
        totals[order.teacherName] = 0;
      }

      totals[order.teacherName] = (totals[order.teacherName] ?? 0) +
          order.shirts +
          order.pants +
          order.bedsheets +
          order.towels;
    }

    return totals;
  }

  Future<void> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(SharedPreferenceKey.UserId) ?? '';
    String college =
        sharedPreferences.getString(SharedPreferenceKey.collegeName) ?? '';
    userId.value = id;
    collegeName.value = college;
  }

  Future<void> createCollectionNo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(SharedPreferenceKey.UserId) ?? '';
    String college =
        sharedPreferences.getString(SharedPreferenceKey.collegeName) ?? '';
    try {
      creatingCollection.value = true;
      var data = {
        "collegeName": collegeName.value,
        "createdBy": id,
      };
      var response =
          await _apiServices.postApi(data, UrlConstants.createCollectionNo);
      collectionNo.value = response['data'][0]['collectionNo'];
      Get.to(() => const CreateCollectionView());

      creatingCollection.value = false;
    } catch (e) {
      creatingCollection.value = false;
    }
  }
}

class Order {
  String tagNo;
  int totalCloths;
  int totalUniforms;
  String remarks = '';

  Order(
      {required this.tagNo,
      required this.totalUniforms,
      required this.remarks,
      required this.totalCloths});
}

class TeacherOrder {
  int shirts;
  int pants;
  int bedsheets;
  int towels;
  String teacherName;

  TeacherOrder({
    required this.teacherName,
    required this.bedsheets,
    required this.pants,
    required this.shirts,
    required this.towels,
  });
}

class RemarksWarehouseData {
  int collectionId;
  String deliveryTime;
  String remarks;

  RemarksWarehouseData({
    required this.collectionId,
    required this.deliveryTime,
    required this.remarks,
  });
}

class RemarkToWarehouse {
  int tagNo;
  String remarks;

  RemarkToWarehouse({
    required this.tagNo,
    required this.remarks,
  });
}

class UntakenClothToWarehouse {
  int tagNo;
  int totalCloths;
  bool ticked;

  UntakenClothToWarehouse({
    required this.ticked,
    required this.tagNo,
    required this.totalCloths,
  });
}

class CampusEmployeeOrderFromWarehouseData {
  int collectionNo;
  String deliveryDate;
  bool delivered;
  int tagCount;
  int facultyCount;

  CampusEmployeeOrderFromWarehouseData({
    required this.tagCount,
    required this.facultyCount,
    required this.collectionNo,
    required this.deliveryDate,
    required this.delivered,
  });
}

class CampusEmployeeStudentDaySheetCompareData {
  int tagNo;
  int campusCount;
  int warehouseCount;
  bool delivered;

  CampusEmployeeStudentDaySheetCompareData({
    required this.tagNo,
    required this.campusCount,
    required this.warehouseCount,
    required this.delivered,
  });
}

class CampusEmployeeFacultyDaySheetCompareData {
  String facultyName;
  int campusCount;
  int warehouseCount;
  bool delivered;

  CampusEmployeeFacultyDaySheetCompareData({
    required this.facultyName,
    required this.campusCount,
    required this.warehouseCount,
    required this.delivered,
  });
}

class CollectionUntakenClothData {
  int collectionNo;
  int unTakenCloths;
  int tagNo;
  CollectionUntakenClothData({
    required this.tagNo,
    required this.collectionNo,
    required this.unTakenCloths,
  });
}
