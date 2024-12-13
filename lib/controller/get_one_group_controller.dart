import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/get_one_group.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupDetailsController extends GetxController {
  var isLoading = true.obs;
  GroupResponse? groupDetails;
  late int id;

  GroupDetailsController({required this.id});

  Future<void> fetchGroupDetails() async {
    try {
      isLoading(true);

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/group/$id");

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
          groupDetails = GroupResponse.fromJson(data['data']);
          print('detailes of this groupppppppp');
          print(data['data']);
        } else {
          print('Failed to fetch group details: ${data['message']}');
        }
      } else {
        throw Exception(
            'Failed to load group details. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<void> uploadFile({
    required int groupId,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/file/");

      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = token
        ..fields['name'] = fileName
        ..fields['groupId'] = groupId.toString()
        ..files.add(http.MultipartFile.fromBytes('file', fileBytes,
            filename: fileName));

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "File uploaded successfully.");
        print(
            "Successsssssssssssssssssssssssssssssss File uploaded successfully.");
        fetchGroupDetails();
      } else {
        Get.snackbar("Error", "Failed to upload file.");
        print("Faileddddddddddddddddddddddddddddddddddd File uploaded .");
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "An error occurred while uploading the file.");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroupDetails();
  }
}
