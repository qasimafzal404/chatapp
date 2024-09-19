import 'package:chatapp/models/message.dart'; // Correct the import path

class Chat {
  String? id;
  List<String>? participants;
  List<Message>? messages;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  // Deserialize from JSON
  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List<String>.from(json['participants']);
    messages = (json['messages'] as List<dynamic>).map((m) => Message.fromJson(m as Map<String, dynamic>)).toList();
  }

  // Serialize to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; // Proper map initialization
    data['id'] = id;
    data['participants'] = participants;
    // Handle null messages list
    data['messages'] = messages?.map((m) => m.toJson()).toList() ?? [];
    return data;
  }
}
