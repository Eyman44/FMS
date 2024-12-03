import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/fonts.dart';
import 'package:flutter_application_1/controller/get_user_for_group_controller.dart';
import 'package:flutter_application_1/view/invite_page.dart';
import 'package:get/get.dart';

class MembersPage extends StatelessWidget {
  final int groupId;

  const MembersPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final GroupUsersController controller =
        Get.put(GroupUsersController(groupId: groupId));

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InvitePage(
                      id: groupId,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.groupData == null) {
          return const Center(child: Text("No members found"));
        }
        final groupData = controller.groupData!;
        if (!groupData.groupOwner && !groupData.isAdmin) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: AppColor.purple,
                ),
                SizedBox(height: 16),
                Text(
                  "You don't have permission to view the members.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: groupData.users.length,
            itemBuilder: (context, index) {
              final user = groupData.users[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColor.purple,
                    child: Icon(
                      Icons.person,
                      color: AppColor.backgroundcolor,
                      size: 40,
                    ),
                  ),
                  title: Text(
                    "${user.firstName} ${user.lastName}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      user.permissions.isEmpty
                          ? IconButton(
                              onPressed: () async {
                                await controller.unBanUser(userId: user.id);
                              },
                              icon: const Icon(
                                Icons.report_off_sharp,
                                color: Colors.green,
                                size: 30,
                              ),
                              tooltip: "Unban",
                            )
                          : IconButton(
                              onPressed: () async {
                                await controller.banUser(userId: user.id);
                              },
                              icon: const Icon(
                                Icons.block,
                                color: Colors.red,
                                size: 30,
                              ),
                              tooltip: "Ban",
                            ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: user.permissions.isEmpty
                            ? () {
                                // إظهار Snackbar عند محاولة تقييد مستخدم محظور
                                Get.snackbar(
                                  "Action not allowed",
                                  "This user is banned and cannot be restricted.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                  duration: const Duration(seconds: 3),
                                  margin: const EdgeInsets.all(
                                      10), // مسافة من الحواف
                                  borderRadius: 8, // زوايا مستديرة
                                );
                              }
                            : () async {
                                // تنفيذ إجراءات التقييد أو إلغاء التقييد
                                if (user.permissions.length == 1 &&
                                    user.permissions.first.permission == 2) {
                                  await controller.unRestrictUser(
                                      userId: user.id);
                                } else {
                                  await controller.restrictUser(
                                      userId: user.id);
                                }
                              },
                        icon: user.permissions.isEmpty
                            ? const Icon(
                                Icons.lock,
                                color: Colors.grey, // زر بلون رمادي
                                size: 30,
                              )
                            : Icon(
                                user.permissions.length == 1 &&
                                        user.permissions.first.permission == 2
                                    ? Icons.lock_open
                                    : Icons.lock,
                                color: user.permissions.length == 1 &&
                                        user.permissions.first.permission == 2
                                    ? Colors.green
                                    : AppColor.orange,
                                size: 30,
                              ),
                        tooltip: user.permissions.isEmpty
                            ? "Action not allowed because the user is banned alraedy"
                            : user.permissions.length == 1 &&
                                    user.permissions.first.permission == 2
                                ? "Unrestrict"
                                : "Restrict",
                      ),
                      IconButton(
                        onPressed: () async {
                          await controller.removeUser(userId: user.id);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        ),
                        tooltip: "Remove",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
