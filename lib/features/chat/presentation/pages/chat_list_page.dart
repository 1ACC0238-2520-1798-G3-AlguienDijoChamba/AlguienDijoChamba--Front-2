import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chats = [
      {
        'name': 'Leonel Messi Farfan',
        'message': 'Hi, are you Available Tomorrow?',
        'time': '10:35 AM',
        'image': 'https://editorial.uefa.com/resources/0228-0e6709903f40-d4eb3c72d7a1-1000/lional_messi_barcelona_.jpeg'
      },
      {
        'name': 'Jamie Taylor',
        'message': 'Nice one. Will do it tomorrow',
        'time': '10:35 AM',
        'image': 'https://upload.wikimedia.org/wikipedia/commons/c/ca/Osama_bin_Laden_portrait.jpg'
      },
      {
        'name': 'Jason Roy',
        'message': 'That’s great. I am looking forward...',
        'time': '10:35 AM',
        'image': 'https://wallpapers.com/images/hd/kirby-pictures-6f3961bh9tvmntwq.jpg'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: chats.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final chat = chats[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/chat_detail',
                arguments: chat,
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: NetworkImage(chat['image']),
                  onBackgroundImageError: (_, __) {},
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        chat['message'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  chat['time'],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
