import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/fonts.dart';

class FileCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final List<String> modifications;
  final VoidCallback onDownload;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FileCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.modifications,
    required this.onDownload,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        size: 30, color: AppColor.purple),
                    onSelected: (String value) {
                      // Placeholder for menu actions
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: "Last Modification",
                          child: Text(
                              "Last Modification: ${modifications.last}"),
                        ),
                        PopupMenuItem(
                          value: "All Modifications",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("All Modifications:"),
                              ...modifications
                                  .map<Widget>((mod) => Text("- $mod"))
                                  .toList(),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.font,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.download, color: Colors.green),
                onPressed: onDownload,
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
