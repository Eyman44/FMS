import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/customer_app_bar_for_admin.dart';
import 'package:flutter_application_1/controller/get_all_group_controller.dart';
import 'package:flutter_application_1/controller/get_all_users_controller.dart';
import 'package:flutter_application_1/models/get_all_user_model.dart';
import 'package:flutter_application_1/view/files_page.dart';
import 'package:get/get.dart';

class SuberPage extends StatelessWidget {
  SuberPage({super.key});

  final groupController = Get.put(GroupController());
  final userController = Get.put(UserController()); // إضافة كونترولر المستخدمين

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                },
              ),
            ),
            Expanded(
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
                        Obx(() {
                          if (groupController.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return _buildGroupList([
                            ...groupController.myGroups.map((group) => {
                                  'id': group.groupId.toString(),
                                  'name': group.group.name,
                                  'image': group.group.image,
                                }),
                            ...groupController.publicGroups.map((group) => {
                                  'id': group.id.toString(),
                                  'name': group.name,
                                  'image': group.image,
                                }),
                            ...groupController.myOwnnGroups.map((group) => {
                                  'id': group.id.toString(),
                                  'name': group.name,
                                  'image': group.image,
                                }),
                          ]);
                        }),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildGroupList(List<Map<String, String>> groups) {
  return ListView.separated(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    itemBuilder: (context, index) {
      final group = groups[index];
      return _buildGroupItem(
        group['id']!,
        group['name']!,
        group['image']!,
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
            backgroundImage: NetworkImage(imagePath),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

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
