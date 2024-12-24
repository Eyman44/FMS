import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/view/group_invite_page.dart';
import 'package:flutter_application_1/view/upload_request_page.dart';

class CustomAppBarForAdmin extends StatelessWidget
    implements PreferredSizeWidget {
  final String title; // إذا كنت تريد تخصيص اسم التطبيق
  final double elevation; // تخصيص ارتفاع الظل إذا لزم الأمر

  const CustomAppBarForAdmin({
    super.key,
    this.title = "Fily", // افتراضي
    this.elevation = 10.0, // افتراضي
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      shadowColor: Colors.grey.withOpacity(0.5),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // اسم التطبيق
          Flexible(
            child: Row(
              children: [
                const Icon(Icons.group, color: AppColor.title),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.title,
                    ),
                    overflow: TextOverflow.ellipsis, // لمنع overflow
                  ),
                ),
              ],
            ),
          ),

          // الأزرار
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupInviteScreen()),
                  );
                },
                icon: const Icon(Icons.login_rounded,
                    color: AppColor.title, size: 20),
                label: const Text(
                  "Logining",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadRequestsPage()),
                  );
                },
                icon: const Icon(Icons.file_open_rounded,
                    color: AppColor.title, size: 20),
                label: const Text(
                  "File history reports",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
