import 'package:flutter/material.dart';
import 'package:untitled2/services/auth/chat/chat_sevices.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Импортируйте этот пакет

class ChatPage extends StatefulWidget {
  final String receiverEmail;

  const ChatPage({
    super.key,
    required this.receiverEmail,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  late String _currentUserEmail; // Объявляем переменную для email

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail(); // Получаем email текущего пользователя при инициализации
  }

  // Метод для получения email текущего пользователя
  void _getCurrentUserEmail() {
    User? user = FirebaseAuth.instance.currentUser; // Получаем текущего пользователя
    if (user != null) {
      _currentUserEmail = user.email ?? "unknown@example.com"; // Получаем email или ставим значение по умолчанию
    } else {
      _currentUserEmail = "unknown@example.com"; // Если пользователь не найден, ставим значение по умолчанию
    }
  }

  @override
  Widget build(BuildContext context) {
    String chatId = _chatService.generateChatId(_currentUserEmail, widget.receiverEmail);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatService.getMessagesStream(chatId: chatId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Ошибка загрузки сообщений'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  reverse: true,
                  children: snapshot.data!.map((messageData) {
                    bool isSender = messageData['sender'] == _currentUserEmail;
                    return _buildMessageBubble(messageData, isSender);
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      await _chatService.sendMessage(
                        chatId: chatId,
                        senderEmail: _currentUserEmail,
                        receiverEmail: widget.receiverEmail,
                        message: _messageController.text,
                      );

                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Метод для построения сообщения
  Widget _buildMessageBubble(Map<String, dynamic> messageData, bool isSender) {
    if (messageData['timestamp'] == null) {
      return const SizedBox(); // Возвращаем пустой контейнер, если timestamp отсутствует
    }

    Timestamp timestamp = messageData['timestamp'];
    String formattedTime = DateFormat('HH:mm').format(timestamp.toDate());
    String email = isSender ? _currentUserEmail : widget.receiverEmail; // Email отправителя

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            email, // Email отправителя
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSender ? Colors.lightBlueAccent : Colors.black,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isSender) ...[
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(widget.receiverEmail[0].toUpperCase()), // Первая буква имени собеседника
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.lightBlueAccent : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        messageData['message'],
                        style: TextStyle(color: isSender ? Colors.white : Colors.black),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: isSender ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isSender) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.lightBlueAccent,
                  child: Text(_currentUserEmail[0].toUpperCase()), // Первая буква вашего имени
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
