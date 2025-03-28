import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'base_api_services.dart';
import 'exceptions.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    print('getapi -${url}');
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        try {
          final uri = Uri.parse(url);

          final response = await http.get(uri, headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            // "Authorization":
            //     'Bearer ${LocalPrefs().getStringPref(key: SharedPreferenceKey.UserLoggedIn)}'
          }).timeout(Duration(seconds: 250));

          print('------URL-------');
          print("GETURL ${response.request?.url}");
          print(response.statusCode);
          print('------response-------');
          print("GETResponse  ${response.body}");

          return returnResponse(response);
        } on SocketException {
          throw InternetException();
        } on TimeoutException {
          throw RequestTimeOut();
        } on Exception catch (e) {
          throw Exception(e);
        }
      } catch (error, stackTrace) {
        rethrow;
      }
    } else {}
  }

  @override
  Future<dynamic> getApi2(String url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final uri = Uri.parse(url);

        final response = await http.get(uri, headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          // "Authorization": 'Bearer ${LocalPrefs().getStringPref(key: SharedPreferenceKey.UserLoggedIn)}'
        }).timeout(Duration(seconds: 250));

        print('------URL-------');
        print("GETURL ${response.request?.url}");
        print(response.statusCode);
        print('------response-------');
        print("GETResponse  ${response.body}");

        // Parse and return the JSON response
        final parsedResponse = jsonDecode(response.body);
        return parsedResponse;
      } on SocketException {
        throw InternetException();
      } on TimeoutException {
        throw RequestTimeOut();
      } on Exception catch (e) {
        throw Exception(e);
      }
    } else {
      throw InternetException();
    }
  }

  @override
  Future<dynamic> postApi(data, String url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final uri = Uri.parse(url);
        try {
          print("PostUrl $uri");
          print("----PostReq-- $data------");
          final response =
              await http.post(uri, body: jsonEncode(data), headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            // "Authorization":
            //     'Bearer ${LocalPrefs().getStringPref(key: SharedPreferenceKey.UserLoggedIn)}'
          }).timeout(Duration(seconds: 250));
          print('------URL-------');
          print("PostURL ${response.request?.url}");
          print(response.statusCode);
          print('------response-------');
          print("PostResponse  ${response.body}");
          return returnResponse(response);
        } on SocketException {
          throw InternetException();
        } on TimeoutException {
          throw RequestTimeOut();
        } on Exception {
          throw Exception();
        }
      } catch (error, stackTrace) {
        print('------ERROR-------');
        print(error);
        print(stackTrace);
        // Logger.log(error, stackTrace: stackTrace);
        throw (error.toString());
      }
    } else {}
  }

  @override
  Future<dynamic> patchApi(data, String url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final uri = Uri.parse(url);
        print("PostUrl $uri");

        var request = http.MultipartRequest('PATCH', uri);

        // Add fields to request
        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // Send request
        final response =
            await request.send().timeout(const Duration(seconds: 250));

        // Convert response to string
        final responseBody = await response.stream.bytesToString();

        print('------URL-------');
        print("PostURL ${response.request?.url}");
        print(response.statusCode);
        print('------response-------');
        print("PostResponse  $responseBody");

        // Handle response
        return returnResponse2(response, responseBody);
      } on SocketException {
        throw InternetException();
      } on TimeoutException {
        throw RequestTimeOut();
      } on Exception catch (e) {
        throw Exception(e.toString());
      }
    } else {
      // Handle no internet connectivity
    }
  }

  dynamic returnResponse2(http.StreamedResponse response,
      [String responseBody = '']) {
    // Handle response based on status code
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

dynamic returnResponse(http.Response response) {
  String? message = json.decode(response.body)['message'].toString();

  switch (response.statusCode) {
    case 200:
      if (json.decode(response.body)['status'] == 500) {
        print('------URL500-------');
        print("${response.request?.url} URL500");

        // Get.to(PhoneLoginPage());
      }
      return json.decode(response.body);
    case 400:
      throw (message ?? 'Something went wrong, please try again.');
    case 401:
      throw Unauthorized();
    case 403:
      throw Forbidden();
    case 404:
      throw NotFound();
    case 408:
      throw RequestTimeOut();
    case 500:
      throw (message ?? 'Something went wrong, please try again.');
    case 502:
      throw BadGateway();
    default:
      throw FetchDataException(
          "Something Went Wrong " + response.statusCode.toString());
  }
}
