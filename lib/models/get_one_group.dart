class GroupResponse {
  final bool groupOwner;
  final bool isAdmin;
  final GroupData data;

  GroupResponse({
    required this.groupOwner,
    required this.isAdmin,
    required this.data,
  });

  factory GroupResponse.fromJson(Map<String, dynamic> json) {
    return GroupResponse(
      groupOwner: json['groupOwner'] ?? false,
      isAdmin: json['isAdmin'] ?? false,
      data: GroupData.fromJson(json['data']),
    );
  }
}

class GroupData {
  final int id;
  final String name;
  final String image;
  final bool isPublic;
  final List<dynamic> groupFiles;

  GroupData({
    required this.id,
    required this.name,
    required this.image,
    required this.isPublic,
    required this.groupFiles,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Unknown",
      image:
          "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
      //  json['image'] == null || json['image'].isEmpty
      //     ? "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png"
      //     : "$baseurl/images/groups/" + json['image'],
      isPublic: json['isPublic'] ?? false,
      groupFiles:
          json['groupFiles'] ?? [], // استخدام قائمة فارغة كقيمة افتراضية
    );
  }
}