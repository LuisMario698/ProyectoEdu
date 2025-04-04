import 'package:flutter/material.dart';
import 'chat_detail.dart'; // Importa el widget de detalle del chat

class ChatsWidget extends StatelessWidget {
  final List<Map<String, String>> chats = List.generate(
    50,
    (index) => {
      "name": "Usuario ${index + 1}",
      "message": "Este es un mensaje de prueba del usuario ${index + 1}.",
      "time": "${10 + (index % 12)}:${index % 60} ${index % 2 == 0 ? 'AM' : 'PM'}"
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(child: Text(chat["name"]![0])),
            title: Text(chat["name"]!),
            subtitle: Text(chat["message"]!),
            trailing: Text(
              chat["time"]!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
            },
          );
        },
      ),
    );
  }
}

class ChatDetailWidget extends StatelessWidget {
  final String chatName;

  ChatDetailWidget({required this.chatName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat de $chatName'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mensaje:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Este es un mensaje de prueba del usuario $chatName.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Hora: 10:00 AM',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
