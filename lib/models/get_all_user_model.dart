class UserDataResponse {
  String status;
  List<UserDataa> users;

  UserDataResponse({
    required this.status,
    required this.users,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
      status: json['status'] ?? "Unknown",
      users: UserDataa.fromJsonList(json['data']),
    );
  }
}

class UserDataa {
  int id;
  String email;
  String firstName;
  String lastName;
  bool isBlocked;

  UserDataa({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isBlocked,
  });

  factory UserDataa.fromJson(Map<String, dynamic> json) {
    return UserDataa(
      id: json['id'] ?? 0,
      email: json['email'] ?? "Unknown",
      firstName: json['firstName'] ?? "Unknown",
      lastName: json['lastName'] ?? "Unknown",
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  static List<UserDataa> fromJsonList(dynamic jsonList) {
    if (jsonList is List) {
      return jsonList.map((json) => UserDataa.fromJson(json)).toList();
    } else {
      throw Exception('Expected a List but got: $jsonList');
    }
  }
}
