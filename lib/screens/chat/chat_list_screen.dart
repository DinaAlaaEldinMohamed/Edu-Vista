import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  static const String route = '/chat_list';

  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats available.'));
          }

          final chatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatData = chatDocs[index].data() as Map<String, dynamic>;
              final chatId = chatDocs[index].id;
              final chatName = chatData['name'] ?? 'Chat';

              return ListTile(
                title: Text(chatName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chatId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
