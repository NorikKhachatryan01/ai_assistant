import 'package:ai_assistant/models/chat_room_model.dart';
import 'package:ai_assistant/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_assistant/providers/chat_provider.dart';
import 'package:ai_assistant/views/widgets/chat_drawer.dart';
import 'package:ai_assistant/views/widgets/message_input.dart';
import 'package:ai_assistant/views/widgets/message_list.dart';

class ChatScreen extends ConsumerWidget {
  final ChatRoom? chatRoom; 

  const ChatScreen({Key? key, this.chatRoom}) : super(key: key); 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(chatViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoom?.name ??
            'AI Assistant'), 
        backgroundColor: Colors.black,
      ),
      drawer: const ChatDrawer(),
      body: Column(
        children: <Widget>[
           Expanded(child: MessageList()),
          MessageInputField(),
        ],
      ),
    );
  }
}
