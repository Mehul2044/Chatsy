import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String username;
  final String message;
  final bool isMe;

  const MessageBubble(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle userNameStyle = isMe
        ? Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black)
        : Theme.of(context).textTheme.titleMedium!;
    final TextStyle messageContentStyle = isMe
        ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black)
        : Theme.of(context).textTheme.bodyMedium!;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Colors.grey[300]
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(!isMe ? 0 : 12),
              bottomRight: Radius.circular(isMe ? 0 : 12),
            ),
          ),
          width: 240,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(isMe ? "You" : username, style: userNameStyle),
              Text(message,
                  style: messageContentStyle,
                  textAlign: isMe ? TextAlign.end : TextAlign.start),
            ],
          ),
        ),
      ],
    );
  }
}
