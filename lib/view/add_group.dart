import 'package:flutter/material.dart';

void showAddGroupDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  bool isPublic = false;

  showDialog(
    context: context,
    builder: (context) {
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
                    isPublic = value;
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق النافذة
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // قم بتنفيذ منطق إضافة الغروب هنا
              Navigator.pop(context); // إغلاق النافذة
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}
