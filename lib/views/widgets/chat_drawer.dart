import 'dart:math';

import 'package:ai_assistant/models/chat_room_model.dart';
import 'package:ai_assistant/services/chat_room_service.dart';
import 'package:ai_assistant/views/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatDrawer extends ConsumerWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRooms = ref.watch(chatRoomServiceProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const  Text('Create New Chat Room'),
            onTap: () async {
              // Instantiate a new chat room and add it using the ChatRoomService
              final newChatRoom =
                  ChatRoom(name: 'New Chat Room ${Random().nextInt(100)}');
              ref
                  .read(chatRoomServiceProvider.notifier)
                  .addChatRoom(newChatRoom);
              // Close the drawer
              Navigator.of(context).pop();
            },
          ),
          const ListTile(
            title: Text('Existing Chat Rooms',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.chat),
                title: Text(chatRooms[index].name),
                onTap: () {
                  // Close the drawer
                  Navigator.of(context).pop();
                  // Navigate to the ChatScreen with the selected chat room
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(chatRoom: chatRooms[index]),
                    ),
                  );
                },
              );
            },
          ),
         const  Divider(thickness: 2.0),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const  Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const  Icon(Icons.info_outline),
            title: const  Text('About Me'),
            onTap: () {
              Navigator.of(context).pop();
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

void _showAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('About Me'),
        content: const  SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a AI Assistant application.'),
              Text(
                  'Created to demonstrate our skills in Software Engineering.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
