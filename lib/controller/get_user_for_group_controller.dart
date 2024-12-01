import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/get_users_for_group.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupUsersController extends GetxController {
  var isLoading = true.obs;
  GroupUserData? groupData;
  late int groupId;

  GroupUsersController({required this.groupId});

  Future<void> fetchGroupUsers() async {
    try {
      isLoading(true);
      // جلب التوكن من SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      // إنشاء رابط الـ API
      Uri url = Uri.parse("$baseurl/group/users/$groupId");

      // طلب HTTP لجلب البيانات
      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      // معالجة الاستجابة
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log(response.body);
        print(response.body);
        if (data['status'] == "Success") {
          // تحويل البيانات إلى النموذج
          groupData = GroupUserData.fromJson(data['data']);
          print(groupData);
        } else {
          print('Failed to fetch group users: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load group users. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
      update(); // تحديث الواجهة
    }
  }

  Future<void> banUser({required int userId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.post(
        Uri.parse('$baseurl/group/block'),
        headers: {
          "Authorization": token,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "userId": userId.toString(),
          "groupId": groupId.toString(),
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == "Success") {
          Get.snackbar(
            "Success",
            "User has been banned successfully.",
            backgroundColor: AppColor.backgroundcolor,
            colorText: AppColor.title,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
          update();
          fetchGroupUsers();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to ban user. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: AppColor.orange,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> unBanUser({required int userId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.post(
        Uri.parse('$baseurl/group/unBlock'),
        headers: {
          "Authorization": token,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "userId": userId.toString(),
          "groupId": groupId.toString(),
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == "Success") {
          Get.snackbar(
            "Success",
            "User has been unbanned successfully.",
            backgroundColor: AppColor.backgroundcolor,
            colorText: AppColor.title,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
          update();
          fetchGroupUsers();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to unban user. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: AppColor.orange,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> removeUser({required int userId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.post(
        Uri.parse('$baseurl/user/remove'),
        headers: {
          "Authorization": token,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "userId": userId.toString(),
          "groupId": groupId.toString(),
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == "Success") {
          Get.snackbar(
            "Success",
            "User has been unbanned successfully.",
            backgroundColor: AppColor.backgroundcolor,
            colorText: AppColor.title,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
          update();
          fetchGroupUsers();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to unban user. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: AppColor.orange,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroupUsers(); // استدعاء جلب المستخدمين
  }
}
