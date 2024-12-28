import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/customer_app_bar_for_admin.dart';
import 'package:flutter_application_1/controller/admin_get_all_group_controller.dart';
import 'package:flutter_application_1/controller/get_all_users_controller.dart';

import 'package:flutter_application_1/models/get_all_groups_model.dart';
import 'package:flutter_application_1/models/get_all_user_model.dart';
import 'package:flutter_application_1/view/add_group.dart';
import 'package:flutter_application_1/view/files_page.dart';
import 'package:get/get.dart';

class SuperPage extends StatelessWidget {
  SuperPage({super.key});

  final userController = Get.put(UserController());
  final groupController = Get.put(GroupsController());

  var isSearching = false.obs; // حالة البحث

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: const CustomAppBarForAdmin(
        title: "Super Admin Page",
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search groups or Users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              onChanged: (value) {
                groupController.searchGroups(value);
                userController.searchUsers(value);

                // تعيين حالة البحث
                isSearching.value = value.isNotEmpty;
              },
            ),
          ),
          Expanded(child: Obx(() {
            // إذا كان هناك نص في مربع البحث، عرض فقط نتائج البحث
            if (isSearching.value) {
              final combinedResults = [
                ...groupController.filteredGroups.map(
                  (group) => {'type': 'group', 'data': group},
                ),
                ...userController.filteredUsers.map(
                  (user) => {'type': 'user', 'data': user},
                ),
              ];

              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemBuilder: (context, index) {
                  final item = combinedResults[index];
                  if (item['type'] == 'group') {
                    final group = item['data'] as AllGroupData;
                    return _buildGroupItem(
                        group.id.toString(), group.name, group.image ?? "");
                  } else if (item['type'] == 'user') {
                    final user = item['data'] as UserDataa;
                    return _buildUserItem(user);
                  }
                  return const SizedBox.shrink();
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 10,
                  thickness: 0.7,
                  color: Color.fromARGB(255, 197, 195, 195),
                ),
                itemCount: combinedResults.length,
              );
            }
            // إذا لم يكن هناك نص، عرض التابات
            return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColor.backgroundcolor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const TabBar(
                        labelColor: AppColor.title,
                        unselectedLabelColor: Colors.grey,
                        indicator: UnderlineTabIndicator(
                          borderSide:
                              BorderSide(width: 3.0, color: AppColor.purple),
                          insets: EdgeInsets.symmetric(horizontal: 50.0),
                        ),
                        tabs: [
                          Tab(text: 'All groups'),
                          Tab(text: 'Users'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // تب الغروبات
                          Obx(() {
                            if (groupController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return _buildGroupList(groupController.groups);
                          }),
                          // تب المستخدمين
                          Obx(() {
                            if (userController.isLoading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return _buildUserList(userController.users);
                          }),
                        ],
                      ),
                    ),
                  ],
                ));
          }))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddGroupDialog(context);
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// بناء قائمة الغروبات
Widget _buildGroupList(List<AllGroupData> groups) {
  return ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemBuilder: (context, index) {
      final group = groups[index];
      return _buildGroupItem(
        group.id.toString(),
        group.name,
        group.image ?? "",
      );
    },
    separatorBuilder: (context, index) => const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(
        height: 10,
        thickness: 0.7,
        color: Color.fromARGB(255, 197, 195, 195),
      ),
    ),
    itemCount: groups.length,
  );
}

Widget _buildGroupItem(String id, String name, String imagePath) {
  final groupController = Get.find<GroupsController>();
  return InkWell(
    onTap: () {
      Get.to(
        GroupDetailesPage(
          id: int.parse(id),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: imagePath.isNotEmpty
                ? NetworkImage(imagePath)
                : const AssetImage('assets/images/placeholder.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              Get.defaultDialog(
                title: 'Delete Group',
                middleText: 'Are you sure you want to delete this group?',
                textConfirm: 'Yes',
                textCancel: 'No',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  groupController.deleteGroup(int.parse(id));
                  Get.back(); // إغلاق نافذة التأكيد
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}

// بناء قائمة المستخدمين
Widget _buildUserList(List<UserDataa> users) {
  return ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemBuilder: (context, index) {
      final user = users[index];
      return _buildUserItem(user);
    },
    separatorBuilder: (context, index) => const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(
        height: 10,
        thickness: 0.7,
        color: Color.fromARGB(255, 197, 195, 195),
      ),
    ),
    itemCount: users.length,
  );
}

// عنصر المستخدم
Widget _buildUserItem(UserDataa user) {
  final userController = Get.find<UserController>();
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: AppColor.purple,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.firstName} ${user.lastName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Tooltip(
          message: user.isBlocked ? 'Unblock User' : 'Block User',
          child: IconButton(
            icon: Icon(
              user.isBlocked ? Icons.lock_open : Icons.lock,
              color: user.isBlocked ? Colors.green : Colors.red,
            ),
            onPressed: () {
              user.isBlocked
                  ? userController.unBlockUser(user.id)
                  : userController.blockUser(user.id);
            },
          ),
        ),
      ],
    ),
  );
}
