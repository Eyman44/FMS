import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/fetch_file_info_controller.dart';


void showFileInfoDialog(BuildContext context, int fileId) {
  final FileInfoController fileInfoController = Get.put(FileInfoController(fileId: fileId));

  showDialog(
    context: context,
    builder: (context) {
      return Obx(() {
        if (fileInfoController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final fileInfo = fileInfoController.fileInfo;
        final fileStatistics = fileInfoController.fileStatistics;

        return AlertDialog(
          title: Text('File Info: ${fileInfo['name'] ?? 'Unknown'}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${fileInfo['name'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Uploaded At: ${fileInfo['UploadedAt'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Owner: ${fileInfo['User'] != null ? "${fileInfo['User']['firstName']} ${fileInfo['User']['lastName']}" : 'N/A'}'),
                const SizedBox(height: 8),
                Text('Email: ${fileInfo['User']?['email'] ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Free: ${fileInfo['free'] == true ? 'Yes' : 'No'}'),
                const Divider(),
                Text('Statistics:', style: const TextStyle(fontWeight: FontWeight.bold)),
                ...fileStatistics.map((stat) => Text(stat.toString())).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      });
    },
  );
}
