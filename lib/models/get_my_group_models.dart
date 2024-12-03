import 'package:flutter_application_1/main.dart';

class GroupData {
  bool isAdmin;
  List<MyGroup> myGroups;
  List<PublicGroup> publicGroups;
  List<MyOwnGroup> myOwnGroups;

  GroupData({
    required this.isAdmin,
    required this.myGroups,
    required this.publicGroups,
    required this.myOwnGroups,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      isAdmin: json['isAdmin'] ?? false,
      myGroups: MyGroup.fromJsonList(json['myGroups'] ?? []),
      publicGroups: PublicGroup.fromJsonList(json['publicGroups'] ?? []),
      myOwnGroups: MyOwnGroup.fromJsonList(json['myOwnGroups'] ?? []),
    );
  }
}

class MyGroup {
  int groupId;
  GroupDetails group;

  MyGroup({
    required this.groupId,
    required this.group,
  });

  factory MyGroup.fromJson(Map<String, dynamic> json) {
    return MyGroup(
      groupId: json['groupId'] ?? 0,
      group: GroupDetails.fromJson(json['Group'] ?? {}),
    );
  }

  static List<MyGroup> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MyGroup.fromJson(json)).toList();
  }
}

class PublicGroup {
  int id;
  String name;
  String image;

  PublicGroup({
    required this.id,
    required this.name,
    required this.image,
  });

  factory PublicGroup.fromJson(Map<String, dynamic> json) {
    return PublicGroup(
        id: json['id'] ?? 0,
        name: json['name'] ?? "Unnamed Group",
        image:// "$baseurl/images/groups/1732433765035.jpg");
       "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
    //       json['image'] != null && json['image'].isNotEmpty
    //           ? "$baseurl/images/groups/1732433765035.jpg"
    //           : "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
     );
  }

  static List<PublicGroup> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PublicGroup.fromJson(json)).toList();
  }
}

class MyOwnGroup {
  int id;
  String name;
  String image;
  bool isPublic;

  MyOwnGroup({
    required this.id,
    required this.name,
    required this.image,
    required this.isPublic,
  });

  factory MyOwnGroup.fromJson(Map<String, dynamic> json) {
    return MyOwnGroup(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Unnamed Group",
      image:
          "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
      // json['image'] != null && json['image'].isNotEmpty
      //     ? "$baseurl/images/groups/${json['image']}"
      //     : "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
      isPublic: json['isPublic'] ?? false,
    );
  }

  static List<MyOwnGroup> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MyOwnGroup.fromJson(json)).toList();
  }
}

class GroupDetails {
  String name;
  String image;

  GroupDetails({
    required this.name,
    required this.image,
  });

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
      name: json['name'] ?? "Unnamed Group",
      image:
          "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
      // json['image'] != null && json['image'].isNotEmpty
      //     ? "$baseurl/images/groups/${json['image']}"
      //     : "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
    );
  }
}
