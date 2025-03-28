import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:laundry_service/helpers/constatnts/sharedprefs.dart';
import 'package:laundry_service/helpers/utils.dart';
import 'package:laundry_service/modules/authentication/pages/login_page.dart';
import 'package:laundry_service/modules/authentication/pages/user_state.dart';
import 'package:laundry_service/modules/campus_employee/pages/campus_employee_dashboard.dart';
import 'package:laundry_service/modules/driver/pages/driver_dashboard.dart';
import 'package:laundry_service/modules/drying/pages/drying_dashboard.dart';
import 'package:laundry_service/modules/segregation/page/seg_dashboard.dart';
import 'package:laundry_service/modules/washing/pages/washing_dashboard.dart';
import 'package:laundry_service/network/url_constants.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/network_api_services.dart';
import '../../driver/pages/vehicle_inspection/vehicle_inspection_page1.dart';
import 'package:http/http.dart' as http;

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
        print('last login ${response['data']['last_login']}');
        await saveSharedPref(
            userId: response['data']['uid'],
            userType: response['data']['employee_type'],
            college: '',
            name: response['data']['name'],
            mobile: response['data']['mobile'].toString(),
            lastLogin: response['data']['last_login'] ?? '',
            profileImage: response['data']['profile_image'] == null
                ? ''
                : 'http://15.206.178.169:8000${response['data']['profile_image']}');
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

  Future<void> saveDriverData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(SharedPreferenceKey.driverData, true);
  }

  Future<bool?> getDriverData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? driverEnteredData =
        sharedPreferences.getBool(SharedPreferenceKey.driverData);
    return driverEnteredData;
  }

  Future<bool> driverNextPageOrNot() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? driverLastLogin =
        sharedPreferences.getString(SharedPreferenceKey.lastLogin);
    print('driver last login $driverLastLogin');
    if (driverLastLogin != null && driverLastLogin.isNotEmpty) {
      bool isToday = Utils.checkIfToday(driverLastLogin);
      print('is today $isToday');
      return !isToday;
    } else {
      return true;
    }
  }

  Future<void> saveSharedPref({
    required String userId,
    required String userType,
    required String college,
    required String name,
    required String mobile,
    required String lastLogin,
    required String profileImage,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(SharedPreferenceKey.UserId, userId);
    await sharedPreferences.setString(SharedPreferenceKey.userType, userType);
    await sharedPreferences.setString(
      SharedPreferenceKey.name,
      name,
    );
    await sharedPreferences.setString(
      SharedPreferenceKey.mobile,
      mobile,
    );
    await sharedPreferences.setString(
      SharedPreferenceKey.lastLogin,
      lastLogin,
    );
    await sharedPreferences.setString(
      SharedPreferenceKey.profileImage,
      profileImage,
    );
  }

  Future<void> checkUserPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? userType =
        sharedPreferences.getString(SharedPreferenceKey.userType);
    if (userType == null) {
      Get.offAll(() => LoginPage());
    } else if (userType == 'Campus_Employee') {
      Get.offAll(() => const CampusEmployeeDashboard());
    } else if (userType == 'Driver') {
      bool driverNextPage = await driverNextPageOrNot();
      print('driver next page $driverNextPage');
      if (driverNextPage) {
        Get.offAll(() => const VehicleInspectionPage1());
      } else {
        Get.offAll(() => const DriverDashboard());
      }
    } else if (userType == 'Washing') {
      Get.offAll(() => const WashingDashboard());
    } else if (userType == 'Drying') {
      Get.offAll(() => const DryingDashboard());
    } else if (userType == 'Segregation') {
      Get.offAll(() => const SegDashboard());
    }
  }

  Future<void> logout() async {
    await updateLogout();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(SharedPreferenceKey.UserId);
    await sharedPreferences.remove(SharedPreferenceKey.userType);
    await sharedPreferences.remove(SharedPreferenceKey.collegeName);
    await sharedPreferences.remove(SharedPreferenceKey.name);
    await sharedPreferences.remove(SharedPreferenceKey.mobile);
    await sharedPreferences.remove(SharedPreferenceKey.driverData);
    await sharedPreferences.remove(SharedPreferenceKey.lastLogin);
    await sharedPreferences.remove(SharedPreferenceKey.profileImage);

    Get.offAll(() => const UserState());
  }

  Future<void> updateLogout() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? employeeId =
          sharedPreferences.getString(SharedPreferenceKey.UserId);
      if (employeeId != null) {
        var data = {
          'last_login': DateTime.now().toString(),
        };
        var response = await _apiServices.patchApi(
            data, '${UrlConstants.employeeUpdate}$employeeId/');
        print('resonse $response');
      }
    } catch (e) {
      print('error $e');
    }
  }

  Future<void> updateProfile({required File profileImage}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? employeeId =
          sharedPreferences.getString(SharedPreferenceKey.UserId);
      if (employeeId != null) {
        String url = '${UrlConstants.employeeUpdate}$employeeId/';
        var request = http.MultipartRequest('PATCH', Uri.parse(url));

        var imageFile = await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
          filename: basename(profileImage.path),
        );

        request.files.add(imageFile);

        var response = await request.send();
        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var parsedResponse = json.decode(responseBody);
          await sharedPreferences.setString(SharedPreferenceKey.profileImage,
              'http://15.206.178.169:8000${parsedResponse['data']['profile_image']}');
        }
      }
    } catch (e) {
      print('unable to update prfile image $e');
    }
  }

  Future<String?> getProfileImage() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? profileImage =
          sharedPreferences.getString(SharedPreferenceKey.profileImage);
      if (profileImage != null && profileImage.isNotEmpty) {
        return profileImage;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
