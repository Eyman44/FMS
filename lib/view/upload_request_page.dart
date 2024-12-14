import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/get_one_group_controller.dart';
import 'package:flutter_application_1/controller/upload_requests_controller.dart';
import 'package:get/get.dart';
import '../constant/color.dart';
import '../constant/fonts.dart';

class UploadRequestsPage extends StatelessWidget {
  UploadRequestsPage({super.key});
  final controller = Get.put(UploadRequestsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "File Upload Requests",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.purple,
      ),
      body: GetBuilder<UploadRequestsController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.uploadRequestsResponse == null ||
              controller.uploadRequestsResponse!.groups.isEmpty) {
            return const Center(
              child: Text(
                "No upload requests found.",
                style: TextStyle(fontSize: 18, fontFamily: AppFonts.font),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.uploadRequestsResponse!.groups.length,
            itemBuilder: (context, groupIndex) {
              final group =
                  controller.uploadRequestsResponse!.groups[groupIndex];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // اسم المجموعة
                        Text(
                          "Group: ${group.name}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.font,
                              color: AppColor.title),
                        ),
                        const SizedBox(height: 5),
                        // الملفات المرتبطة
                        ...group.pendingFiles.map((fileRequest) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                "File: ${fileRequest.fileDetails.name}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppFonts.font,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Uploaded by: ${fileRequest.fileDetails.uploader.firstName} ${fileRequest.fileDetails.uploader.lastName}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontFamily: AppFonts.font,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // زر رفض
                                  TextButton(
                                    onPressed: () {
                                        controller.declineRequest(fileRequest.fileDetails.id);
                                     
                                      print(
                                          "Request declined for file: ${fileRequest.fileDetails.name}");
                                    },
                                    child: const Text(
                                      "Reject",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  // زر قبول
                                  ElevatedButton(
                                    onPressed: () {
                                       controller.acceptRequest(fileRequest.fileDetails.id);
                                      print(
                                          "Request accepted for file: ${fileRequest.fileDetails.name}");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColor.iconColor,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                    ),
                                    child: const Text(
                                      "Accept",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
