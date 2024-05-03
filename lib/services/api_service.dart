import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class ApiService {
  Future<String> sendMessage(String message) async {
    var url = Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_API_KEY'
      },
      body: jsonEncode({'prompt': message, 'max_tokens': 150}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['choices'][0]['text'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
