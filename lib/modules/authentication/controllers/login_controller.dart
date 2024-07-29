import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/constatnts/sharedprefs.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/pages/login_page.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_dashboard.dart';
import 'package:laundry_service/modules/driver/pages/driver_page.dart';
import 'package:laundry_service/network/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/network_api_services.dart';

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
      if (response['data'].isNotEmpty) {
        await saveSharedPref(
            userId: response['data'][0]['_id'],
            userType: response['data'][0]['userType']);
        Get.offAll(() => const UserState());
      } else {
        Utils.showScaffoldMessageI(
            context: context, title: "User & password don't match");
      }
      loginLoading.value = false;
    } catch (e) {
      loginLoading.value = false;
    }
  }

  Future<void> saveSharedPref(
      {required String userId, required String userType}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferenceKey.UserId, userId);
    await sharedPreferences.setString(SharedPreferenceKey.userType, userType);
  }

  Future<void> checkUserPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? userId = sharedPreferences.getString(SharedPreferenceKey.UserId);

    String? userType =
        sharedPreferences.getString(SharedPreferenceKey.userType);
    if (userType == null) {
      Get.offAll(() => LoginPage());
    } else if (userType == 'Campus Employee') {
      Get.offAll(() => const CampusEmployeeDashboard());
    } else {
      Get.offAll(() => const DriverDashboard());
    }
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(SharedPreferenceKey.UserId);
    await sharedPreferences.remove(SharedPreferenceKey.userType);
    Get.offAll(() => const UserState());
  }
}
