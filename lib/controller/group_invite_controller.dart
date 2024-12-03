import 'dart:convert';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/controller/get_all_group_controller.dart';
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
          'Authorization': token,
        },
      );

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'Success') {
          invites.value = jsonResponse['data'];
        } else {
          invites.value = [];
        }
      } else {
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

  Future<void> acceptInvite(var inviteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("auth");

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      var response = await http.get(
        Uri.parse("$baseurl/user/accept/$inviteId"),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'Success') {
          invites.removeWhere((invite) => invite['id'] == inviteId);
          Get.find<GroupController>().fetchGroups();
          Get.snackbar(
            "Success",
            jsonResponse['data'],
            backgroundColor: AppColor.green,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          throw Exception("Failed to accept the invitation.");
        }
      } else {
        throw Exception("Error occurred while accepting the invitation.");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: AppColor.orange,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> rejectInvite(var inviteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("auth");

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      var response = await http.get(
        Uri.parse("$baseurl/user/decline/$inviteId"),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'Success') {
          // إزالة الدعوة المرفوضة من القائمة
          invites.removeWhere((invite) => invite['id'] == inviteId);
          Get.snackbar(
            "Success",
            jsonResponse['data'],
            backgroundColor: AppColor.green,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          throw Exception("Failed to reject the invitation.");
        }
      } else {
        throw Exception("Error occurred while rejecting the invitation.");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: AppColor.orange,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
