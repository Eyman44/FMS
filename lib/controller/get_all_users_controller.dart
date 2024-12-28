import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/get_all_user_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  var users = <UserDataa>[].obs;
  var isLoading = true.obs; // مؤشر التحميل
  var isSearching = false.obs; // مؤشر البحث
  var filteredUsers = <UserDataa>[].obs;

  // جلب بيانات المستخدمين
  Future<void> fetchUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/user/all");

      isLoading(true);
      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log(response.body);

        if (data['status'] == "Success") {
          UserDataResponse userDataResponse = UserDataResponse.fromJson(data);
          users.value = userDataResponse.users;
          
          print(response.body);
          print(response.statusCode);
        } else {
          print('Failed to fetch users: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load users. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> blockUser(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/user/block/$userId");

      isLoading(true);
      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log(response.body);
        print(response.body);
        print(response.statusCode);
        if (data['status'] == "Success") {
          var index = users.indexWhere((user) => user.id == userId);
          if (index != -1) {
            users[index].isBlocked = true;
            users.refresh();
          }
          Get.snackbar("Success", "User blocked successfully");
        } else {
          print('Failed to block user: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to block user. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Failed to block user");
    } finally {
      isLoading(false);
    }
  }

  Future<void> unBlockUser(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/user/unBlock/$userId");

      isLoading(true);
      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log(response.body);
        print(response.body);
        print(response.statusCode);
        if (data['status'] == "Success") {
          var index = users.indexWhere((user) => user.id == userId);
          if (index != -1) {
            users[index].isBlocked = false;

            users.refresh();
          }
          Get.snackbar("Success", "User UnBlocked successfully");
        } else {
          print('Failed to block user: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to block user. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Failed to Unblock user");
    } finally {
      isLoading(false);
    }
  }
 void searchUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value = users
          .where((user) =>
              '${user.firstName} ${user.lastName}'
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers().then((_) {
      filteredUsers.value = users; // تحديث القائمة المفلترة عند الجلب
    });
  }
}