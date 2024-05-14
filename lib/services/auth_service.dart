import 'package:ai_assistant/providers/subscribe_provider.dart';
import 'package:ai_assistant/providers/token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));

class AuthService {
  final Ref ref;
  AuthService(this.ref);

  Future<UserModel> login(String email, String password) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    var response = await http.post(
      Uri.parse('http://127.0.0.1:8080/v1/user/login'),
      headers: headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ref.read(tokenProvider.notifier).token = data['token'] ?? '';
        print('This is the auth service login function');
        print(ref.read(tokenProvider.notifier).token);
        return UserModel.fromJson(data['userInfo']);
      } else {
        throw Exception(data['errorMessage'] ?? 'Unknown error occurred');
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

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['status'] == 'success';
    } else {
      throw Exception('Failed to register');
    }
  }

 void logout()  {
    ref.read(tokenProvider.notifier).token = '';
  }

  Future<void> subscribe() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${ref.read(tokenProvider.notifier).token}', 
    };

    var response = await http.post(
      Uri.parse('http://127.0.0.1:8080/v1/user/subscribe'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        if (data['newToken'] != null) {
          ref.read(tokenProvider.notifier).token = data['newToken'];
          ref.read(subscriptionProvider.notifier).updateSubscription(true);
        }
      } else {
        throw Exception(data['errorMessage'] ??
            'Unknown error occurred during subscription');
      }
    } else {
      throw Exception('Failed to subscribe');
    }
  }
}
