import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  final String text;
  final bool isUser;
  final bool isLoading;

  Message({required this.text, required this.isUser, this.isLoading = false});
}

final chatViewModelProvider =
    StateNotifierProvider<ChatViewModel, List<Message>>((ref) {
  return ChatViewModel(ref);
});

class ChatViewModel extends StateNotifier<List<Message>> {
  final Ref _ref;
  ChatViewModel(this._ref) : super([]);

  void addMessage(String message, bool isUser, {bool isLoading = false}) {
    state = [
      ...state,
      Message(text: message, isUser: isUser, isLoading: isLoading)
    ];
  }

  Future<void> sendMessageToBot(String prompt) async {
    const String token =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZ0BnbWFpbC5jb20iLCJpYXQiOjE3MTU0MTk1NTcsImV4cCI6MTcxNTUwNTk1NywiYXV0aG9yaXRpZXMiOlsiVVNFUiJdfQ.8wrStLKQFpPFaQoMFw1WeLKAikQiDN-dFsQpTINhcqU'; // Replace with your actual bearer token
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    addMessage("", false, isLoading: true);
    print('.............................................1');
    try {
      print('.............................................2');
      var response = await http.post(
        Uri.parse(
            'https://9dab-5-77-254-89.ngrok-free.app/v1/completions/standard'),
        headers: headers,
        body: jsonEncode({'prompt': prompt}),
      );

      state =
          state.where((m) => !m.isLoading).toList(); // Remove loading message
      print('.............................................3');
      print(response.body);
      if (response.statusCode == 200) {
        print('.............................................4');
        var data = jsonDecode(response.body);
        addMessage(data['response'], false);
      } else {
        addMessage('Failed to fetch response from the server.', false);
      }
    } catch (e) {
      state =
          state.where((m) => !m.isLoading).toList(); // Remove loading message
      addMessage('Error: $e', false);
    }
  }
}
