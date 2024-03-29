import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_profile_screen.dart';

import '../widgets/chat/new_message.dart';
import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatsy"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "userProfile",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const Text("Your Profile"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "logout",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.exit_to_app,
                        color: Theme.of(context).colorScheme.error),
                    const Text("Log Out"),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == "logout") {
                FirebaseAuth.instance.signOut();
              }
              if (value == "userProfile") {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UserProfileScreen()));
              }
            },
          ),
        ],
      ),
      body: const SizedBox(
        child: Column(
          children: [
            Expanded(child: Messages()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
