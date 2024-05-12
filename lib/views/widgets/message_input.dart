import 'package:ai_assistant/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageInputField extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  MessageInputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Type your message here...",
                border: InputBorder.none,
              ),
              onFieldSubmitted: (value) {
                if (_controller.text.isNotEmpty) {
                    ref.read(chatViewModelProvider.notifier).addMessage(_controller.text, true);
                ref.read(chatViewModelProvider.notifier).sendMessageToBot(_controller.text);
                  _controller.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                ref.read(chatViewModelProvider.notifier).sendMessageToBot(_controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
