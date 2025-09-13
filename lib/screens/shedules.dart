import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("My Schedule"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Class List
            Expanded(
              child: ListView(
                children: const [
                  ClassCard(
                    icon: Icons.psychology,
                    title: "Introduction to Psychology",
                    time: "8:00 AM - 9:00 AM",
                    color: Colors.lightBlue,
                  ),
                  ClassCard(
                    icon: Icons.calculate,
                    title: "Calculus I",
                    time: "9:30 AM - 10:30 AM",
                    color: Colors.blueAccent,
                  ),
                  ClassCard(
                    icon: Icons.menu_book,
                    title: "English Composition",
                    time: "11:00 AM - 12:00 PM",
                    color: Colors.indigo,
                  ),
                  ClassCard(
                    icon: Icons.science,
                    title: "Physics I",
                    time: "1:00 PM - 2:00 PM",
                    color: Colors.blue,
                  ),
                  ClassCard(
                    icon: Icons.brush,
                    title: "History of Art",
                    time: "2:30 PM - 3:30 PM",
                    color: Colors.cyan,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.book), label: "Classes"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      // ),
    );
  }
}

// Reusable Class Card
class ClassCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final Color color;

  const ClassCard({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(time, style: TextStyle(color: Colors.grey[600])),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}