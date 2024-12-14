import 'dart:io';
import 'package:flutter_application_1/main.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupCreateController extends GetxController {
  Future<bool> createGroup(String name, bool isPublic, File? image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("auth");

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseurl/group/"),
      );

      request.headers.addAll({
        'Authorization':  token,
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error creating group: $e");
      return false;
    }
  }
}
