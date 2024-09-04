import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String route = '/chat';
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('ChatScreen'));
  }
}