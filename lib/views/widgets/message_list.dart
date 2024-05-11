import 'package:ai_assistant/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MessageList extends ConsumerWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatViewModelProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                if (message.isLoading) {
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                              color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(width: 10),
                        LoadingAnimationWidget.waveDots(
                          color: Colors.black,
                          size: 36,
                        ),
                      ],
                    ),
                    subtitle: Text(message.isUser ? 'You' : 'AI'),
                  );
                } else {
                  return ListTile(
                    title: Text(
                      message.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w100),
                    ),
                    subtitle: Text(message.isUser ? 'You' : 'AI'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
