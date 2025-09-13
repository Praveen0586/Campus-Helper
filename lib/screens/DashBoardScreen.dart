import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackathon_project/screens/communicationscreen.dart';
import 'package:hackathon_project/screens/eventscreen.dart';
import 'package:hackathon_project/screens/lostandfoundscree.dart';
import 'package:hackathon_project/screens/notesscreen.dart';
import 'package:hackathon_project/screens/pdfupload.dart';
import 'package:hackathon_project/screens/pdfupload2.dart';
import 'package:hackathon_project/screens/profilescreen.dart';
import 'package:hackathon_project/screens/raisequestionscreen.dart';
import 'package:hackathon_project/screens/reportscreen.dart';
import 'package:hackathon_project/screens/shedules.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Homescreen(), // ✅ Make sure spelling matches your class
    EventsPage(),
    ProfilePage(),
    // SchedulePage(),    // ✅ Separate widget instead of Center()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed, // ✅ avoids shifting on 4 items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.schedule_outlined),
          //   label: "Schedule",
          // ),
        ],
      ),
    );
  }
}

/// Reusable Action Card Widget
Widget buildActionCard(
    IconData icon, String title, Color color, Function ontaps) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 2,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        ontaps();
        // Navigate to respective page
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Section (User info + Settings)
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ProfilePage();
                      },
                    ));
                  },
                  child: CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                      "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/IMG_20240125_000057%5B1%5D.jpg",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome back,",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ProfilePage();
                      },
                    ));
                  },
                  icon: const Icon(Icons.settings, color: Colors.black54),
                )
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// Quick Action Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  buildActionCard(Icons.description_outlined,
                      "Notes & Syllabus", Colors.blue, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotesScreen()),
                    );
                  }),
                  buildActionCard(
                      Icons.chat_bubble_outline, "Communication", Colors.green,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CommunicationScreen()),
                    );
                  }),
                  buildActionCard(Icons.search, "Lost & Found", Colors.amber,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LostAndFoundScreen()),
                    );
                  }),
                  buildActionCard(
                      Icons.report_problem_outlined, "Report Issue", Colors.red,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReportIssueScreen()),
                    );
                  }),
                  buildActionCard(
                      Icons.school_outlined, "My Classes", Colors.indigo, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SchedulePage()),
                    );
                  }),
                  buildActionCard(Icons.event_outlined, "Events", Colors.purple,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EventsPage()),
                    );
                  }),
                  // buildActionCard(Icons.schedule_outlined, "Schesules",
                  //     Colors.redAccent, () {}),
                  buildActionCard(Icons.chat, "AI - Ask", Colors.orange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FlashcardsScreen()),
                    );
                  }),
                  buildActionCard(Icons.chat, "AI - Flash", Colors.orange, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PDFUpload()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
