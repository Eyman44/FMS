class UserToInvite {
  final int id;
  final String email;
  final String firstName;
  final String lastName;

  UserToInvite({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UserToInvite.fromJson(Map<String, dynamic> json) {
    return UserToInvite(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}

class UsersToInviteResponse {
  final bool isAdmin;
  final List<UserToInvite> users;

  UsersToInviteResponse({
    required this.isAdmin,
    required this.users,
  });

  factory UsersToInviteResponse.fromJson(Map<String, dynamic> json) {
    return UsersToInviteResponse(
      isAdmin: json['isAdmin'],
      users: (json['data'] as List)
          .map((user) => UserToInvite.fromJson(user))
          .toList(),
    );
  }
}
