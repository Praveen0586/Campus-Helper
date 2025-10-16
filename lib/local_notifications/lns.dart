import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void initNotifications() {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Add your app icon here

  final InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(settings);
}

void listenToAnnouncements() {
  FirebaseFirestore.instance
      .collection('announcements')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .listen((snapshot) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        var data = change.doc.data();
        if (data != null) {
          showLocalNotification(
            title: data['title'] ?? 'New Announcement',
            body: data['details'] ?? '',
          );
        }
      }
    }
  });
}

Future<void> showLocalNotification(
    {required String title, required String body}) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'announcement_channel', // channel id
    'Announcements', // channel name
    channelDescription: 'Notification channel for announcements',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.show(
    0, // notification id
    title,
    body,
    platformDetails,
    payload: 'announcement_payload',
  );
}

void listenToPrivateChats({required String currentUserId}) {
  // Get the chat IDs relevant to the current user
  FirebaseFirestore.instance
      .collection('privateChats')
      .where('participants', arrayContains: currentUserId)
      .snapshots()
      .listen((chatsSnapshot) {
    for (var chatDoc in chatsSnapshot.docs) {
      String chatId = chatDoc.id;
      FirebaseFirestore.instance
          .collection('privateChats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((messagesSnapshot) {
        for (var change in messagesSnapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            var data = change.doc.data();
            if (data != null && data['senderId'] != currentUserId) {
              // Only notify if the current user did NOT send the message
              showLocalNotification(
                  title: 'New Message from ${data['senderName'] ?? ''}',
                  body: data['message'] ?? '');
            }
          }
        }
      });
    }
  });
}

// void listenToAnnouncements() {
//   FirebaseFirestore.instance
//       .collection('announcements')
//       .orderBy('timestamp', descending: true)
//       .snapshots()
//       .listen((snapshot) {
//     for (var change in snapshot.docChanges) {
//       if (change.type == DocumentChangeType.added) {
//         var data = change.doc.data();
//         if (data != null) {
//           showLocalNotification(
//               title: data['title'] ?? 'New Announcement',
//               body: data['details'] ?? '');
//         }
//       }
//     }
//   });
// }

// void listenToLostItems() {
//   FirebaseFirestore.instance
//       .collection('lostItems')
//       .orderBy('timestamp', descending: true)
//       .snapshots()
//       .listen((snapshot) {
//     for (var change in snapshot.docChanges) {
//       if (change.type == DocumentChangeType.added) {
//         var data = change.doc.data();
//         if (data != null) {
//           showLocalNotification(
//               title: data['title'] ?? 'Lost Item',
//               body: data['description'] ?? '');
//         }
//       }
//     }
//   });
// }

// void listenToFoundItems() {
//   FirebaseFirestore.instance
//       .collection('foundItems')
//       .orderBy('timestamp', descending: true)
//       .snapshots()
//       .listen((snapshot) {
//     for (var change in snapshot.docChanges) {
//       if (change.type == DocumentChangeType.added) {
//         var data = change.doc.data();
//         if (data != null) {
//           showLocalNotification(
//               title: data['title'] ?? 'Found Item',
//               body: data['description'] ?? '');
//         }
//       }
//     }
//   });
// }

void listenToLostItems({required String currentUserId}) {
  FirebaseFirestore.instance
      .collection('lostItems')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .listen((snapshot) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        var data = change.doc.data();
        if (data != null && data['creatorId'] != currentUserId) {
          showLocalNotification(
            title: data['title'] ?? 'Lost Item',
            body: data['description'] ?? ''
          );
        }
      }
    }
  });
}

void listenToFoundItems({required String currentUserId}) {
  FirebaseFirestore.instance
      .collection('foundItems')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .listen((snapshot) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        var data = change.doc.data();
        if (data != null && data['creatorId'] != currentUserId) {
          showLocalNotification(
            title: data['title'] ?? 'Found Item',
            body: data['description'] ?? ''
          );
        }
      }
    }
  });
}
