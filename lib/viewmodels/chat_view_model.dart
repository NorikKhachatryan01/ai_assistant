import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../services/api_service.dart'; // Make sure you have ApiService defined

class ChatViewModel extends StateNotifier<List<Message>> {
  final Ref ref;

  ChatViewModel(this.ref) : super([]);

  Future<void> sendMessage(String text) async {
    // Updating state immutably
    state = [...state, Message(text: text, isUser: true)];

    try {
      var response = await ref.read(apiServiceProvider).sendMessage(text);
      state = [...state, Message(text: response, isUser: false)];
    } catch (e) {
      // Handle error; perhaps show a message or log it
      // For now, just print the error
      // ignore: avoid_print
      print('Error sending message: $e');
    }
  }
}
