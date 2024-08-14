import 'package:get/get.dart';

class DriverController extends GetxController {
  var bagList = <DriverBagData>[].obs;
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

  addToBagList({required String bagNo}) {
    bagList.add(DriverBagData(campusId: 'SKH', bagNo: bagNo));
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
}

class DriverToDoData {
  String collegeName;
  String task;
  DriverToDoData({required this.collegeName, required this.task});
}

class TeacherBagData {
  String teacherName;
  String bagNo;
  TeacherBagData({required this.teacherName, required this.bagNo});
}

class OtherClothData {
  String type;
  String noOfPiece;
  OtherClothData({required this.type, required this.noOfPiece});
}

class DriverBagData {
  String campusId;
  String bagNo;
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
