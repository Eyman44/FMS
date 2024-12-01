import 'package:flutter_application_1/main.dart';

class MyOwnGroupData {
  bool isAdmin;
  List<OwnGroup> groups;

  MyOwnGroupData({
    required this.isAdmin,
    required this.groups,
  });

  factory MyOwnGroupData.fromJson(Map<String, dynamic> json) {
    return MyOwnGroupData(
      isAdmin: json['isAdmin'] ?? false,
      groups: OwnGroup.fromJsonList(
          json['data']['data']), // استخراج القائمة الصحيحة
    );
  }
}

class OwnGroup {
  int id;
  String name;
  String image;
  bool isPublic;

  OwnGroup({
    required this.id,
    required this.name,
    required this.image,
    required this.isPublic,
  });

  factory OwnGroup.fromJson(Map<String, dynamic> json) {
    return OwnGroup(
      id: json['id'] ?? 0, // استخدام قيمة افتراضية إذا كانت null
      name: json['name'] ?? "Unknown", // قيمة افتراضية
      image:"https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
      //  json['image'] == null || json['image'].isEmpty
      //     ? "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png"
      //     : "$baseurl/images/groups/" + json['image'],
      isPublic: json['isPublic'] ?? false, // قيمة افتراضية
    );
  }

  static List<OwnGroup> fromJsonList(dynamic jsonList) {
    if (jsonList is List) {
      return jsonList.map((json) => OwnGroup.fromJson(json)).toList();
    } else {
      throw Exception('Expected a List but got: $jsonList');
    }
  }
}
