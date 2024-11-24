import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/fonts.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  final List<String> users = ["Eve", "John", "Jane", "Max"];
  final List<String> invitedUsers = [];
  String searchQuery = "";

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
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (!user.toLowerCase().contains(searchQuery)) {
                    return const SizedBox.shrink();
                  }
                  final isInvited = invitedUsers.contains(user);
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 12.0), // زيادة المسافة بين البطاقات
                    elevation: 4, // تباين أكبر للبطاقة
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16.0), // زاوية دائرية أكبر
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0), // حواف داخلية أكبر
                      leading: const Icon(
                        Icons.person,
                        color: AppColor.purple,
                        size: 40, // تكبير الأيقونة
                      ),
                      title: Text(
                        user,
                        style: const TextStyle(
                          fontSize: 20, // تكبير حجم النص
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.font,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            if (isInvited) {
                              invitedUsers.remove(user);
                            } else {
                              invitedUsers.add(user);
                            }
                          });
                        },
                        icon: Icon(
                          isInvited
                              ? Icons.cancel_schedule_send_rounded
                              : Icons.send,
                          color: isInvited ? Colors.red : AppColor.purple,
                          size: 30, // تكبير الأيقونة
                        ),
                        tooltip:
                            isInvited ? "Cancel Invitation" : "Send Invitation",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
