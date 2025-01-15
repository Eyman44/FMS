import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/custom_app_bar.dart.dart';
import 'package:flutter_application_1/constant/image.dart';
import 'package:flutter_application_1/controller/admin_get_all_group_controller.dart';
import 'package:flutter_application_1/controller/get_all_group_controller.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/view/add_group.dart';
import 'package:flutter_application_1/view/files_page.dart';
import 'package:get/get.dart';

import '../controller/group_edit_contoller.dart';

class GroupPage extends StatelessWidget {
  GroupPage({super.key});

  final groupController = Get.put(GroupController());
  final groupsController = Get.put(GroupsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColor.backgroundcolor,
        appBar: const CustomAppBar(
          title: "Groups",
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search groups...',
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
            Obx(() {
              if (groupController.isSearching.value) {
                return Expanded(
                  child: _buildGroupList(groupController.filteredGroups),
                );
              } else {
                return Expanded(
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
                            Tab(text: 'My Own Group'),
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
                              if (groupController.isLoading.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (groupController.myOwnGroups.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 200),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.group_off,
                                          size: 100,
                                          color: AppColor.orange,
                                        ),
                                        SizedBox(height: 50),
                                        Text(
                                          "No Owned Groups",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.title,
                                            fontFamily: 'Poppins-Regular.ttf',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return _buildGroupList([
                                ...groupController.myOwnGroups.map((group) => {
                                      'id': group.id.toString(),
                                      'name': group.name,
                                      'image': group.image,
                                    }),
                              ]);
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
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
      ),
    );
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
                  : const AssetImage(AppImageAsset.slider1) as ImageProvider,
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
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.deepPurpleAccent),
              onPressed: () {
                showEditGroupDialog(
                  Get.context!,
                  int.parse(id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
