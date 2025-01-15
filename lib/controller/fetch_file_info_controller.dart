import 'dart:convert';
import 'package:flutter_application_1/main.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FileInfoController extends GetxController {
  final int fileId;

  FileInfoController({required this.fileId});

  var fileInfo = {}.obs;
  var fileStatistics = [].obs;
  var isLoading = true.obs;

  Future<void> fetchFileDetails() async {
    try {
      isLoading(true);

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception("No authentication token found.");
      }

      Uri url = Uri.parse("$baseurl/file/fileStatistics/$fileId");

      final response = await http.get(
        url,
        headers: {
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == "Success") {
          fileInfo.value = data['data']['fileInfo'];
          fileStatistics.value = data['data']['fileStatistics'];
        } else {
          print('Failed to fetch file details: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load file details. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchFileDetails();
  }
}
