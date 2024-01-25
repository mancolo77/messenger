import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ChatBubble extends StatelessWidget {
  final String message;
  final String senderId; // New parameter for sender's ID

  const ChatBubble({super.key, required this.message, required this.senderId});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = senderId == FirebaseAuth.instance.currentUser!.uid;
    final textColor = isCurrentUser ? const Color(0xFF00521B) : Colors.black;
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 12, bottom: 8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: isCurrentUser ? const Color(0xFF3BEC78) : Colors.grey[300],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

