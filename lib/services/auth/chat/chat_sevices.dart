import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получение потока данных о пользователях из Firestore
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // Получение потока данных о сообщениях из Firestore
  Stream<List<Map<String, dynamic>>> getMessagesStream({required String chatId}) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // Отправка сообщения
  Future<void> sendMessage({
    required String chatId,
    required String senderEmail,
    required String receiverEmail,
    required String message,
  }) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'sender': senderEmail,
      'receiver': receiverEmail,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(), // Временная метка
    });
  }

  // Генерация идентификатора чата
  String generateChatId(String email1, String email2) {
    return email1.hashCode <= email2.hashCode
        ? '$email1\_$email2'
        : '$email2\_$email1';
  }
}
