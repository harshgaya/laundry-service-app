import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/driver/models/vehicle_data.dart';
import 'package:laundry_service/modules/driver/pages/driver_dashboard.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/constatnts/sharedprefs.dart';
import '../../../network/network_api_services.dart';
import '../../../network/url_constants.dart';
import '../../campus_employee/models/day_sheet_history.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class DriverController extends GetxController {
  final _apiServices = NetworkApiServices();

  ///data
  RxString userId = ''.obs;
  RxString userName = ''.obs;
  RxString mobileNumber = ''.obs;

  ///data
  ///home
  RxInt toDo = 0.obs;
  RxInt open = 0.obs;
  RxInt finished = 0.obs;
  RxInt overdue = 0.obs;
  RxBool gettingToDo = false.obs;
  Rx<EmployeeCollections?> employeeCollection = Rx<EmployeeCollections?>(null);
  Map<String, int> statusPriority = {
    'READY_TO_PICK': 1,
    'INTRANSIT_FROM_cAMPUS': 2,
    'DELIVERED_TO_WAREHOUSE': 3,
    'READY_FOR_DELIVERY': 4,
    'INTRANSIT_FROM_WAREHOUSE': 5,
  };
  RxBool uploadingBagStudent = false.obs;
  RxBool uploadingFacultyStudent = false.obs;
  RxBool uploadingBagOther = false.obs;
  RxBool hasUploadedBagNoStudent = false.obs;
  RxBool hasUploadedBagNoFaculty = false.obs;
  RxBool hasUploadedBagNoOther = false.obs;
  RxList<VehicleData> vehicleListData = <VehicleData>[].obs;
  RxBool gettingVehicleList = false.obs;
  RxBool updatingVehicle = false.obs;

  ///home
  ///active inactive
  RxBool gettingActiveCollection = false.obs;
  Rx<EmployeeCollections?> activeCollection = Rx<EmployeeCollections?>(null);
  Rx<EmployeeCollections?> inActiveCollection = Rx<EmployeeCollections?>(null);

  ///active inactive
  var bagList = <DriverBagData>[].obs;
  var bagListOtherCloth = <DriverBagData>[].obs;
  var driverToDoList = <DriverToDoData>[
    DriverToDoData(collegeName: 'Sri Chaityna', task: 'Collection'),
    DriverToDoData(collegeName: 'DAV', task: 'Collection'),
    DriverToDoData(collegeName: 'DPS', task: 'Delivery'),
  ].obs;
  var teacherBagNoList = <TeacherBagData>[].obs;
  var otherClothList = <OtherClothData>[].obs;
  var driverHistoryList = <DriverCollectionHistoryModel>[
    DriverCollectionHistoryModel(
        collectionId: '5', time: '12-08-14', isDelivered: false, totalItems: 5),
    DriverCollectionHistoryModel(
        collectionId: '13',
        time: '10-08-14',
        isDelivered: false,
        totalItems: 5),
  ].obs;

  addToBagList({required int bagNo, required BuildContext context}) {
    int index = bagList.indexWhere((order) => order.bagNo == bagNo);
    if (index != -1) {
      Utils.showScaffoldMessageI(
          context: context, title: 'This bag No already added');
    } else {
      bagList.add(DriverBagData(campusId: 'SKH', bagNo: bagNo));
    }
  }

  void addOrUpdateTeacherOrder(TeacherBagData newOrder) {
    print('teacher ${newOrder.teacherName}');
    final index = teacherBagNoList
        .indexWhere((order) => order.teacherName == newOrder.teacherName);

    if (index != -1) {
      // Update existing order
      teacherBagNoList[index] = newOrder;
    } else {
      // Add new order
      teacherBagNoList.add(newOrder);
    }
  }

  void addOrUpdateOtherCloth(OtherClothData newOrder) {
    print('teacher ${newOrder.type}');
    final index =
        otherClothList.indexWhere((order) => order.type == newOrder.type);

    if (index != -1) {
      // Update existing order
      otherClothList[index] = newOrder;
    } else {
      // Add new order
      otherClothList.add(newOrder);
    }
  }

  Future<void> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString(SharedPreferenceKey.UserId) ?? '';
    String mobile =
        sharedPreferences.getString(SharedPreferenceKey.mobile) ?? '';
    String? name = sharedPreferences.getString(SharedPreferenceKey.name);
    userName.value = name ?? '';
    mobileNumber.value = mobile;
    userId.value = id;
  }

  Future<void> getVehicleList() async {
    try {
      gettingVehicleList.value = true;

      var response = await _apiServices.getApi2('${UrlConstants.getVehicles}');

      if (response is List) {
        List<VehicleData> vehicles =
            response.map((json) => VehicleData.fromJson(json)).toList();
        vehicleListData.addAll(vehicles);
      } else {
        print('Unexpected response format: ${response.runtimeType}');
      }

      gettingVehicleList.value = false;
    } catch (e) {
      gettingVehicleList.value = false;
      print('Error occurred: $e');
    }
  }

  Future<void> updateVehicle(
      {required String vehicleUid,
      required File image,
      required BuildContext context}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      sharedPreferences.setString(
          SharedPreferenceKey.lastLogin,
          DateTime.now()
              .subtract(const Duration(hours: 5, microseconds: 30))
              .toString());
      print('user id $userId');
      updatingVehicle.value = true;

      String url = UrlConstants.updateVehicle;

      var request =
          http.MultipartRequest('PATCH', Uri.parse('$url/$vehicleUid/'));

      request.fields['last_driver_uid'] = userId!;

      var imageFile = await http.MultipartFile.fromPath(
        'odo_meter_image',
        image.path,
      );

      request.files.add(imageFile);

      var response = await request.send();

      // Convert the response stream to a string and print it
      var responseBody = await response.stream.bytesToString();
      print('Full Response: $responseBody');

      if (response.statusCode == 200) {
        await sharedPreferences.setBool(SharedPreferenceKey.driverData, true);
        Get.offAll(const DriverDashboard());
      } else {
        Utils.showScaffoldMessageI(
            context: context, title: 'Something went wrong');
      }
      updatingVehicle.value = false;
    } catch (e) {
      Utils.showScaffoldMessageI(
          context: context, title: 'Something went wrong');
      updatingVehicle.value = false;
      print('Error uploading vehicle data: $e');
    }
  }

  Future<void> getDriverToDoList() async {
    try {
      if (gettingToDo.value) return;
      gettingToDo.value = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response =
          await _apiServices.getApi('${UrlConstants.getDriverTodo}/$userId/');

      EmployeeCollections employeeCollections =
          EmployeeCollections.fromJson(response, 'data');
      employeeCollection.value = employeeCollections;
      employeeCollection.value?.data.sort((a, b) {
        int priorityA = statusPriority[a.currentStatus] ?? 999;
        int priorityB = statusPriority[b.currentStatus] ?? 999;

        // Compare priorities
        return priorityA.compareTo(priorityB);
      });
      employeeCollection.refresh();

      toDo.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'READY_TO_PICK')
          .length;
      open.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'INTRANSIT_FROM_cAMPUS')
          .length;
      finished.value = employeeCollection.value!.data
          .where((element) => element.currentStatus == 'DELIVERED_TO_CAMPUS')
          .length;
      overdue.value = employeeCollection.value!.data.where((element) {
        if (element.createdAt != null) {
          DateTime today = DateTime.now();
          DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);
          return DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(element.createdAt!)) ==
              DateFormat('yyyy-MM-dd').format(tomorrow);
        }
        return false;
      }).length;
      gettingToDo.value = false;
    } catch (e) {
      gettingToDo.value = false;
      print('error $e');
    }
  }

  ///active inactive
  Future<void> getActiveCollections() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response = await _apiServices
          .getApi('${UrlConstants.getActiveCollection}/$userId/');
      activeCollection.value = null;
      EmployeeCollections employeeCollections =
          EmployeeCollections.fromJson(response, 'active_tasks');
      activeCollection.value = employeeCollections;
      // toDo.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'READY_TO_PICK')
      //     .length;
      // open.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'INTRANSIT_FROM_cAMPUS')
      //     .length;
      // finished.value = activeCollection.value!.data
      //     .where((element) => element.currentStatus == 'DELIVERED_TO_CAMPUS')
      //     .length;
      // overdue.value = activeCollection.value!.data.where((element) {
      //   if (element.createdAt != null) {
      //     DateTime today = DateTime.now();
      //     DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);
      //     return DateFormat('yyyy-MM-dd')
      //             .format(DateTime.parse(element.createdAt!)) ==
      //         DateFormat('yyyy-MM-dd').format(tomorrow);
      //   }
      //   return false;
      // }).length;

      activeCollection.value?.data
          .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> getInActiveCollections() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);
      var response = await _apiServices
          .getApi('${UrlConstants.getInActiveCollection}/$userId/');
      inActiveCollection.value = null;
      EmployeeCollections employeeCollections =
          EmployeeCollections.fromJson(response, 'inactive_tasks');
      inActiveCollection.value = employeeCollections;
      activeCollection.value?.data.addAll(inActiveCollection.value!.data);
      activeCollection.refresh();
      // toDo.value = inActiveCollection.value!.data
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> loadActiveInactive() async {
    try {
      if (gettingActiveCollection.value) return;
      gettingActiveCollection.value = true;
      await Future.wait([getActiveCollections(), getInActiveCollections()]);
      gettingActiveCollection.value = false;
    } catch (e) {
      gettingActiveCollection.value = true;
    }
  }

  ///active inactive

  // Future<void> uploadBag(
  //     {required String status,
  //     required List<int> bagNo,
  //       required File image,
  //     required String collectionId}) async {
  //   try {
  //     String bagField = '';
  //     String imageField = '';
  //     if (status == 'READY_FOR_DELIVERY') {
  //       bagField = 'warehouse_pickup_bag_numbers';
  //       imageField = 'warehouse_pickup_image';
  //     }
  //     if (status == 'INTRANSIT_FROM_WAREHOUSE') {
  //       bagField = 'campus_drop_bag_numbers';
  //       imageField = 'campus_drop_collection_image';
  //     }
  //     if (status == 'READY_TO_PICK') {
  //       bagField = 'campus_pickup_bag_numbers';
  //       imageField = 'campus_pickup_collection_image';
  //     }
  //     if (status == 'INTRANSIT_FROM_cAMPUS') {
  //       bagField = 'warehouse_drop_bag_numbers';
  //       imageField = 'warehouse_drop_image';
  //     }
  //
  //     var data = {
  //       bagField: jsonEncode(bagNo),
  //       imageField:
  //     };
  //     var response = await _apiServices.patchApi(
  //         data, '${UrlConstants.uploadRemarksByCampusEmployee}$collectionId/');
  //   } catch (e) {}
  // }
  Future<void> uploadBag({
    required String status,
    required List<Map<String, dynamic>> bagNo,
    required File image,
    required String collectionId,
    required BuildContext context,
  }) async {
    try {
      uploadingBagStudent.value = true;
      String bagField = '';
      String imageField = '';
      String newStatus = '';

      switch (status) {
        case 'READY_FOR_DELIVERY':
          bagField = 'warehouse_pickup_bag_numbers';
          imageField = 'warehouse_pickup_image';
          newStatus = 'INTRANSIT_FROM_WAREHOUSE';
          break;
        case 'INTRANSIT_FROM_WAREHOUSE':
          bagField = 'campus_drop_bag_numbers';
          imageField = 'campus_drop_collection_image';
          newStatus = 'DELIVERED_TO_CAMPUS';
          break;
        case 'READY_TO_PICK':
          bagField = 'campus_pickup_bag_numbers';
          imageField = 'campus_pickup_collection_image';
          newStatus = 'INTRANSIT_FROM_cAMPUS';
          break;
        case 'INTRANSIT_FROM_cAMPUS':
          bagField = 'warehouse_drop_bag_numbers';
          imageField = 'warehouse_drop_image';
          newStatus = 'DELIVERED_TO_WAREHOUSE';
          break;
        default:
          throw Exception('Invalid status provided');
      }
      print('status ${status} new status ${newStatus}');

      String url =
          '${UrlConstants.uploadRemarksByCampusEmployee}$collectionId/';

      var request = http.MultipartRequest('PATCH', Uri.parse(url));

      request.fields[bagField] = jsonEncode(bagNo);
      request.fields['current_status'] = newStatus;

      var imageFile = await http.MultipartFile.fromPath(
        imageField,
        image.path,
        filename: basename(image.path),
      );

      request.files.add(imageFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        final data = employeeCollection.value!.data
            .firstWhere((element) => element.uid == collectionId);

        if (status == 'INTRANSIT_FROM_WAREHOUSE' ||
            status == 'INTRANSIT_FROM_cAMPUS') {
          employeeCollection.value!.data
              .removeWhere((element) => element.uid == collectionId);
        } else {
          data.currentStatus = newStatus;
        }

        employeeCollection.refresh();
        Utils.showScaffoldMessageI(context: context, title: 'Uploaded!');
        // bagList.value = [];
        Navigator.of(context).pop();
      } else {
        print('Failed to upload bag: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
      }
      uploadingBagStudent.value = false;
      hasUploadedBagNoStudent.value = true;
    } catch (e) {
      uploadingBagStudent.value = false;
      print('Error uploading bag: $e');
    }
  }

  Future<void> uploadFacultyBag({
    required BuildContext context,
    required String status,
    required String collectionId,
  }) async {
    uploadingFacultyStudent.value = true;
    String url = '${UrlConstants.uploadRemarksByCampusEmployee}$collectionId/';

    String bagField = '';
    String imageField = '';
    String newStatus = '';

    switch (status) {
      case 'READY_FOR_DELIVERY':
        bagField = 'warehouse_pickup_faculty_bag_number';
        newStatus = 'INTRANSIT_FROM_WAREHOUSE';
        break;
      case 'INTRANSIT_FROM_WAREHOUSE':
        bagField = 'campus_drop_faculty_bag_number';
        newStatus = 'INTRANSIT_FROM_WAREHOUSE';
        break;
      case 'READY_TO_PICK':
        bagField = 'campus_pickup_faculty_bag_number';
        newStatus = 'INTRANSIT_FROM_cAMPUS';
        break;
      case 'INTRANSIT_FROM_cAMPUS':
        bagField = 'warehouse_drop_faculty_bag_number';
        newStatus = 'INTRANSIT_FROM_cAMPUS';
        break;
      default:
        throw Exception('Invalid status provided');
    }

    var request = http.MultipartRequest('PATCH', Uri.parse(url));

    List<Map<String, dynamic>> formDataList = [];

    try {
      for (var data in teacherBagNoList) {
        Map<String, dynamic> formData = {
          "number_of_bag": data.bagNo,
          "faculty": data.uid,
        };

        formDataList.add(formData);

        if (data.image != null) {
          var imageFile = await http.MultipartFile.fromPath(
            'photo',
            data.image!.path,
            contentType: MediaType('image', 'jpeg'),
            filename: basename(data.image!.path),
          );
          request.files.add(imageFile);
        }
      }
      request.fields[bagField] = jsonEncode(formDataList);

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // teacherBagNoList.value = [];
        Navigator.of(context).pop();
        print('Data sent successfully');
        Utils.showScaffoldMessageI(context: context, title: 'Uploaded!');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
      }
      uploadingFacultyStudent.value = false;
      hasUploadedBagNoFaculty.value = true;
    } catch (e) {
      uploadingFacultyStudent.value = false;
      print('Error sending data: $e');
    }
  }

  Future<void> uploadOtherBag({
    required BuildContext context,
    required String status,
    required File image,
    required String collectionId,
  }) async {
    uploadingBagOther.value = true;
    String url = '${UrlConstants.uploadRemarksByCampusEmployee}$collectionId/';

    String bagField = '';
    String imageField = '';
    String newStatus = '';

    switch (status) {
      case 'READY_FOR_DELIVERY':
        bagField = 'other_cloth_warehouse_pickup';
        newStatus = 'INTRANSIT_FROM_WAREHOUSE';
        break;
      case 'INTRANSIT_FROM_WAREHOUSE':
        bagField = 'other_cloth_campus_drop';
        newStatus = 'INTRANSIT_FROM_WAREHOUSE';
        break;
      case 'READY_TO_PICK':
        bagField = 'other_cloth_campus_pickup';
        newStatus = 'INTRANSIT_FROM_cAMPUS';
        break;
      case 'INTRANSIT_FROM_cAMPUS':
        bagField = 'other_cloth_warehouse_drop';
        newStatus = 'INTRANSIT_FROM_cAMPUS';
        break;
      default:
        throw Exception('Invalid status provided');
    }

    var request = http.MultipartRequest('PATCH', Uri.parse(url));

    List<Map<String, dynamic>> formDataList = [];

    try {
      for (var data in bagListOtherCloth) {
        Map<String, dynamic> formData = {
          "number_of_bag": data.bagNo,
        };

        formDataList.add(formData);
        var imageFile = await http.MultipartFile.fromPath(
          'photo',
          image.path,
          contentType: MediaType('image', 'jpeg'),
          filename: basename(image.path),
        );
        request.files.add(imageFile);
      }
      request.fields[bagField] = jsonEncode(formDataList);
      var response = await request.send();

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        print('Data sent successfully');
        Utils.showScaffoldMessageI(context: context, title: 'Uploaded!');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
      }
      uploadingBagOther.value = false;
      hasUploadedBagNoOther.value = true;
    } catch (e) {
      uploadingBagOther.value = false;
      print('Error sending data: $e');
    }
  }
}

class DriverToDoData {
  String collegeName;
  String task;
  DriverToDoData({required this.collegeName, required this.task});
}

class TeacherBagData {
  String teacherName;
  String bagNo;
  String uid;
  File? image;
  TeacherBagData(
      {required this.teacherName,
      required this.bagNo,
      required this.uid,
      required this.image});
  @override
  String toString() {
    return 'TeacherBagData(teacherName: $teacherName, bagNo: $bagNo, image: ${image?.path ?? 'No Image'})';
  }
}

class OtherClothData {
  String type;
  String noOfPiece;
  OtherClothData({required this.type, required this.noOfPiece});
}

class DriverBagData {
  String campusId;
  int bagNo;
  DriverBagData({required this.campusId, required this.bagNo});
}

class DriverCollectionHistoryModel {
  String collectionId;
  int totalItems;
  String time;
  bool isDelivered;
  DriverCollectionHistoryModel(
      {required this.collectionId,
      required this.time,
      required this.isDelivered,
      required this.totalItems});
}
