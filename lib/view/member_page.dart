import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/fonts.dart';
import 'package:flutter_application_1/view/invite_page.dart';

class MembersPage extends StatelessWidget {
  final List<String> members = ["Alice", "Bob", "Charlie", "Diana"];

  MembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Members",
          style:
              TextStyle(fontFamily: AppFonts.font, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor.purple,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                // الانتقال إلى صفحة البحث
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InvitePage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4, // تباين أكبر للبطاقة
              margin: const EdgeInsets.symmetric(
                  vertical: 12.0), // زيادة المسافة بين البطاقات
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // زاوية دائرية أكبر
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0), // حواف داخلية أكبر
                leading: const CircleAvatar(
                  radius: 40, // زيادة حجم الصورة
                  backgroundColor: AppColor.purple,
                  child: Icon(
                    Icons.person,
                    color: AppColor.backgroundcolor,
                    size: 40, // تكبير الأيقونة داخل الصورة
                  ),
                ),
                title: Text(
                  members[index],
                  style: const TextStyle(
                    fontSize: 22, // تكبير حجم النص
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.font,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // تنفيذ إجراء الحظر
                        print("${members[index]} has been banned.");
                      },
                      icon: const Icon(
                        Icons.block,
                        color: Colors.red,
                        size: 30, // تكبير الأيقونة
                      ),
                      tooltip: "Ban",
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        // تنفيذ إجراء التقييد
                        print("${members[index]} has been restricted.");
                      },
                      icon: const Icon(
                        Icons.lock,
                        color: Colors.orange,
                        size: 30, // تكبير الأيقونة
                      ),
                      tooltip: "Restrict",
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
