import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/fonts.dart';

class RequestsPage extends StatelessWidget {
  final List<Map<String, String>> requests = [
    {
      "username": "John Doe",
      "group": "Flutter Developers",
      "file": "app_update_v1.pdf",
      "note": "Added new features to the app."
    },
    {
      "username": "Jane Smith",
      "group": "Mobile App Enthusiasts",
      "file": "design_overhaul_v2.pdf",
      "note": "Updated UI design for better user experience."
    },
    {
      "username": "Sara Lee",
      "group": "Tech Innovators",
      "file": "security_patch_v3.pdf",
      "note": "Fixed security vulnerabilities."
    },
  ];

  RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "File Upload Requests",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.purple,
      ),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          var request = requests[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المستخدم
                    Text(
                      "User: ${request["username"]!}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // اسم المجموعة
                    Text(
                      "Group: ${request["group"]!}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // اسم الملف
                    Text(
                      "File: ${request["file"]!}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // ملاحظة التعديلات
                    Text(
                      "Note: ${request["note"]!}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontFamily: AppFonts.font,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // أزرار القبول والرفض
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // زر رفض
                        TextButton(
                          onPressed: () {
                            // تنفيذ وظيفة الرفض
                            print("Request declined by ${request['username']}");
                          },
                          child: const Text(
                            "Reject",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // زر قبول
                        ElevatedButton(
                          onPressed: () {
                            print("Request accepted by ${request['username']}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.iconColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Text(
                            "Accept",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
