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

  // void incrementQuantity(int index) {
  //   teacherOrders[index].towels++;
  //   teacherOrders.refresh();
  // }
  //
  // void decrementQuantity(int index) {
  //   if (teacherOrders[index].quantity > 0) {
  //     teacherOrders[index].quantity--;
  //     teacherOrders.refresh();
  //   }
  // }

  // Add a new order to the list
  void addOrder(String tagNo, int cloths, int uniforms) {
    orders.add(Order(
        tagNo: tagNo,
        totalCloths: cloths,
        totalUniforms: uniforms,
        remarks: ''));
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
