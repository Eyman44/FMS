import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/fonts.dart';
import 'package:flutter_application_1/constant/image.dart';

class AddFileDialog extends StatelessWidget {
  const AddFileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    // تحديد عرض الشاشة
    double screenWidth = MediaQuery.of(context).size.width;

    // تحديد حجم الصورة بناءً على حجم الشاشة
    double imageSize = screenWidth * 0.4; // الصورة تأخذ 40% من عرض الشاشة

    return AlertDialog(
      title: const Text(
        "Add New File",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColor.title,
          fontFamily: AppFonts.font2,
        ),
      ),
      content: SingleChildScrollView(
        // إضافة SingleChildScrollView لتجنب overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // صورة تمثل ملف PDF
            Center(
              child: Image.asset(
                AppImageAsset.pdf,
                height: screenWidth * 0.12,
                width: screenWidth * 0.5,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 15),

            // حقل اسم الملف
            SizedBox(
              width: screenWidth * 0.6, // 80% من عرض الشاشة
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "File Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // حقل ملاحظات
            SizedBox(
              width: screenWidth * 0.6, // 80% من عرض الشاشة
              height: screenWidth * 0.1,
              child: TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: "Notes",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3, // لتحديد عدد الأسطر
              ),
            ),
            const SizedBox(height: 5),
            // زر لرفع الملف (شخصي فقط بدون ربط)
            ElevatedButton.icon(
              onPressed: () {
                // هنا يمكن إضافة ما تود فعله عند الضغط على الزر مثل محاكاة رفع الملف
                print("Simulate file upload");
              },
              icon: const Icon(Icons.upload_file),
              label: const Text(
                "Upload PDF File",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.orange,
                  fontSize: 14,
                  fontFamily: AppFonts.font,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // زر تم
        TextButton(
          onPressed: () {
            // إغلاق الـ Dialog عند الضغط على "تم"
            Navigator.of(context).pop();
          },
          child: const Text(
            "Done",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.title,
              fontSize: 14,
              fontFamily: AppFonts.font,
            ),
          ),
        ),
      ],
    );
  }
}
