import 'dart:io';
import 'package:chatapp/Services/database_service.dart';
import 'package:chatapp/Services/media_services.dart';
import 'package:chatapp/Services/storage_services.dart';
import 'package:chatapp/auth/auth_services.dart';
import 'package:chatapp/models/chat.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/models/user_profile.dart';
import 'package:chatapp/utils.dart';
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
  late MediaServices _mediaServices;
  late StorageServices _storageServices;
  @override
  void initState() {
    super.initState();
    _authServices = getit.get<AuthServices>();
    _databaseService = getit.get<DatabaseService>();
    _mediaServices = getit.get<MediaServices>();
    _storageServices = getit.get<StorageServices>();

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
        inputOptions:  InputOptions(
          alwaysShowSend: true,
          trailing: [
            _mediaMessageButton(),
          ]
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
    if(ChatMessage.medias?.isNotEmpty ?? false){
      if(ChatMessage.medias!.first.type == MediaType.image){
        Message message = Message(
          senderID: ChatMessage.user.id,
          content: ChatMessage.medias?.first.url,
          messageType: MessageType.Image,
          sentAt: Timestamp.fromDate(ChatMessage.createdAt),

        );
        await _databaseService.sendChatMessage(currentUser!.id, otherUser!.id, message);
      }
    }else{
 Message message = Message(
      senderID: currentUser!.id,
      content: ChatMessage.text,
      messageType: MessageType.Text,
      sentAt:Timestamp.fromDate(ChatMessage.createdAt),
    );
    await _databaseService.sendChatMessage(currentUser!.id, otherUser!.id, message, );
    }  
  }
List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
  List<ChatMessage> chatMessages = messages.map((m) {
    if (m.messageType == MessageType.Image) {
      return ChatMessage(
       user: m.senderID == currentUser!.id ? currentUser! : otherUser! , createdAt: m.sentAt!.toDate(),
       medias: [
        ChatMedia(url: m.content!, fileName: "", type: MediaType.image),
       ]

      );
    }else{
 return ChatMessage(user: m.senderID == currentUser!.id ? currentUser! : otherUser! ,
        text: m.content!, createdAt: m.sentAt!.toDate());
    }
   
  }).toList();
  chatMessages.sort((a,b){
    return b.createdAt!.compareTo(a.createdAt!);
  });
  return chatMessages;
}
Widget _mediaMessageButton(){
  return IconButton(onPressed: () async{
   File? file = await _mediaServices.getImageFromGallery();
   if(file != null){
      String chatID = generateChatID(uid1: currentUser!.id, uid2: otherUser!.id);
   String? downloadURL = await _storageServices.uploadImageToChat(file: file, chatID: chatID);
  if (downloadURL != null){
    ChatMessage chatMessage = ChatMessage(
      user: currentUser!, createdAt: DateTime.now(), medias:[
        ChatMedia(url: downloadURL, fileName: "", type: MediaType.image)
      ]
    );
   sendMessage(chatMessage);
  }
   }
  }, icon:Icon(Icons.image , color: Theme.of(context).colorScheme.primary,),);
}
}