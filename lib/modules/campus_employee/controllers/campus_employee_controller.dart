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
  var teacherOrders = <TeacherOrder>[
    TeacherOrder(description: 'Shirt', quantity: 0),
    TeacherOrder(description: 'Pant', quantity: 0),
    TeacherOrder(description: 'Bedsheet', quantity: 0),
    TeacherOrder(description: 'Towel', quantity: 0),
  ].obs;

  void incrementQuantity(int index) {
    teacherOrders[index].quantity++;
    teacherOrders.refresh();
  }

  void decrementQuantity(int index) {
    if (teacherOrders[index].quantity > 0) {
      teacherOrders[index].quantity--;
      teacherOrders.refresh();
    }
  }

  // Add a new order to the list
  void addOrder(String tagNo, int count) {
    orders.add(Order(tagNo: tagNo, count: count));
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
  int count;

  Order({required this.tagNo, required this.count});
}

class TeacherOrder {
  String description;
  int quantity;

  TeacherOrder({
    required this.description,
    required this.quantity,
  });
}
