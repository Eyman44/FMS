import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/custom_app_bar.dart.dart';
import 'package:flutter_application_1/constant/fonts.dart';
import 'package:flutter_application_1/controller/get_one_group_controller.dart';
import 'package:flutter_application_1/view/member_page.dart';
import 'package:get/get.dart';

class GroupDetailesPage extends StatefulWidget {
  final int id;

  const GroupDetailesPage({super.key, required this.id});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupDetailesPage> {
  late final GroupDetailsController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(GroupDetailsController(id: widget.id));
    controller.fetchGroupDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: const CustomAppBar(
        title: "Group Details",
      ),
      body: Obx(() {
        // حالة التحميل
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // إذا لم يتم العثور على تفاصيل المجموعة
        if (controller.groupDetails == null) {
          return const Center(
            child: Text(
              "No group details found.",
              style: TextStyle(fontSize: 18, color: AppColor.title),
            ),
          );
        }

        final groupData = controller.groupDetails!.data;

        return Column(
          children: [
            // صورة المجموعة
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                groupData.image,
                fit: BoxFit.cover,
              ),
            ),
            // اسم المجموعة
            GestureDetector(
              onTap: () {
                if (groupData.isPublic) {
                  Get.snackbar(
                    "Access Denied",
                    "You cannot view members of a public group.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColor.orange,
                    colorText: Colors.white,
                  );
                } else {
                  Get.to(() => MembersPage(
                        groupId: groupData.id,
                      ));
                }
              },
              child: Container(
                color: AppColor.title,
                width: double.infinity,
                height: 40,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        groupData.name,
                        style: const TextStyle(
                          color: AppColor.backgroundcolor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.font,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        groupData.isPublic
                            ? Icons.public
                            : Icons.privacy_tip_rounded,
                        color: groupData.isPublic ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: groupData.groupFiles.isEmpty
                    ? const Center(
                        child: Text(
                          "No files available.",
                          style: TextStyle(fontSize: 18, color: AppColor.title),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: groupData.groupFiles.length,
                        itemBuilder: (context, index) {
                          final file = groupData.groupFiles[index];
                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.insert_drive_file,
                                    size: 50, color: AppColor.title),
                                Text(file.toString(),
                                    textAlign: TextAlign.center,
                                    style:
                                        const TextStyle(color: AppColor.title)),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
