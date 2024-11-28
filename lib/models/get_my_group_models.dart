import 'package:flutter_application_1/main.dart';

class GroupData {
  bool isAdmin;
  List<MyGroup> myGroups;
  List<PublicGroup> publicGroups;

  GroupData({
    required this.isAdmin,
    required this.myGroups,
    required this.publicGroups,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      isAdmin: json['isAdmin'],
      myGroups: MyGroup.fromJsonList(json['myGroups']),
      publicGroups: PublicGroup.fromJsonList(json['publicGroups']),
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
      groupId: json['groupId'],
      group: GroupDetails.fromJson(json['Group']),
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
      id: json['id'],
      name: json['name'],
      image: json['image'] == null || json['image'].isEmpty
          ? "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png"
          : "$baseurl/images/groups/" + json['image'],
    );
  }

  static List<PublicGroup> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PublicGroup.fromJson(json)).toList();
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
      name: json['name'],
      image: json['image'] == null || json['image'].isEmpty
          ? "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png"
          : "$baseurl/images/groups/" + json['image'],
    );
  }
}
