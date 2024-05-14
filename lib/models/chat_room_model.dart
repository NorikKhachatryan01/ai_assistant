import 'package:ai_assistant/models/message_model.dart';

class ChatRoom {
  final String name;
  final List<Message> messages;

  ChatRoom({required this.name, List<Message>? messages}) : messages = messages ?? [];

  void copyWith({required List<Message> messages}) {}
}