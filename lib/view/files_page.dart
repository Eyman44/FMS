import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/fonts.dart';
import 'package:flutter_application_1/constant/image.dart';
import 'package:flutter_application_1/view/add_file_dialog.dart';
import 'package:flutter_application_1/view/group_invite_page.dart';
import 'package:flutter_application_1/view/member_page.dart';
import 'package:flutter_application_1/view/upload_request_page.dart';
import 'package:get/get.dart';

class GroupDetailesPage extends StatefulWidget {
  const GroupDetailesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupDetailesPage> {
  final List<String> imageUrls = [
    AppImageAsset.slider1,
    AppImageAsset.slider2,
    AppImageAsset.slider3,
  ];

  final List<Map<String, dynamic>> files = [
    {
      "name": "File 1",
      "image": AppImageAsset.pdf,
      "modifications": ["Edited on 2023-10-10", "Created on 2023-09-15"],
    },
    {
      "name": "File 2",
      "image": AppImageAsset.pdf,
      "modifications": ["Edited on 2023-10-12", "Created on 2023-09-18"],
    },
    {
      "name": "File 3",
      "image": AppImageAsset.pdf,
      "modifications": ["Edited on 2023-10-14", "Created on 2023-09-20"],
    },
  ];

  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1200 ? 5 : (screenWidth > 800 ? 4 : 3);
    double childAspectRatio = screenWidth > 800 ? 0.8 : 0.75;

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // اسم التطبيق
            const Row(
              children: [
                Icon(Icons.group, color: AppColor.title),
                SizedBox(width: 8),
                Text(
                  "MyApp",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.title,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ],
            ),

            // الأزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupInviteScreen()),
                    );
                  },
                  icon: const Icon(Icons.person_add,
                      color: AppColor.title, size: 20),
                  label: const Text(
                    "Join Invitations",
                    overflow: TextOverflow.ellipsis, // تقصير النص إذا لزم الأمر
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestsPage()),
                    );
                  },
                  icon:
                      const Icon(Icons.upload, color: AppColor.title, size: 20),
                  label: const Text(
                    "Upload Requests",
                    overflow: TextOverflow.ellipsis, // تقصير النص إذا لزم الأمر
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Slider Section
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
              ),
              Positioned(
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (_currentPage > 0) {
                      _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }
                  },
                ),
              ),
              Positioned(
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    if (_currentPage < imageUrls.length - 1) {
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(imageUrls.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index ? Colors.blue : Colors.grey,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MembersPage()),
              );
            },
            child: Container(
              color: AppColor.title,
              width: double.infinity,
              height: 40,
              child: const Center(
                child: Text(
                  "Group for those interested in computer science",
                  style: TextStyle(
                    color: AppColor.backgroundcolor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.font,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: files.length + 1, // for add button
                itemBuilder: (context, index) {
                  if (index == files.length) {
                    return Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AddFileDialog();
                            },
                          );
                          print("Add File click");
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add File"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    );
                  }

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
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child: Image.network(
                                  files[index]["image"]!,
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
                                    print("Selected $value");
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        value: "Last Modification",
                                        child: Text(
                                            "Last Modification: ${files[index]["modifications"].last}"),
                                      ),
                                      PopupMenuItem(
                                        value: "All Modifications",
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("All Modifications:"),
                                            ...files[index]["modifications"]
                                                .map<Widget>(
                                                    (mod) => Text("- $mod"))
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
                            files[index]["name"]!,
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
                              icon: const Icon(Icons.download,
                                  color: Colors.green),
                              onPressed: () {
                                print("Download ${files[index]["name"]}");
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                print("Edit ${files[index]["name"]}");
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                print("Delete ${files[index]["name"]}");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
