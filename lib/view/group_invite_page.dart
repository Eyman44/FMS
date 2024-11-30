import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:get/get.dart';
import '../controller/group_invite_controller.dart';

class GroupInviteScreen extends StatelessWidget {
  final GroupInviteController controller = Get.put(GroupInviteController());

  GroupInviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchGroupInvites();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Group Invitations",
          style: TextStyle(color: AppColor.title),
        ),
        backgroundColor: AppColor.purple,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.invites.isEmpty) {
          return const Center(
            child: Text(
              "No invitations found.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.invites.length,
          itemBuilder: (context, index) {
            var invite = controller.invites[index];
            var groupName = invite['Group'] != null ? invite['Group']['name'] : "Unknown Group";
            var userName = invite['Group'] != null ? invite['Group']['User']['firstName'] + " " + invite['Group']['User']['lastName'] : "No user info";
            var message = invite['message'] ?? "No message provided";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                      Text(
                        "Message: $message",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Group: $groupName",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "User: $userName",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await controller.rejectInvite(invite['id']);
                            },
                            child: const Text(
                              "Reject",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await controller.acceptInvite(invite['id']);
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
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
