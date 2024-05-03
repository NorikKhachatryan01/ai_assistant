import 'package:ai_assistant/models/chat_room_model.dart';
import 'package:ai_assistant/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomServiceProvider =
    StateNotifierProvider<ChatRoomService, List<ChatRoom>>((ref) {
  return ChatRoomService([]);
});

class ChatRoomService extends StateNotifier<List<ChatRoom>> {
  ChatRoomService(List<ChatRoom> initialChatRooms) : super(initialChatRooms);

  void addMessageToChatRoom(String chatRoomName, Message message) {
    state
        .firstWhere((chatRoom) => chatRoom.name == chatRoomName)
        .messages
        .add(message);
  }

  void addChatRoom(ChatRoom chatRoom) {
    state = [...state, chatRoom];
  }
}
