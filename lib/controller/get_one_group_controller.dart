import 'dart:convert';
import 'dart:developer';
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
      update(); // تحديث الواجهة
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchGroupDetails(); // استدعاء جلب تفاصيل المجموعة
  }
}
