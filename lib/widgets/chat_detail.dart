import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatDetailWidget extends StatefulWidget {
  @override
  _ChatDetailWidgetState createState() => _ChatDetailWidgetState();
}

class _ChatDetailWidgetState extends State<ChatDetailWidget> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUser = 'Usuario'; // Nombre del usuario, puedes hacerlo dinámico

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        await _firestore.collection('chats').add({
          'mensaje': _messageController.text,
          'hora': FieldValue.serverTimestamp(),
          'nombre': currentUser,
        });

        _messageController.clear();
      } catch (e) {
        print("Error al enviar el mensaje: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // ListView que mostrará los mensajes en tiempo real
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chats')
                  .orderBy('hora', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error al cargar los mensajes"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No hay mensajes aún"));
                }

                var mensajes = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return ListView.separated(
                  reverse: true, // Esto hará que los nuevos mensajes aparezcan al final
                  itemCount: mensajes.length,
                  itemBuilder: (context, index) {
                    var mensaje = mensajes[index];
                    bool isCurrentUser = mensaje['nombre'] == currentUser;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? Colors.teal[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mensaje['nombre'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCurrentUser ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              mensaje['mensaje'],
                              style: TextStyle(
                                fontSize: 16,
                                color: isCurrentUser ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              mensaje['hora']?.toDate().toString() ?? 'Sin hora',
                              style: TextStyle(
                                fontSize: 12,
                                color: isCurrentUser ? Colors.white70 : Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(height: 1),
                );
              },
            ),
          ),

          // Barra para enviar mensajes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Escribe un mensaje...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
