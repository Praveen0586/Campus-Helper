import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/datas/userdatas/constants.dart';
import 'package:hackathon_project/screens/communication/from/privatechat/methods.dart';
import 'package:flutter/material.dart';
class PrivateChatScreen extends StatelessWidget {
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserImage;

  PrivateChatScreen({
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserImage,
  });

  late final String chatId = getChatId(currentUserId, otherUserId);
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(otherUserName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getMessagesStream(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final messages = snapshot.data!.docs;
                return ListView(
                  children: messages.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final isMe = data['senderId'] == currentUserId;
                    return ListTile(
                      title: Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[300] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(data['message'] ?? ''),
                        ),
                      ),
                      subtitle: Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Text(data['senderName'] ?? ''),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),

          // Message input
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(
                        chatId: chatId,
                        senderId: currentUserId,
                        senderName: uName.value
                        , // Replace with actual user name
                        message: message,
                        receiverId: otherUserId,
                      );
                      _messageController.clear();
                      markMessagesAsRead(chatId, currentUserId);
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
