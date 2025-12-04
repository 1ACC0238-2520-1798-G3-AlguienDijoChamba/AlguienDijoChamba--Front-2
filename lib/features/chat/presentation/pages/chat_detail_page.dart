import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    final chat = args;

    // 💬 Lista de mensajes simulados (mock)
    final List<Map<String, dynamic>> messages = [
      {
        "fromMe": false,
        "text": "Hi David, have you got the project report pdf?",
        "time": "10:33 AM",
        "avatar": chat["image"],
      },
      {
        "fromMe": true,
        "text": "NO. I did not get it",
        "time": "10:34 AM",
        "avatar": "https://i.pravatar.cc/150?img=12",
      },
      {
        "date": "Yesterday"
      },
      {
        "fromMe": false,
        "text": "Ok, I will just send it here.\nPlease fill details by today.",
        "time": "10:36 AM",
        "avatar": chat["image"],
      },
      {
        "fromMe": true,
        "text": "Ok. Should I send it by email after filling the details?",
        "time": "10:40 AM",
        "avatar": "https://i.pravatar.cc/150?img=12",
      },
      {
        "fromMe": false,
        "text": "Ya. I'll be adding more team members.",
        "time": "10:42 AM",
        "avatar": chat["image"],
      },
      {
        "fromMe": true,
        "text": "OK",
        "time": "10:44 AM",
        "avatar": "https://i.pravatar.cc/150?img=12",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(chat['name']),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(chat['image']),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                if (msg.containsKey("date")) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        msg["date"],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }

                return _chatBubble(msg);
              },
            ),
          ),

          _inputBar(),
        ],
      ),
    );
  }

  Widget _chatBubble(Map msg) {
    final bool isMe = msg["fromMe"];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(msg["avatar"]),
            ),
          if (!isMe) const SizedBox(width: 6),

          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              msg["text"],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),

          if (isMe) const SizedBox(width: 6),
          if (isMe)
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(msg["avatar"]),
            ),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.link, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Write Something...",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.send, color: Colors.blue),
        ],
      ),
    );
  }
}
