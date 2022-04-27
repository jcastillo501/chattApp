import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String messagetext;
  final String username;
  final bool isMine;
  final Key key;

  const MessageBubble(
      {required this.messagetext,
      required this.username,
      required this.isMine,
      required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
              child: Padding(
            padding: isMine
                ? const EdgeInsets.only(left: 64)
                : const EdgeInsets.only(right: 64),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: isMine ? Colors.blue : Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMine ? 16 : 2),
                  bottomRight: Radius.circular(isMine ? 2 : 16),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    messagetext,
                    style: const TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
          ))
        ]);
  }
}
