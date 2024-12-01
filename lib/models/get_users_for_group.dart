class GroupUserData {
  bool groupOwner;
  bool isAdmin;
  List<UserData> users;

  GroupUserData({
    required this.groupOwner,
    required this.isAdmin,
    required this.users,
  });

  factory GroupUserData.fromJson(Map<String, dynamic> json) {
    return GroupUserData(
      groupOwner: json['groupOwner'],
      isAdmin: json['isAdmin'],
      users: (json['data'] as List)
          .map((user) => UserData.fromJson(user['User']))
          .toList(),
    );
  }


}

class UserData {
  int id;
  String email;
  String firstName;
  String lastName;
  List<UserPermission> permissions;

  UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.permissions,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      permissions: (json['UserGroupPermissions'] as List)
          .map((perm) => UserPermission.fromJson(perm))
          .toList(),
    );
  }
}

class UserPermission {
  int permission;

  UserPermission({required this.permission});

  factory UserPermission.fromJson(Map<String, dynamic> json) {
    return UserPermission(
      permission: json['permission'],
    );
  }


}
