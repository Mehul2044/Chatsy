import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy("createdAt", descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            reverse: true,
            itemBuilder: (context, index) {
              return MessageBubble(
                message: chatSnapshot.data?.docs[index]["text"] as String,
                isMe: chatSnapshot.data?.docs[index]["userId"] ==
                    FirebaseAuth.instance.currentUser!.uid,
                username: chatSnapshot.data?.docs[index]["username"],
                userImage: chatSnapshot.data?.docs[index]["userImage"],
              );
            },
            itemCount: chatSnapshot.data?.docs.length);
      },
    );
  }
}
