import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat2025/models/ChatModel.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveMessage(String userId, ChatModel message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(userId)
          .collection('messages')
          .add({
            'msg': message.msg,
            'chatIndex': message.chatIndex,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatModel>> getChatHistory(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('chats')
              .doc(userId)
              .collection('messages')
              .orderBy('timestamp', descending: false)
              .get();

      return querySnapshot.docs.map((doc) {
        return ChatModel(msg: doc['msg'], chatIndex: doc['chatIndex']);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
