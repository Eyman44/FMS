import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/fonts.dart';
import 'package:flutter_application_1/controller/invite_controller.dart';
import 'package:get/get.dart';

class InvitePage extends StatefulWidget {
  final int id;
  const InvitePage({super.key, required this.id});

  @override
  InvitePageState createState() => InvitePageState();
}

class InvitePageState extends State<InvitePage> {
  late final InviteController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(InviteController(groupId: widget.id));
    controller.fetchUsersToInvite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Send Invitation",
          style: TextStyle(
            fontFamily: AppFonts.font,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search for a user...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) {
                controller.filterUsers(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredUsers.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                return ListView.builder(
                  itemCount: controller.filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = controller.filteredUsers[index];
                    final isInvited =
                        controller.sentInvitations.contains(user.id);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 20.0),
                        leading: const Icon(
                          Icons.person,
                          color: AppColor.purple,
                          size: 40,
                        ),
                        title: Text(
                          "${user.firstName} ${user.lastName}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                        subtitle: Text(user.email),
                        trailing: IconButton(
                          onPressed: isInvited
                              ? null
                              : () async {
                                  final message = await showDialog<String>(
                                    context: context,
                                    builder: (context) {
                                      String note = '';
                                      return AlertDialog(
                                        title: const Text("Add a note"),
                                        content: TextField(
                                          onChanged: (value) => note = value,
                                          decoration: const InputDecoration(
                                              hintText: "Enter a note"),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, note),
                                            child: const Text("Send"),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (message != null && message.isNotEmpty) {
                                    await controller.sendInvite(
                                        userId: user.id, message: message);
                                  }
                                },
                          icon: Icon(
                            isInvited ? Icons.check : Icons.send,
                            color: isInvited ? Colors.green : AppColor.purple,
                            size: 30,
                          ),
                          tooltip:
                              isInvited ? "Invitation Sent" : "Send Invitation",
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
