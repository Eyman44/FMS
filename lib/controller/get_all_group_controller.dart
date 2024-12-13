import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/get_my_group_models.dart';
import 'package:flutter_application_1/models/get_my_own_group_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupController extends GetxController {

  var myGroups = <MyGroup>[].obs;
  var publicGroups = <PublicGroup>[].obs;
  var myOwnnGroups = <MyOwnGroup>[].obs;
  var myOwnGroups = <OwnGroup>[].obs;


  var filteredGroups = <Map<String, String>>[].obs;

 
  var isLoading = true.obs;
  var isSearching = false.obs;

 
  Future<void> fetchGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/user/myGroups");

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
          GroupData groupData = GroupData.fromJson(data['data']);
          myGroups.value = groupData.myGroups;
          publicGroups.value = groupData.publicGroups;
          myOwnnGroups.value = groupData.myOwnGroups;
          _resetFilteredGroups();
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


  Future<void> fetchOwnGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/user/myOwnGroups");

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
        MyOwnGroupData groupData = MyOwnGroupData.fromJson(data);
        myOwnGroups.value = groupData.groups;
        _resetFilteredGroups();
      } else {
        throw Exception(
            'Failed to load joined groups. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }


  void searchGroups(String query) {
    if (query.isEmpty) {
      isSearching(false);
      _resetFilteredGroups();
    } else {
      isSearching(true);
      String lowerQuery = query.toLowerCase();
      filteredGroups.value = [
        ...myGroups
            .where(
                (group) => group.group.name.toLowerCase().contains(lowerQuery))
            .map((group) => {
                  'id': group.groupId.toString(),
                  'name': group.group.name,
                  'image': group.group.image,
                }),
        ...publicGroups
            .where((group) => group.name.toLowerCase().contains(lowerQuery))
            .map((group) => {
                  'id': group.id.toString(),
                  'name': group.name,
                  'image': group.image,
                }),
        ...myOwnGroups
            .where((group) => group.name.toLowerCase().contains(lowerQuery))
            .map((group) => {
                  'id': group.id.toString(),
                  'name': group.name,
                  'image': group.image,
                }),
      ];
    }
  }


  void _resetFilteredGroups() {
    filteredGroups.value = [
      ...myGroups.map((group) => {
            'id': group.groupId.toString(),
            'name': group.group.name,
            'image': group.group.image,
          }),
      ...publicGroups.map((group) => {
            'id': group.id.toString(),
            'name': group.name,
            'image': group.image,
          }),
      ...myOwnGroups.map((group) => {
            'id': group.id.toString(),
            'name': group.name,
            'image': group.image,
          }),
    ];
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroups();
    fetchOwnGroups();
  }
}
