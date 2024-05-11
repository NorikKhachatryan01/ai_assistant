class UserModel {
  String firstName;
  String lastName;
  String email;
  bool emailVerified;
  String token;

  UserModel({required this.firstName, required this.lastName, required this.email, required this.emailVerified, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      emailVerified: json['emailVerified'],
      token: json['token'],
    );
  }
}
