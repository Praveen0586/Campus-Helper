import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  final String channelId;
  ChatScreen({required this.channelId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(channelId)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('communication')
                  .doc(channelId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                if (!chatSnapshot.hasData) return CircularProgressIndicator();
                return ListView(
                  children: chatSnapshot.data!.docs.map((doc) {
                    return ListTile(
                      title: Text(doc['content']),
                      subtitle: Text(doc['senderId']),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          // Message input row here (same as in previous examples)
        ],
      ),
    );
  }
}
