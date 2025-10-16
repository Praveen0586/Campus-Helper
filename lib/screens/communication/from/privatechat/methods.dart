import 'package:cloud_firestore/cloud_firestore.dart';

String getChatId(String userId1, String userId2) {
  List<String> ids = [userId1, userId2];
  ids.sort();
  return ids.join('_');
}

Future<void> sendMessage({
  required String chatId,
  required String senderId,
  required String senderName,
  required String message,
  required String receiverId,
}) async {
  DocumentReference chatDoc =
      FirebaseFirestore.instance.collection('privateChats').doc(chatId);
  CollectionReference messagesCol = chatDoc.collection('messages');

  final timestamp = FieldValue.serverTimestamp();

  // Add new message document to messages subcollection
  await messagesCol.add({
    'senderId': senderId,
    'senderName': senderName,
    'message': message,
    'timestamp': timestamp,
    'isRead': false,
  });

  // Update chat info in chat document
  await chatDoc.set({
    'participants': chatId.split(
        '_'), // Chat ID is joined by _, but are these always equal to user IDs?
    'lastMessage': message,
    'lastMessageTime': timestamp,
    'unreadCount': {receiverId: FieldValue.increment(1)},
  }, SetOptions(merge: true));
}

Stream<QuerySnapshot> getMessagesStream(String chatId) {
  return FirebaseFirestore.instance
      .collection('privateChats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
}

Future<void> markMessagesAsRead(String chatId, String currentUserId) async {
  final chatDoc =
      FirebaseFirestore.instance.collection('privateChats').doc(chatId);

  // Reset unread count for current user
  await chatDoc.set({
    'unreadCount': {currentUserId: 0}
  }, SetOptions(merge: true));

  // Mark unread messages from other user as read
  final messagesSnap = await chatDoc
      .collection('messages')
      .where('isRead', isEqualTo: false)
      .where('senderId', isNotEqualTo: currentUserId)
      .get();

  final batch = FirebaseFirestore.instance.batch();
  for (var doc in messagesSnap.docs) {
    batch.update(doc.reference, {'isRead': true});
  }
  await batch.commit();
}
