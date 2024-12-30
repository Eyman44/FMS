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

  Future<void> checkIn({
    required int groupId,
    required List<int> fileIds,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/file/checkIn");

      final response = await http.post(
        url,
        headers: {
          "Authorization": token,
        },
        body: json.encode({
          "groupId": groupId.toString(),
          "fileIds": fileIds.map((e) => e.toString()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "Success") {
          Get.snackbar("Success", data['data']);
          print("Files downloaded successfully: ${data['data']}");
        } else {
          Get.snackbar("Error", "Failedd to download file: ${data['data']}");
          print("Failed to download file: ${data['data']}");
          print("Failed to download file: ${data['status']}");
        }
      } else {
        throw Exception(
            'Failed to download file. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "An error occurred while downloading the file.");
    }
  }

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

  Future<void> checkOut({
    required int fileId,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/file/checkOut");

      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = token
        ..fields['fileId'] = fileId.toString()
        ..fields['name'] = fileName
        ..files.add(http.MultipartFile.fromBytes('file', fileBytes,
            filename: fileName));

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "File Checkedout successfully.");
        print(
            "Successsssssssssssssssssssssssssssssss File Checkedout successfully.");
        fetchGroupDetails();
      } else {
        Get.snackbar("Error", "Failed to Upload the File.");
        print(response.statusCode);
        print(response);
        print("Faileddddddddddddddddddddddddddddddddddd File Checkout .");
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "An error occurred while uploading the file.");
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

  Future<void> deleteFile({
    required int groupId,
    required int fileId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');

      if (token == null) {
        throw Exception('Token is null');
      }

      Uri url = Uri.parse("$baseurl/file/delete");

      final response = await http.post(
        url,
        headers: {
          "Authorization": token,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "groupId": groupId.toString(),
          "fileId": fileId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "Success") {
          Get.snackbar("Success", "File deleted successfully.");
          print("File deleted successfully.");
          fetchGroupDetails(); // Refresh group details
        } else {
          Get.snackbar("Error", "Failed to delete file: ${data['message']}");
          print("Failed to delete file: ${data['message']}");
        }
      } else {
        throw Exception(
            'Failed to delete file. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "An error occurred while deleting the file.");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroupDetails();
  }
}
