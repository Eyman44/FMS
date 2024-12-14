import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../controller/group_controller.dart';

void showAddGroupDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final GroupCreateController groupController = Get.put(GroupCreateController());
  bool isPublic = false;
  File? selectedImage;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New Group'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Group Name',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Public Group'),
                    Switch(
                      value: isPublic,
                      onChanged: (value) {
                        setState(() {
                          isPublic = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (selectedImage != null) ...[
                  Image.file(
                    selectedImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                ],
                ElevatedButton(
                  onPressed: () async {
                    // اختيار الصورة باستخدام مكتبة file_picker
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );

                    if (result != null && result.files.single.path != null) {
                      setState(() {
                        selectedImage = File(result.files.single.path!);
                      });
                    } else {
                      print("No image selected.");
                    }
                  },
                  child: const Text('Choose Image'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final groupName = nameController.text.trim();

                  if (groupName.isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Group name cannot be empty.",
                      backgroundColor: Colors.orange,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }

                  bool success = await groupController.createGroup(
                    groupName,
                    isPublic,
                    selectedImage,
                  );

                  if (success) {
                    Get.snackbar(
                      "Success",
                      "Group created successfully.",
                      backgroundColor: Colors.green,
                      snackPosition: SnackPosition.TOP,
                    );
                    Navigator.pop(context);
                  } else {
                    Get.snackbar(
                      "Error",
                      "Failed to create the group.",
                      backgroundColor: Colors.red,
                      snackPosition: SnackPosition.TOP,
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}
