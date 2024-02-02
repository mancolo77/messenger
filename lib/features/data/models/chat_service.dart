import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/features/data/models/message.dart';
class ChatService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentId = _auth.currentUser!.uid;
    final DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(currentId).get();
    final String currentUsername = userSnapshot['username'];
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        timestamp: timestamp,
        message: message,
        receiverId: receiverId,
        senderUsername: currentUsername,
        senderId: currentId);
      

    List<String> ids = [currentId,receiverId];
    ids.sort();
    String chatRoomId = ids.join(
      "_"
    );
    await _firestore
    .collection('chat_rooms')
    .doc(chatRoomId)
    .collection('message')
    .add(newMessage.toMap());
  }
  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("message")
        .orderBy('timestamp',descending: false)
        .snapshots();
}
   static String getConversationID(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join("_");
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String currentUserId, String otherUserId) {
      String chatRoomId = getConversationID(currentUserId, otherUserId);
      return FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("message")
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots();
      }
}