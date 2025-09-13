import 'package:flutter/material.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> channels = [
    {
      "title": "General",
      "subtitle": "General discussions and campus updates",
    },
    {
      "title": "Departments",
      "subtitle": "Academic departments and faculty",
    },
    {
      "title": "Clubs",
      "subtitle": "Student clubs and organizations",
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Communication"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: "Channels"),
            Tab(text: "Private Chat"),
            Tab(text: "Announcements"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Channels Tab
          ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tag, color: Colors.blue),
                  ),
                  title: Text(
                    channel["title"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(channel["subtitle"] ?? ""),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    // TODO: Navigate to channel chat screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Opening ${channel['title']}...")),
                    );
                  },
                ),
              );
            },
          ),

          // Private Chat Tab
          const Center(
            child: Text(
              "Private Chats will appear here",
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Announcements Tab
          const Center(
            child: Text(
              "Announcements will appear here",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Communication selected
        onTap: (index) {
          // TODO: Implement navigation to other screens
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat), label: "Communication"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Lost & Found"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
