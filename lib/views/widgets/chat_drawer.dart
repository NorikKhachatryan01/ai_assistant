import 'dart:math';
import 'package:ai_assistant/models/chat_room_model.dart';
import 'package:ai_assistant/services/auth_service.dart';
import 'package:ai_assistant/services/chat_room_service.dart';
import 'package:ai_assistant/views/chat_screen.dart';
import 'package:ai_assistant/views/login_screen.dart';
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
            title: const Text('Create New Chat Room'),
            onTap: () async {
              final newChatRoom =
                  ChatRoom(name: 'New Chat Room ${Random().nextInt(100)}');
              ref
                  .read(chatRoomServiceProvider.notifier)
                  .addChatRoom(newChatRoom);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.flash_on),
            title: const Text('Upgrade'),
            onTap: () async {
              try {
                await ref.read(authServiceProvider).subscribe();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text("Subscription successful and token updated!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error subscribing: ${e.toString()}")),
                );
              }
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
                  Navigator.of(context).pop();
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
          const Divider(thickness: 2.0),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              ref.read(authServiceProvider).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Me'),
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
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a Biti AI Assistant.'),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Created to demonstrate our skills in the Software Engineering.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
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
