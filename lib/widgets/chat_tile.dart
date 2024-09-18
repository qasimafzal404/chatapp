import 'package:chatapp/models/user_profile.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  final UserProfile? userProfile;
  final Function()? onTap;
  const ChatTile({super.key, required this.userProfile, required this.onTap});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      dense: false,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(widget.userProfile!.pfpURL!),
      ),
      title: Text(widget.userProfile!.name!),
    );
  }
}
