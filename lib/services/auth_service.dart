import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  String token = '';

  Future<UserModel> login(String email, String password) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept':
          'application/json', // To ensure the server knows what response format we accept
    };

    var response = await http.post(
      Uri.parse('http://127.0.0.1:8080/v1/user/login'),
      headers: headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      print('response is Ok 200');
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        // Save the token in the variable
        print(data);
        token = data['token'];
        print(data['userInfo']);
        print(data['errorMessage']);
        return UserModel.fromJson(data['userInfo']);
      } else {
        throw Exception(data['errorMessage']);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> register(
      String email, String password, String firstName, String lastName) async {
    var response = await http.post(
      Uri.parse('http://127.0.0.1:8080/v1/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName
      }),
    );

    var data = jsonDecode(response.body);
    print(data);
    return data['status'] == 'success';
  }

  Future<void> logout(String token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer $token', // Assuming JWT or similar token is used for auth
    };

    var response = await http.post(
      Uri.parse('http://127.0.0.1:8080/v1/auth/logout'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Handle successful logout
    } else {
      // Handle error on logout
      throw Exception('Failed to logout');
    }
  }
}
