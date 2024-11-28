import 'dart:convert';
import 'package:flutter_application_1/constant/color.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class GroupInviteController extends GetxController {
  var invites = [].obs;
  var isLoading = true.obs;

  Future fetchGroupInvites() async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      late var token = prefs.getString("auth");

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      var response = await http.get(
        Uri.parse("$baseurl/user/groupInvitations"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      print("token: $token");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'Success') {
          invites.value = jsonResponse['data'];
        }
        else {
          invites.value = [];
        }
      }
      else {
        Get.snackbar(
          "Error",
          "Failed to fetch invites",
          backgroundColor: AppColor.orange,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: AppColor.orange,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
