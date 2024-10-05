import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final String? subtitle;  // Статус или последнее сообщение
  final String? time;      // Время последнего сообщения
  final bool isOnline;     // Статус доступности (онлайн или оффлайн)

  const UserTile({
    super.key,
    required this.text,
    this.onTap,
    this.subtitle,
    this.time,
    this.isOnline = false,  // По умолчанию пользователь оффлайн
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.5), // Линия разделения
          ),
        ),
        child: Row(
          children: [
            // Круглая аватарка с индикатором онлайн-статуса
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                // Индикатор онлайн-статуса
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.grey, // Цвет: зелёный = онлайн, серый = оффлайн
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white, // Граница для лучшего вида
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 16), // Отступ между аватаркой и текстом

            // Текстовая информация
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Имя пользователя
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Статус или последнее сообщение
                  Text(
                    subtitle ?? 'Статус недоступен', // Отображаем статус или текст по умолчанию
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Время последнего сообщения
            Text(
              time ?? "", // Отображаем время или пустую строку
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
