import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/view/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Register extends GetxController {
  Future register(String username, String password) async {
    var response = await http.post(
      Uri.parse("$baseurl/user/"),
      headers: {'Accept': 'application/json'},
      body: <String, String>{
        "username": username,
        "password": password,
      },
    );

    print("response is${response.body}");
    print("resopnse is ${response.statusCode}");

    var response1 = jsonDecode(response.body);
    // ignore: prefer_typing_uninitialized_variables

    if (response.statusCode == 200) {
      Get.snackbar(
        "Message",
        "Registration completed successfully",
        // response1,
        backgroundColor: AppColor.backgroundcolor,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
      Get.to(const LoginPage());
    } else {
      // Get.defaultDialog(
      //     title: "Registeration Faild",
      //     titleStyle: const TextStyle(
      //         color: AppColor.title,
      //         letterSpacing: 1,
      //         fontSize: 18,
      //         fontWeight: FontWeight.bold,
      //         fontFamily: " Poppins-Regular.ttf"),
      //     middleText: //"$response1"
      //         "Registeration Faild",
      //     middleTextStyle: const TextStyle(
      //       color: AppColor.orange,
      //       fontFamily: " Poppins-Regular.ttf",
      //       fontSize: 15,
      //     ),
      //     buttonColor: AppColor.orange,
      //     confirmTextColor: Colors.white,
      //     onConfirm: () {
      //       Get.back();
      //     });
      Get.snackbar(
        "Message",
        "Registration Faild ",
        // response1,
        backgroundColor: AppColor.orange,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
