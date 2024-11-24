import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/view/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Register extends GetxController {
  Future register(
      String firstName, String lastName, String email, String password) async {
    var response = await http.post(
      Uri.parse("$baseurl/user/"),
      headers: {'Accept': 'application/json'},
      body: <String, String>{
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
      },
    );

    print("response is ${response.body}");
    print("response status code is ${response.statusCode}");

    var response1 = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Get.snackbar(
        "Message",
        "Registration completed successfully",
        backgroundColor: AppColor.backgroundcolor,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      Get.to(const LoginPage());
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
