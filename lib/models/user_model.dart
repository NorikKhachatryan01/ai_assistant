class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final bool emailVerified;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool,
    );
  }
}
