import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/controller/get_all_group_controller.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/get_all_groups_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupsController extends GetxController {
  var groups = <AllGroupData>[].obs;
  var isLoading = true.obs;
  var filteredGroups = <AllGroupData>[].obs;
  Future<void> fetchGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/group/allGroups");

      isLoading(true);
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
          AllGroupsResponse groupResponse = AllGroupsResponse.fromJson(data);
          groups.value = groupResponse.groups;
        } else {
          print('Failed to fetch groups: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load groups. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteGroup(int groupId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/group/delete/$groupId");

      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == "Success") {
          groups.removeWhere((group) => group.id == groupId);
          Get.snackbar('Success', 'Group deleted successfully');
          Get.find<GroupController>().fetchGroups();
          Get.find<GroupController>().fetchOwnGroups();
        } else {
          Get.snackbar('Error', data['message']);
        }
      } else {
        throw Exception(
            'Failed to delete group. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'Failed to delete group');
    }
  }

  void searchGroups(String query) {
    if (query.isEmpty) {
      filteredGroups.value = groups;
    } else {
      filteredGroups.value = groups
          .where(
              (group) => group.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroups().then((_) {
      filteredGroups.value = groups; // تحديث القائمة المفلترة عند الجلب
    });
  }
}
