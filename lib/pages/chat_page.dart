import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/models/chat.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatefulWidget {
  final UserProfile chatuser;
  const ChatPage({super.key, required this.chatuser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GetIt getit = GetIt.instance;
  late AuthServices _authServices;
  ChatUser? currentUser, otherUser;
  late DatabaseService _databaseService;
  @override
  void initState() {
    super.initState();
    _authServices = getit.get<AuthServices>();
    _databaseService = getit.get<DatabaseService>();
    currentUser = ChatUser(
      id: _authServices.user()!.uid,
      firstName: _authServices.user()!.displayName,
    );
    otherUser = ChatUser(
      id: widget.chatuser.uid!,
      firstName: _authServices.user()!.displayName,
      profileImage: widget.chatuser.pfpURL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatuser.name!),
      ),
      body: _buildUI(),
    );
  }

 Widget _buildUI() {
  return StreamBuilder(
    stream: _databaseService.getChatData(currentUser!.id, otherUser!.id),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }

      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }

      if (!snapshot.hasData) {
        return Text('No chat data available');
      }

      // Print snapshot data for debugging
      print('Chat data: ${snapshot.data}');

      Chat? chat = snapshot.data?.data(); // Ensure this is returning a `Chat` object
      List<ChatMessage>? messages = [];

      if (chat != null && chat.messages != null) {
        messages = _generateChatMessagesList(chat.messages!);
      }

      return DashChat(
        messageOptions: const MessageOptions(
          showOtherUsersAvatar: true,
          showTime: true,
        ),
        inputOptions: const InputOptions(
          alwaysShowSend: true,
        ),
        currentUser: currentUser!,
        onSend: (message) {
          sendMessage(message); // Call sendMessage on user input
        },
        messages: messages,
      );
    },
  );
}

  Future<void>sendMessage(ChatMessage ChatMessage) async{
    Message message = Message(
      senderID: currentUser!.id,
      content: ChatMessage.text,
      messageType: MessageType.Text,
      sentAt:Timestamp.fromDate(ChatMessage.createdAt),
    );
    await _databaseService.sendChatMessage(currentUser!.id, otherUser!.id, message, );
    
  }
List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
  List<ChatMessage> chatMessages = messages.map((m) {
    return ChatMessage(user: m.senderID == currentUser!.id ? currentUser! : otherUser! ,
        text: m.content!, createdAt: m.sentAt!.toDate());
  }).toList();
  chatMessages.sort((a,b){
    return b.createdAt!.compareTo(a.createdAt!);
  });
  return chatMessages;
}
}