import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/upload_requests_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UploadRequestsController extends GetxController {
  var isLoading = true.obs; 
  UploadRequestsResponse? uploadRequestsResponse;

  Future<void> fetchUploadRequests() async {
    try {
      isLoading(true);

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/file/UploadRequists");

      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log(response.body);

        print("Upload requests fetched successfully $data");
        if (data['status'] == "Success") {
          uploadRequestsResponse = UploadRequestsResponse.fromJson(data);
          print('Upload requests fetched successfully');
        } else {
          print('Failed to fetch upload requests: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load upload requests. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<void> acceptRequest(int fileId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/file/accept/$fileId");

      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == "Success") {
          Get.snackbar("Success", "File accepted successfully.");
          fetchUploadRequests();
        } else {
          print('Failed to accept file: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to accept file. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "An error occurred while accepting the file.");
    }
  }

  Future<void> declineRequest(int fileId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/file/decline/$fileId");

      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == "Success") {
          Get.snackbar("Success", "File declined successfully.");
          fetchUploadRequests();
        } else {
          print('Failed to decline file: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to decline file. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "An error occurred while declining the file.");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUploadRequests();
  }
}
