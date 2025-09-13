import 'package:flutter/material.dart';


class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {},
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          EventCard(
            imageUrl:
                "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/Blog-Banner-Fun-events-for-college-fest-1024x576.jpg",
            title: "Campus Cleanup Day",
            dateTime: "Oct 26, 2024 · 10:00 AM – 12:00 PM",
            description:
                "Join us for a day of community service as we clean up our beautiful campus. Bring your friends and help make our school shine!",
            location: "Campus Quad",
          ),
          EventCard(
            imageUrl:
                "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/1_y3Hn36MbQ5JvJYXGZymxYA.jpg",
            title: "Fall Formal",
            dateTime: "Nov 15, 2024 · 7:00 PM – 9:00 PM",
            description:
                "Get ready to dance the night away at our annual Fall Formal! Dress to impress and enjoy a night of music, food, and fun with your fellow students.",
            location: "Student Union Ballroom",
          ),
          EventCard(
            imageUrl:
                "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/pa3.jpg",
            title: "Holiday Concert",
            dateTime: "Dec 5, 2024 · 6:00 PM – 8:00 PM",
            description:
                "Celebrate the holiday season with a festive concert featuring our talented student musicians. Enjoy classic carols and holiday favorites.",
            location: "Auditorium",
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      // ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dateTime;
  final String description;
  final String location;

  const EventCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.dateTime,
    required this.description,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(dateTime,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location, style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("RSVP"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Add to Calendar"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
