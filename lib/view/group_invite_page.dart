import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';

class GroupInviteScreen extends StatelessWidget {
  final List<Map<String, String>> invites = [
    {"name": "John Doe", "group": "Flutter Developers"},
    {"name": "Jane Smith", "group": "Mobile App Enthusiasts"},
    {"name": "Sara Lee", "group": "Tech Innovators"},
  ];

  GroupInviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Group Invitations",
          style: TextStyle(color: AppColor.title),
        ),
        backgroundColor: AppColor.purple,
      ),
      body: ListView.builder(
        itemCount: invites.length,
        itemBuilder: (context, index) {
          var invite = invites[index];
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة للمستخدم (افتراضية)
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColor.purple,
                      child: Text(
                        invite["name"]!.substring(0, 1),
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // اسم الشخص
                          Text(
                            invite["name"]!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          // اسم المجموعة
                          Text(
                            "Group: ${invite["group"]}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          // أزرار القبول والرفض
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // زر رفض
                              TextButton(
                                onPressed: () {
                                  // من هنا يمكن تنفيذ وظيفة الرفض
                                  print(
                                      "Invitation declined by ${invite['name']}");
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
                                  // من هنا يمكن تنفيذ وظيفة القبول
                                  print(
                                      "Invitation accepted by ${invite['name']}");
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
