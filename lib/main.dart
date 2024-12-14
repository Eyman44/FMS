import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/fonts.dart';
import 'package:flutter_application_1/view/login.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

String baseurl = "http://localhost:8080";
SharedPreferences? sharedpref;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppFonts.font,
      ),
      home: const LoginPage(),
    );
  }
}
