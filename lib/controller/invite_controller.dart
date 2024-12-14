import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/models/get_users_to_invite.dart';
import 'package:flutter_application_1/main.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InviteController extends GetxController {
  var isLoading = true.obs;
  var allUsers = <UserToInvite>[].obs;
  var filteredUsers = <UserToInvite>[].obs;
  var sentInvitations =
      <int>[].obs; 
  late int groupId;

  InviteController({required this.groupId});

  Future<void> fetchUsersToInvite() async {
    try {
      isLoading(true);

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/user/usersToInvite/$groupId");

      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log(response.body);

        if (data['status'] == "Success") {
          allUsers.value = (data['data']['data'] as List)
              .map((user) => UserToInvite.fromJson(user))
              .toList();
          filteredUsers.value = allUsers;
        } else {
          print('Failed to fetch users to invite: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load users to invite. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendInvite(
      {required int userId, required String message}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/group/invite");

      final response = await http.post(
        url,
        headers: {
          "Authorization": token,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "groupId": groupId.toString(),
          "userId": userId.toString(),
          "message": message,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == "Success") {
          sentInvitations.add(userId);
          fetchUsersToInvite();
          update();
          Get.snackbar(
            "Message",
            "Send inivte done successfully",
            backgroundColor: AppColor.backgroundcolor,
            colorText: AppColor.title,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
        } else {
          Get.snackbar(
            "Message",
            " Failed to send invitation: ${data['message']}",
            backgroundColor: AppColor.orange,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          "Message",
          'Failed to send invitation. Status Code: ${response.statusCode}',
          backgroundColor: AppColor.orange,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Message",
        'Error: $e',
        backgroundColor: AppColor.orange,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value = allUsers
          .where((user) =>
              user.firstName.toLowerCase().contains(query.toLowerCase()) ||
              user.lastName.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsersToInvite();
  }
}
