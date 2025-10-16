import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_project/datas/userdatas/constants.dart';
// import 'package:hackathon_project/screens/communication/department_chat_screen.dart';
import 'package:hackathon_project/screens/communication/from/sd.dart';
import 'package:hackathon_project/screens/communication/from/se.dart';
// import 'package:hackathon_project/screens/communication/general_chat_screen.dart';
// import 'package:hackathon_project/screens/communication/firestore_chat_screen.dart';
// import 'package:hackathon_project/screens/communication/searchusersscreen.dart';

class CommunicationScreen2 extends StatefulWidget {
  const CommunicationScreen2({super.key});

  @override
  State<CommunicationScreen2> createState() => _CommunicationScreen2State();
}

class _CommunicationScreen2State extends State<CommunicationScreen2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Generate chat ID from two user IDs
  String getChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ucollegeid.value;
    final userYear = uyear.value; // e.g., "2024-2026"
    final userDep = udepartment.value; // e.g., "MCA-II"

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     CollectionReference announcements =
      //         FirebaseFirestore.instance.collection('announcements');

      //     await announcements.add({
      //       'title': 'Diwali 2025 - Festival of Lights',
      //       'message':
      //           'Diwali 2025 will be celebrated on October 20th. It is a festival symbolizing the victory of light over darkness. Families and friends gather to perform Lakshmi Puja, celebrate, and share happiness. Homes are decorated with lamps and colorful rangoli. Wishing everyone a joyful Diwali!',
      //       'timestamp': FieldValue.serverTimestamp(),
      //       'author': 'Admin',
      //       'priority': 'info',
      //       'targetAudience': ['all'],
      //       'isActive': true,
      //       'expiryDate': Timestamp.fromDate(
      //           DateTime(2025, 10, 22)), // after festival days
      //       'attachments': [
      //         "https://th.bing.com/th/id/OIP.GpnixmeKXgKt0K5yS8BBfAHaEK?w=321&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3",
      //       ],
      //       'readBy': [],
      //     });
      //   },
      // ),
      appBar: AppBar(
        title: const Text("Communication"),
        centerTitle: true,
        actions: [
          if (_tabController.index == 2)
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchUsersScreen(),
                  ),
                );
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black.withOpacity(0.6),
          indicatorColor: Colors.blue,
          onTap: (index) {
            setState(() {});
          },
          tabs: const [
            Tab(text: "College"),
            Tab(text: "Department"),
            Tab(text: "Private Chat"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ========== COLLEGE-WIDE COMMUNICATION ==========
          _buildGeneralCommunication(),

          // ========== DEPARTMENT COMMUNICATION ==========
          _buildDepartmentCommunication(userYear, userDep),

          // ========== PRIVATE CHAT ==========
          _buildPrivateChats(currentUserId),
        ],
      ),
    );
  }

  // College-wide general communication

  Widget _buildGeneralCommunication() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('announcements')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.campaign,
            title: "No announcements yet",
            subtitle: "College-wide announcements will appear here",
          );
        }

        return buildAnnouncementsList(snapshot);
      },
    );
  }

  Widget buildAnnouncementsList(AsyncSnapshot<QuerySnapshot> snapshot) {
    String formatTimestamp(DateTime date) {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();

      final hour12 = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final ampm = date.hour >= 12 ? 'PM' : 'AM';

      return '$day/$month/$year, $hour12:$minute $ampm';
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.data!.docs[index];
        final data = doc.data() as Map<String, dynamic>;

        final title = data['title'] ?? 'No Title';
        final message = data['message'] ?? '';
        final author = data['author'] ?? 'Unknown';
        final priority = data['priority'] ?? 'info';
        final targetAudience = List<String>.from(data['targetAudience'] ?? []);
        final isActive = data['isActive'] ?? true;
        final expiryDate = data['expiryDate'] as Timestamp?;
        final attachments = List<String>.from(data['attachments'] ?? []);
        final timestamp = data['timestamp'] as Timestamp?;

        // Use manual formatting instead of intl
        final formattedTime =
            timestamp != null ? formatTimestamp(timestamp.toDate()) : 'No date';

        if (!isActive) return SizedBox.shrink(); // Hide inactive announcements

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and priority badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _priorityColor(priority),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(priority.toUpperCase(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Text(message, style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),

                // Attachments, if any
                if (attachments.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: attachments.map((url) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              child: InteractiveViewer(
                             panEnabled: true,  // Allow panning (dragging)
  minScale: 1,       // Minimum zoom scale (no zoom)
  maxScale: 4,  // Max zoom scale
                                child: Image.network(url),
                              ),
                            ),
                          );
                          // Optionally open URL
                        },
                        child: Image.network(
                          url,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                SizedBox(height: 8),

                // Author and timestamp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('By $author',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic)),
                    Text(formattedTime,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Department-specific communication
  Widget _buildDepartmentCommunication(String year, String department) {
    if (year.isEmpty || department.isEmpty) {
      return _buildEmptyState(
        icon: Icons.info_outline,
        title: "Department not set",
        subtitle: "Please update your profile with department info",
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(year)
          .doc(department)
          .collection('communication')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            children: [
              Expanded(
                child: _buildEmptyState(
                  icon: Icons.forum,
                  title: "No messages yet",
                  subtitle: "Start the conversation with your classmates",
                ),
              ),
              _buildMessageInputBar(year, department),
            ],
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                reverse: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final senderId = data['senderId'] ?? '';
                  final isMe = senderId == ucollegeid.value;

                  return _buildMessageCard(
                    senderName: data['senderName'] ?? 'Unknown',
                    senderImage: data['senderImage'] ??
                        'https://via.placeholder.com/150',
                    message: data['message'] ?? '',
                    timestamp: data['timestamp'] as Timestamp?,
                    isMe: isMe,
                  );
                },
              ),
            ),
            _buildMessageInputBar(year, department),
          ],
        );
      },
    );
  }

  Widget _buildPrivateChats(String currentUserId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('privateChats')
          .where('participants', arrayContains: currentUserId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.chat_bubble_outline,
            title: "No conversations yet",
            subtitle: "Start a conversation with your classmates",
            actionButton: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchUsersScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text("Find Students"),
            ),
          );
        }

        // Debug
        print('Docs count: ${snapshot.data!.docs.length}');
        snapshot.data!.docs.forEach((doc) {
          print('Chat doc data: ${doc.data()}');
        });

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final chatDoc = snapshot.data!.docs[index];
            final chatData = chatDoc.data() as Map<String, dynamic>;
            final participants =
                List<String>.from(chatData['participants'] ?? []);

            final otherUserId = participants.firstWhere(
              (id) => id != currentUserId,
              orElse: () => '',
            );
            print("[Chat List] Looking up user: $otherUserId");

            if (otherUserId.isEmpty) return const SizedBox.shrink();

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(otherUserId)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    leading: CircleAvatar(),
                    title: Text("Loading..."),
                  );
                }

                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person_off)),
                    title: const Text("Unknown User"),
                    subtitle: const Text("User info not available"),
                  );
                }

                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>?;

                final userName = userData?['name'] ?? 'Unknown';
                final userImage =
                    userData?['img'] ?? 'https://via.placeholder.com/150';
                final lastMessage = chatData['lastMessage'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(userImage),
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FirestoreChatScreen(
                            receiverId: otherUserId,
                            receiverName: userName,
                            receiverImage: userImage,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Message card widget
  Widget _buildMessageCard({
    required String senderName,
    required String senderImage,
    required String message,
    required Timestamp? timestamp,
    bool isMe = false,
    bool isGeneral = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(senderImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            senderName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          if (isMe)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "You",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (timestamp != null)
                        Text(
                          _formatTimestamp(timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Message input bar for department chat
  Widget _buildMessageInputBar(String year, String department) {
    final TextEditingController controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () async {
                if (controller.text.trim().isEmpty) return;

                final message = controller.text.trim();
                controller.clear();

                try {
                  await FirebaseFirestore.instance
                      .collection(year)
                      .doc(department)
                      .collection('communication')
                      .add({
                    'senderId': ucollegeid.value,
                    'senderName': uName.value,
                    'senderImage': uimage.value,
                    'message': message,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to send: $e")),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? actionButton,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          if (actionButton != null) ...[
            const SizedBox(height: 16),
            actionButton,
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

Color _priorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'alert':
      return Colors.red;
    case 'update':
      return Colors.blue;
    case 'info':
    default:
      return Colors.green;
  }
}
