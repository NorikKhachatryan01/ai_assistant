import 'package:ai_assistant/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageList extends ConsumerWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatViewModelProvider);
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            messages[index].text,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w100),
          ),
          subtitle: Text(messages[index].isUser ? 'You' : 'AI'),
        );
      },
    );
  }
}
