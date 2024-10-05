import 'package:flutter/material.dart';
import 'package:untitled2/components/user_tile.dart';
import 'package:untitled2/components/my_drawer.dart';
import 'package:untitled2/services/auth/chat/chat_sevices.dart';
import '../services/auth/auth_services.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // Построение списка пользователей
  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUsersStream(),  // Получение потока пользователей
      builder: (context, snapshot) {
        // Обработка ошибок
        if (snapshot.hasError) {
          return const Center(child: Text('Ошибка'));
        }
        // Отображение индикатора загрузки
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentUserEmail = _authServices.getCurrentUserEmail(); // Получаем email текущего пользователя

        // Фильтрация пользователей, исключая текущего
        final filteredUsers = snapshot.data!.where((userData) => userData["email"] != currentUserEmail).toList();

        return ListView(
          children: filteredUsers.map<Widget>(
                (userData) => _buildUserListItem(userData, context),
          ).toList(),
        );
      },
    );
  }

  // Создание элемента списка для пользователя
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    return UserTile(
      text: userData["email"],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData["email"],
            ),
          ),
        );
      },
    );
  }
}
