import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/constatnts/sharedprefs.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/pages/login_page.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_dashboard.dart';
import 'package:laundry_service/modules/driver/pages/driver_dashboard.dart';
import 'package:laundry_service/modules/driver/pages/vehicle_inspection/vehicle_inspection_page1.dart';
import 'package:laundry_service/modules/drying/pages/drying_dashboard.dart';
import 'package:laundry_service/modules/segregation/page/seg_dashboard.dart';
import 'package:laundry_service/modules/washing/pages/select_washing_machine_page.dart';
import 'package:laundry_service/modules/washing/pages/washing_dashboard.dart';
import 'package:laundry_service/network/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/network_api_services.dart';
import '../../campus_employee/pages/profile/campus_employee_selfie_image.dart';

class LoginController extends GetxController {
  final _apiServices = NetworkApiServices();
  RxBool loginLoading = false.obs;
  Future<void> login(
      {required String id,
      required String password,
      required BuildContext context}) async {
    try {
      loginLoading.value = true;
      var data = {"email": id, "password": password};
      var response = await _apiServices.postApi(data, UrlConstants.login);
      print('response $response');
      if (response['data']['uid'] != null) {
        await saveSharedPref(
            userId: response['data']['uid'],
            userType: response['data']['employee_type'],
            college: '',
            name: response['data']['name']);
        Get.offAll(() => const UserState());
      } else {
        Utils.showScaffoldMessageI(
            context: context, title: "User & password don't match");
      }
      loginLoading.value = false;
    } catch (e) {
      Utils.showScaffoldMessageI(
          context: context, title: "User & password don't match");
      loginLoading.value = false;
    }
  }

  Future<void> saveSharedPref({
    required String userId,
    required String userType,
    required String college,
    required String name,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferenceKey.UserId, userId);
    await sharedPreferences.setString(SharedPreferenceKey.userType, userType);
    await sharedPreferences.setString(SharedPreferenceKey.name, name);
  }

  Future<void> checkUserPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);

    String? userType =
        sharedPreferences.getString(SharedPreferenceKey.userType);
    if (userType == null) {
      Get.offAll(() => LoginPage());
    } else if (userType == 'Campus_Employee') {
      Get.offAll(() => const CampusEmployeeDashboard());
    } else if (userType == 'Driver') {
      Get.offAll(() => const DriverDashboard());
    } else if (userType == 'Washing') {
      Get.offAll(() => const WashingDashboard());
    } else if (userType == 'Drying') {
      Get.offAll(() => const DryingDashboard());
    } else if (userType == 'Segregation') {
      Get.offAll(() => const SegDashboard());
    }
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(SharedPreferenceKey.UserId);
    await sharedPreferences.remove(SharedPreferenceKey.userType);
    await sharedPreferences.remove(SharedPreferenceKey.collegeName);
    await sharedPreferences.remove(SharedPreferenceKey.name);
    Get.offAll(() => const UserState());
  }
}
