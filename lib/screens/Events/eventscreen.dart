//   // import 'package:flutter/material.dart';

//   // class EventsPage extends StatelessWidget {
//   //   const EventsPage({super.key});

//   //   @override
//   //   Widget build(BuildContext context) {
//   //     return Scaffold(
//   //       appBar: AppBar(
//   //         title: const Text("Events"),
//   //         centerTitle: true,
//   //         // leading: IconButton(
//   //         //   icon: const Icon(Icons.menu),
//   //         //   onPressed: () {},
//   //         // ),
//   //         actions: [
//   //           IconButton(
//   //             icon: const Icon(Icons.search),
//   //             onPressed: () {},
//   //           ),
//   //         ],
//   //       ),
//   //       body: ListView(
//   //         padding: const EdgeInsets.all(12),
//   //         children: const [
//   //           EventCard(
//   //             imageUrl:
//   //                 "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/Blog-Banner-Fun-events-for-college-fest-1024x576.jpg",
//   //             title: "Campus Cleanup Day",
//   //             dateTime: "Oct 26, 2024 · 10:00 AM – 12:00 PM",
//   //             description:
//   //                 "Join us for a day of community service as we clean up our beautiful campus. Bring your friends and help make our school shine!",
//   //             location: "Campus Quad",
//   //           ),
//   //           EventCard(
//   //             imageUrl:
//   //                 "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/1_y3Hn36MbQ5JvJYXGZymxYA.jpg",
//   //             title: "Fall Formal",
//   //             dateTime: "Nov 15, 2024 · 7:00 PM – 9:00 PM",
//   //             description:
//   //                 "Get ready to dance the night away at our annual Fall Formal! Dress to impress and enjoy a night of music, food, and fun with your fellow students.",
//   //             location: "Student Union Ballroom",
//   //           ),
//   //           EventCard(
//   //             imageUrl:
//   //                 "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/pa3.jpg",
//   //             title: "Holiday Concert",
//   //             dateTime: "Dec 5, 2024 · 6:00 PM – 8:00 PM",
//   //             description:
//   //                 "Celebrate the holiday season with a festive concert featuring our talented student musicians. Enjoy classic carols and holiday favorites.",
//   //             location: "Auditorium",
//   //           ),
//   //         ],
//   //       ),
//   //       // bottomNavigationBar: BottomNavigationBar(
//   //       //   currentIndex: 1,
//   //       //   items: const [
//   //       //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//   //       //     BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
//   //       //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//   //       //   ],
//   //       // ),
//   //     );
//   //   }
//   // }

//   // class EventCard extends StatelessWidget {
//   //   final String imageUrl;
//   //   final String title;
//   //   final String dateTime;
//   //   final String description;
//   //   final String location;

//   //   const EventCard({
//   //     super.key,
//   //     required this.imageUrl,
//   //     required this.title,
//   //     required this.dateTime,
//   //     required this.description,
//   //     required this.location,
//   //   });

//   //   @override
//   //   Widget build(BuildContext context) {
//   //     return Card(
//   //       margin: const EdgeInsets.only(bottom: 16),
//   //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//   //       elevation: 3,
//   //       child: Column(
//   //         crossAxisAlignment: CrossAxisAlignment.start,
//   //         children: [
//   //           ClipRRect(
//   //             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//   //             child: Image.network(
//   //               imageUrl,
//   //               height: 150,
//   //               width: double.infinity,
//   //               fit: BoxFit.cover,
//   //             ),
//   //           ),
//   //           Padding(
//   //             padding: const EdgeInsets.all(12),
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 Text(title,
//   //                     style: const TextStyle(
//   //                         fontSize: 16, fontWeight: FontWeight.bold)),
//   //                 const SizedBox(height: 4),
//   //                 Text(dateTime,
//   //                     style: TextStyle(color: Colors.grey[600], fontSize: 13)),
//   //                 const SizedBox(height: 8),
//   //                 Text(description, style: const TextStyle(fontSize: 14)),
//   //                 const SizedBox(height: 8),
//   //                 Row(
//   //                   children: [
//   //                     const Icon(Icons.location_on, size: 16, color: Colors.grey),
//   //                     const SizedBox(width: 4),
//   //                     Text(location, style: TextStyle(color: Colors.grey[700])),
//   //                   ],
//   //                 ),
//   //                 const SizedBox(height: 12),
//   //                 Row(
//   //                   children: [
//   //                     Expanded(
//   //                       child: ElevatedButton(
//   //                         onPressed: () {},
//   //                         style: ElevatedButton.styleFrom(
//   //                           backgroundColor: Colors.blue,
//   //                           shape: RoundedRectangleBorder(
//   //                               borderRadius: BorderRadius.circular(8)),
//   //                         ),
//   //                         child: const Text("RSVP"),
//   //                       ),
//   //                     ),
//   //                     const SizedBox(width: 8),
//   //                     Expanded(
//   //                       child: OutlinedButton(
//   //                         onPressed: () {},
//   //                         style: OutlinedButton.styleFrom(
//   //                           shape: RoundedRectangleBorder(
//   //                               borderRadius: BorderRadius.circular(8)),
//   //                         ),
//   //                         child: const Text("Add to Calendar"),
//   //                       ),
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     );
//   //   }
//   // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';

// class EventsPage extends StatelessWidget {
//   const EventsPage({Key? key}) : super(key: key);
//   String formatEventDateSimple(Timestamp start, Timestamp end) {
//     // Convert Firestore Timestamp to Dart DateTime
//     final DateTime startDate = start.toDate();
//     final DateTime endDate = end.toDate();

//     // Format: MMM dd, yyyy - hh:mm AM/PM
//     String pad2(int n) => n < 10 ? '0$n' : '$n';
//     String mon(int m) => [
//           'Jan',
//           'Feb',
//           'Mar',
//           'Apr',
//           'May',
//           'Jun',
//           'Jul',
//           'Aug',
//           'Sep',
//           'Oct',
//           'Nov',
//           'Dec'
//         ][m - 1];
//     String hour12(int h) => h == 0
//         ? '12'
//         : h > 12
//             ? '${h - 12}'
//             : '$h';
//     String ampm(int h) => h < 12 ? 'AM' : 'PM';

//     String sMonth = mon(startDate.month);
//     String sDay = pad2(startDate.day);
//     String sYear = startDate.year.toString();
//     String sHour = hour12(startDate.hour);
//     String sMin = pad2(startDate.minute);
//     String sAmPm = ampm(startDate.hour);

//     String eMonth = mon(endDate.month);
//     String eDay = pad2(endDate.day);
//     String eYear = endDate.year.toString();
//     String eHour = hour12(endDate.hour);
//     String eMin = pad2(endDate.minute);
//     String eAmPm = ampm(endDate.hour);

//     // If on same day:
//     if (sYear == eYear && sMonth == eMonth && sDay == eDay) {
//       return "$sMonth $sDay, $sYear • $sHour:$sMin $sAmPm - $eHour:$eMin $eAmPm";
//     }
//     // Different day:
//     return "$sMonth $sDay, $sYear $sHour:$sMin $sAmPm - $eMonth $eDay, $eYear $eHour:$eMin $eAmPm";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final eventStream = FirebaseFirestore.instance
//         .collection('events')
//         .orderBy('startTime', descending: false)
//         .snapshots();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Events"),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: eventStream,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final events = snapshot.data!.docs;
//           if (events.isEmpty) {
//             return const Center(child: Text("No events found"));
//           }
//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: events.length,
//             itemBuilder: (context, idx) {
//               final doc = events[idx];
//               final data = doc.data() as Map<String, dynamic>;
//               final String title = data['title'] ?? '';
//               final String desc = data['description'] ?? '';
//               final String location = data['location'] ?? '';
//               final String bannerUrl = data['bannerUrl'] ?? '';
//               final Timestamp startTime = data['startTime'];
//               final Timestamp endTime = data['endTime'];
//               return Card(
//                 margin: const EdgeInsets.only(bottom: 18),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12)),
//                 elevation: 4,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (bannerUrl.isNotEmpty)
//                       ClipRRect(
//                         borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(12)),
//                         child: Image.network(bannerUrl,
//                             height: 130,
//                             width: double.infinity,
//                             fit: BoxFit.cover),
//                       ),
//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(title,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16)),
//                           const SizedBox(height: 6),
//                           Text(formatEventDateSimple(startTime, endTime),
//                               style: const TextStyle(
//                                   color: Colors.grey, fontSize: 13)),
//                           const SizedBox(height: 10),
//                           Text(desc, style: const TextStyle(fontSize: 14)),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               const Icon(Icons.location_on_outlined,
//                                   color: Colors.grey, size: 18),
//                               const SizedBox(width: 4),
//                               Expanded(
//                                   child: Text(location,
//                                       style: const TextStyle(
//                                           color: Colors.grey, fontSize: 13))),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     // TODO: RSVP Logic
//                                   },
//                                   child: const Text("RSVP"),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: OutlinedButton(
//                                   onPressed: () {
//                                     // TODO: Add to Calendar Logic
//                                   },
//                                   child: const Text("Add to Calendar"),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Reuse AnnouncementCard above

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testFirestore();

  
  }

  String formatDate(Timestamp timestamp) {
    final dt = timestamp.toDate();
    return "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
  }

  void testFirestore() async {
    final snapshots =
        await FirebaseFirestore.instance.collection('announcements').get();
    print('Announcement count: ${snapshots.size}');
  }

  @override
  Widget build(BuildContext context) {
    final announcementStream = FirebaseFirestore.instance
        .collection('announcements')
        .orderBy('important', descending: true)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String title = '';
              String details = '';
              bool important = false;

              return AlertDialog(
                title: Text('Add Announcement'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Title'),
                        onChanged: (val) => title = val,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Details'),
                        maxLines: 2,
                        onChanged: (val) => details = val,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: important,
                            onChanged: (val) {
                              important = val ?? false;
                              (context as Element)
                                  .markNeedsBuild(); // hotfix for dialog rebuild
                            },
                          ),
                          Text('Important'),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (title.trim().isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('announcements')
                            .add({
                          'title': title,
                          'details': details,
                          'important': important,
                          'timestamp': Timestamp.now(),
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
      appBar: AppBar(
        title: const Text('Announcements'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: announcementStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No announcements found."));
          }
          final docs = snapshot.data!.docs;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return AnnouncementCard(
                title: data['title'] ?? '',
                details: data['details'] ?? '',
                important: data['important'] ?? false,
                date: data['timestamp'] != null
                    ? formatDate(data['timestamp'])
                    : '',
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String details;
  final bool important;
  final String date;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.details,
    required this.important,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: important ? Colors.yellow[100] : Colors.blueGrey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  important
                      ? Icons.announcement_rounded
                      : Icons.campaign_outlined,
                  color: important ? Colors.orange : Colors.blueGrey,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: important ? Colors.orange[900] : Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              details,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
