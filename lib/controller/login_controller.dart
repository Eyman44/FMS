import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/view/files_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  Future login(String email, String password) async {
    var response = await http.post(
      Uri.parse("$baseurl/user/login"),
      headers: {
        'Accept': 'application/json',
      },
      body: <String, String>{
        "email": email,
        "password": password,
      },
    );

    print("response is${response.body}");
    print("resopnse is ${response.statusCode}");

    var response1 = jsonDecode(response.body);
    late var token;
    if (response.statusCode == 200) {
      token = response1["token"];

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth', token);
      print("Your Token IS $token");

      Get.snackbar(
        "Message",
        "Login done successfully",
        backgroundColor: AppColor.backgroundcolor,
        colorText: AppColor.title,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

      Get.off(() => const GroupPage());
    } else {
      Get.snackbar(
        "Message",
        response1['message'],
      
        backgroundColor: AppColor.orange,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
