import 'package:ai_assistant/providers/subscribe_provider.dart';
import 'package:ai_assistant/providers/token_provider.dart';
import 'package:ai_assistant/services/auth_service.dart';
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
  final Ref ref;
  ChatViewModel(this.ref) : super([]);

  void addMessage(String message, bool isUser, {bool isLoading = false}) {
    state = [
      ...state,
      Message(text: message, isUser: isUser, isLoading: isLoading)
    ];
  }

  Future<void> sendMessageToBot(String prompt) async {
    String url = ref.watch(subscriptionProvider) ? 'https://4849-193-104-215-11.ngrok-free.app/v1/completions/premium' : 'https://4849-193-104-215-11.ngrok-free.app/v1/completions/standard';
    String token = ref.read(tokenProvider.notifier).token;
    print('This is the api service sendMessage fucntion');
    print(token);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    addMessage("", false, isLoading: true);

    try {
      var response = await http.post(
        Uri.parse(
            url),
        headers: headers,
        body: jsonEncode({'prompt': prompt}),
      );

      state =
          state.where((m) => !m.isLoading).toList();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        addMessage(data['response'], false);
      } else {
        print(jsonDecode(response.body));
        addMessage(jsonDecode(response.body)['error'], false);
      }
    } catch (e) {
      state =
          state.where((m) => !m.isLoading).toList(); 
      addMessage('Error: $e', false);
    }
  }
}
