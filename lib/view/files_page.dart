import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/custom_app_bar.dart.dart';
import 'package:flutter_application_1/constant/fonts.dart';
import 'package:flutter_application_1/constant/image.dart';
import 'package:flutter_application_1/controller/get_one_group_controller.dart';
import 'package:flutter_application_1/view/member_page.dart';
import 'package:get/get.dart';

class GroupDetailesPage extends StatefulWidget {
  final int id;

  const GroupDetailesPage({super.key, required this.id});

  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupDetailesPage> {
  late final GroupDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(GroupDetailsController(id: widget.id));
    controller.fetchGroupDetails();
  }

  void _showFileUploadDialog() {
    String fileName = '';
    Uint8List? selectedFileBytes;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add File"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  fileName = value;
                },
                decoration: const InputDecoration(
                  labelText: "File Name",
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null && result.files.first.bytes != null) {
                    selectedFileBytes = result.files.first.bytes;
                  }
                },
                child: const Text("Choose File"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (fileName.isNotEmpty && selectedFileBytes != null) {
                  controller.uploadFile(
                    groupId: widget.id,
                    fileName: fileName,
                    fileBytes: selectedFileBytes!,
                  );
                  Navigator.pop(context);
                } else {
                  Get.snackbar(
                      "Error", "Please fill all fields and choose a file.");
                }
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }
  void _showFileCheckOutDialog() {
    String fileName = '';
    Uint8List? selectedFileBytes;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Checkout File"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  fileName = value;
                },
                decoration: const InputDecoration(
                  labelText: "File Name",
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null && result.files.first.bytes != null) {
                    selectedFileBytes = result.files.first.bytes;
                  }
                },
                child: const Text("Choose File"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (fileName.isNotEmpty && selectedFileBytes != null) {
                  controller.uploadFile(
                    groupId: widget.id,
                    fileName: fileName,
                    fileBytes: selectedFileBytes!,
                  );
                  Navigator.pop(context);
                } else {
                  Get.snackbar(
                      "Error", "Please fill all fields and choose a file.");
                }
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      appBar: const CustomAppBar(
        title: "Group Details",
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

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
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                groupData.image,
                fit: BoxFit.cover,
              ),
            ),
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
                            style:
                                TextStyle(fontSize: 18, color: AppColor.title),
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
                              elevation: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // عرض صورة PDF
                                  Expanded(
                                    child: Image.asset(
                                      AppImageAsset.pdf,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // اسم الملف
                                  Text(
                                    file.file.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColor.title,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // الأيقونات (تحميل، رفع، حذف)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // أيقونة التحميل
                                      IconButton(
                                        icon: const Icon(Icons.download,
                                            color: Colors.green),
                                        onPressed: () {
                                          controller.checkIn(
                                              groupId: widget.id,
                                              fileIds: [file.fileId],
                                              );
                                          Get.snackbar("Checking In",
                                              "Downloading ${file.file.name}");
                                        },
                                      ),
                                      // أيقونة الرفع
                                      IconButton(
                                        icon: const Icon(Icons.upload,
                                            color: Colors.blue),
                                        onPressed: _showFileCheckOutDialog
                                      ),
                                      // أيقونة الحذف
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Delete File"),
                                                content: const Text(
                                                    "Are you sure you want to delete this file?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      controller.deleteFile(
                                                        groupId: widget.id,
                                                        fileId: file.fileId,
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Delete"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFileUploadDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
