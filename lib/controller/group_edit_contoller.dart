import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import 'get_all_group_controller.dart';


class GroupEditController extends GetxController {
  final int groupId;

  GroupEditController({required this.groupId});

  Future<bool> updateGroup(String name, bool isPublic, File? image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("auth");

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse("$baseurl/group/$groupId"),
      );

      request.headers.addAll({
        'Authorization': token,
      });

      request.fields['name'] = name;
      request.fields['isPublic'] = isPublic.toString();

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.find<GroupController>().fetchGroups();
        Get.find<GroupController>().fetchOwnGroups();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error updating group: $e");
      return false;
    }
  }
}
