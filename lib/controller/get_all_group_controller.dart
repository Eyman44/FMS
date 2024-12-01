import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/get_my_group_models.dart';
import 'package:flutter_application_1/models/get_my_own_group_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupController extends GetxController {
  List<MyGroup> myGroups = [];
  List<PublicGroup> publicGroups = [];
  List<MyOwnGroup> myOwnnGroups = [];
  List<OwnGroup> myOwnGroups = [];

  List<Map<String, String>> filteredGroups = <Map<String, String>>[].obs;
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

      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      isLoading(true);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log(response.body);

        if (data['status'] == "Success") {
          GroupData groupData = GroupData.fromJson(data['data']);
          myGroups = groupData.myGroups;
          publicGroups = groupData.publicGroups;
          myOwnnGroups = groupData.myOwnGroups;
          update();
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

      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      isLoading(true);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        log(response.body);
        print(response.body);
        MyOwnGroupData groupData = MyOwnGroupData.fromJson(data);
        myOwnGroups = groupData.groups;
        print(myOwnGroups);
        update();
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
      filteredGroups = [
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
    } else {
      isSearching(true);
      String lowerQuery = query.toLowerCase();
      filteredGroups = [
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
      print("Query: $query");
      print("Filtered Groups: ${filteredGroups.length}");
    }
    update();
  }

  @override
  void onInit() {
    fetchGroups();
    fetchOwnGroups();
    super.onInit();
  }
}
