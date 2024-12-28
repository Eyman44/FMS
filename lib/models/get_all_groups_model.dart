class AllGroupsResponse {
  String status;
  List<AllGroupData> groups;

  AllGroupsResponse({
    required this.status,
    required this.groups,
  });

  factory AllGroupsResponse.fromJson(Map<String, dynamic> json) {
    return AllGroupsResponse(
      status: json['status'] ?? "Unknown",
      groups: AllGroupData.fromJsonList(json['data']),
    );
  }
}

class AllGroupData {
  int id;
  String name;
  String? image;
  bool isPublic;

  AllGroupData({
    required this.id,
    required this.name,
    this.image,
    required this.isPublic,
  });

  factory AllGroupData.fromJson(Map<String, dynamic> json) {
    return AllGroupData(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Unknown",
      image:
          "https://cdn.elearningindustry.com/wp-content/uploads/2020/02/what-to-check-before-an-online-course-purchase.png",
      // json['image'],
      isPublic: json['isPublic'] ?? false,
    );
  }

  static List<AllGroupData> fromJsonList(dynamic jsonList) {
    if (jsonList is List) {
      return jsonList.map((json) => AllGroupData.fromJson(json)).toList();
    } else {
      throw Exception('Expected a List but got: $jsonList');
    }
  }
}
