// import 'package:flutter/material.dart';

// class OrderSchedulePage extends StatelessWidget {
//   const OrderSchedulePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         title: const Text("My Schedule"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_today_outlined),
//             onPressed: () {},
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Today",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             // Class List
//             Expanded(
//               child: ListView(
//                 children: const [
//                   ClassCard(
//                     icon: Icons.psychology,
//                     title: "Introduction to Psychology",
//                     time: "8:00 AM - 9:00 AM",
//                     color: Colors.lightBlue,
//                   ),
//                   ClassCard(
//                     icon: Icons.calculate,
//                     title: "Calculus I",
//                     time: "9:30 AM - 10:30 AM",
//                     color: Colors.blueAccent,
//                   ),
//                   ClassCard(
//                     icon: Icons.menu_book,
//                     title: "English Composition",
//                     time: "11:00 AM - 12:00 PM",
//                     color: Colors.indigo,
//                   ),
//                   ClassCard(
//                     icon: Icons.science,
//                     title: "Physics I",
//                     time: "1:00 PM - 2:00 PM",
//                     color: Colors.blue,
//                   ),
//                   ClassCard(
//                     icon: Icons.brush,
//                     title: "History of Art",
//                     time: "2:30 PM - 3:30 PM",
//                     color: Colors.cyan,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       // Bottom Navigation
//       // bottomNavigationBar: BottomNavigationBar(
//       //   currentIndex: 1,
//       //   items: const [
//       //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//       //     BottomNavigationBarItem(icon: Icon(Icons.book), label: "Classes"),
//       //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       //   ],
//       // ),
//     );
//   }
// }

// // Reusable Class Card
// class ClassCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String time;
//   final Color color;

//   const ClassCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.time,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: color.withOpacity(0.2),
//           child: Icon(icon, color: color),
//         ),
//         title: Text(title,
//             style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
//         subtitle: Text(time, style: TextStyle(color: Colors.grey[600])),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () {},
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hackathon_project/datas/userdatas/constants.dart';

// class OrderSchedulePage extends StatefulWidget {
//   const OrderSchedulePage({super.key});

//   @override
//   State<OrderSchedulePage> createState() => _OrderSchedulePageState();
// }

// class _OrderSchedulePageState extends State<OrderSchedulePage> {
//   String selectedGroup = "A";

//   @override
//   Widget build(BuildContext context) {
//     final scheduleStream = FirebaseFirestore.instance
//         .collection(uyear.value)
//         .doc(udepartment.value)
//         .collection('schedules')
//         .snapshots(); // ✅ All orders

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Schedule - Group $selectedGroup"),
//         actions: [
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.group),
//             onSelected: (group) {
//               setState(() {
//                 selectedGroup = group;
//               });
//             },
//             itemBuilder: (context) => ['A', 'B', 'C', 'D', 'E', 'F']
//                 .map((g) => PopupMenuItem(
//                       value: g,
//                       child: Text(g),
//                     ))
//                 .toList(),
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: scheduleStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No schedules found"));
//           }

//           final docs = snapshot.data!.docs;

//           return ListView(
//             children: docs.map((doc) {
//               final data = doc.data() as Map<String, dynamic>;
//               final order = data['order'];
//               final schedule = data['schedule'] as Map<String, dynamic>?;

//               return ExpansionTile(
//                 title: Text("Order $order"),
//                 children: [
//                   ListTile(
//                     title: Text("Subject"),
//                     subtitle: Text(schedule?[selectedGroup] ?? "N/A"),
//                   ),
//                 ],
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hackathon_project/datas/userdatas/constants.dart';

// // Example mapping: date string to order number
// final Map<String, int> dateToOrderNumberMap = {
//   "2025-10-15": 2,
//   "2025-10-16": 2,
//   "2025-10-17": 3,
//   "2025-10-18": 4,
//   "2025-10-19": 5,
// };

// // const String uyear = "2025";
// // const String udepartment = "MCA"; // Edit to your department

// class OrderSchedulePage extends StatefulWidget {
//   const OrderSchedulePage({Key? key}) : super(key: key);

//   @override
//   State<OrderSchedulePage> createState() => _OrderSchedulePageState();
// }

// class _OrderSchedulePageState extends State<OrderSchedulePage> {
//   late int selectedOrder;

//   @override
//   void initState() {
//     super.initState();
//     selectedOrder = getTodayOrder();
//   }

//   int getTodayOrder() {
//     final today = DateTime.now();
//     final todayKey =
//         "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
//     return dateToOrderNumberMap[todayKey] ?? 1; // fallback to 1
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scheduleDocStream = FirebaseFirestore.instance
//         .collection(uyear.value)
//         .doc(udepartment.value)
//         .collection('schedules')
//         .where('order', isEqualTo: selectedOrder)
//         .limit(1)
//         .snapshots();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Order $selectedOrder - Today's Schedule"),
//         actions: [
//           PopupMenuButton<int>(
//             icon: const Icon(Icons.repeat),
//             onSelected: (order) {
//               setState(() {
//                 selectedOrder = order;
//               });
//             },
//             itemBuilder: (context) => [1, 2, 3, 4, 5]
//                 .map((order) => PopupMenuItem(
//                       value: order,
//                       child: Text("Order $order"),
//                     ))
//                 .toList(),
//           )
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: scheduleDocStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No schedule found for Order $selectedOrder"));
//           }
//           final doc = snapshot.data!.docs[0];
//           final scheduleMap = Map<String, dynamic>.from(doc['schedule'] ?? {});
//           final breakTime = doc['break'] ?? 'BREAK';

//           return ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               ListTile(
//                 title: const Text('Break'),
//                 subtitle: Text(breakTime),
//                 leading: const Icon(Icons.free_breakfast),
//               ),
//               const Divider(),
//               ...scheduleMap.entries.map((entry) {
//                 final group = entry.key;
//                 final subject = entry.value;
//                 return ListTile(
//                   title: Text("Group $group"),
//                   subtitle: Text(subject),
//                   leading: CircleAvatar(child: Text(group)),
//                 );
//               }).toList(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hackathon_project/datas/userdatas/constants.dart';

// // Map letter order → numeric order stored in Firestore
// final Map<String, int> letterToNumericOrderMap = {
//   'A': 1,
//   'B': 2,
//   'C': 3,
//   'D': 4,
//   'E': 5,
//   'F': 6,
//   // add more if needed
// };

// // Map dates in YYYY-MM-DD format to letter order
// final Map<String, String> dateToLetterOrderMap = {
//   "2025-10-15": "A",
//   "2025-10-16": "B",
//   "2025-10-17": "C",
//   "2025-10-18": "D",
//   "2025-10-19": "E",
//   "2025-10-20": "F",
// };

// // const String uyear = "2025";
// // const String udepartment = "MCA";

// class OrderSchedulePage extends StatefulWidget {
//   const OrderSchedulePage({Key? key}) : super(key: key);

//   @override
//   State<OrderSchedulePage> createState() => _OrderSchedulePageState();
// }

// class _OrderSchedulePageState extends State<OrderSchedulePage> {
//   late String selectedLetterOrder;
//   late int selectedNumericOrder;

//   @override
//   void initState() {
//     super.initState();
//     selectedLetterOrder = getTodayLetterOrder();
//     selectedNumericOrder = letterToNumericOrderMap[selectedLetterOrder]!;
//   }

//   String getTodayLetterOrder() {
//     final today = DateTime.now();
//     final todayKey =
//         "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
//     return dateToLetterOrderMap[todayKey] ?? 'A';
//   }

//   void _onOrderSelected(String letterOrder) {
//     setState(() {
//       selectedLetterOrder = letterOrder;
//       selectedNumericOrder = letterToNumericOrderMap[letterOrder] ?? 1;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scheduleStream = FirebaseFirestore.instance
//         .collection(uyear.value)
//         .doc(udepartment.value)
//         .collection('schedules')
//         .where('order', isEqualTo: selectedNumericOrder)
//         .limit(1)
//         .snapshots();

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // import 'package:cloud_firestore/cloud_firestore.dart';

//           final firestore = FirebaseFirestore.instance;
//           final collection =
//               firestore.collection(uyear.value).doc(udepartment.value).collection('schedules');

//           final Map<String, Map<String, String>> orderData = {
//             "A": {
//               "I": "KSM",
//               "II": "SAS",
//               "III": "SHUN",
//               "IV": "TSS",
//               "V": "CN",
//             },
//             "B": {
//               "I": "MINI PROJECT",
//               "II": "MINI PROJECT",
//               "III": "MINI PROJECT",
//               "IV": "CN",
//               "V": "SAS",
//             },
//             "C": {
//               "I": "SHUN",
//               "II": "TSS",
//               "III": "KSM",
//               "IV": "CN",
//               "V": "SAS",
//             },
//             "D": {
//               "I": "MINI PROJECT",
//               "II": "MINI PROJECT",
//               "III": "MINI PROJECT",
//               "IV": "TSS",
//               "V": "SAS",
//             },
//             "E": {
//               "I": "TSS",
//               "II": "CN",
//               "III": "KSM",
//               "IV": ".NET LAB",
//               "V": ".NET LAB",
//             },
//             "F": {
//               "I": "KSM",
//               "II": "TSS",
//               "III": "SHUN",
//               "IV": ".NET LAB",
//               "V": ".NET LAB",
//             },
//           };

//           WriteBatch batch = firestore.batch();
//           for (var order in orderData.entries) {
//             final docRef = collection.doc(order.key);
//             batch.set(docRef, {
//               "order": order.key,
//               "schedule": order.value,
//               "break": "BREAK",
//             });
//           }
//           await batch.commit();
//         },
//       ),
//       appBar: AppBar(
//         title: Text("Order $selectedLetterOrder - Schedule"),
//         actions: [
//           PopupMenuButton<String>(
//             icon: const Icon(Icons.calendar_today_outlined),
//             onSelected: _onOrderSelected,
//             itemBuilder: (context) => letterToNumericOrderMap.keys
//                 .map((letterOrder) => PopupMenuItem(
//                       value: letterOrder,
//                       child: Text("Order $letterOrder"),
//                     ))
//                 .toList(),
//           )
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: scheduleStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(
//                 child: Text("No schedule for order $selectedLetterOrder"));
//           }

//           final doc = snapshot.data!.docs[0];
//           final scheduleMap = Map<String, dynamic>.from(doc['schedule'] ?? {});
//           final breakTime = doc['break'] ?? 'BREAK';

//           return ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               ListTile(
//                 title: const Text("Break"),
//                 subtitle: Text(breakTime),
//                 leading: const Icon(Icons.free_breakfast),
//               ),
//               const Divider(),
//               ...scheduleMap.entries.map((entry) {
//                 return ListTile(
//                   leading: CircleAvatar(child: Text(entry.key)),
//                   title: Text("Group ${entry.key}"),
//                   subtitle: Text(entry.value),
//                 );
//               }),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

///
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/datas/userdatas/constants.dart';

// Replace with your map
final Map<String, String> dateToLetterOrderMap = {
  "2025-10-15": "A",
  "2025-10-16": "B",
  "2025-10-17": "C",
  "2025-10-20": "D",
  "2025-10-21": "E",
  "2025-10-22": "F",
  "2025-10-23": "A",
  "2025-10-24": "B",
  "2025-10-27": "C",
  "2025-10-28": "D",
  "2025-10-29": "E",
  "2025-10-30": "F",
  "2025-10-31": "A",
};

// Map subject keywords to unique icons
final Map<String, IconData> subjectIcons = {
  "psychology": Icons.psychology,
  "KSM": Icons.science,
  "SAS": Icons.calculate,
  "SHUN": Icons.menu_book,
  "TSS": Icons.lightbulb,
  "CN": Icons.router,
  "MINI PROJECT": Icons.build,
  ".NET": Icons.laptop_mac,
  "RSK": Icons.group,
  "KG": Icons.extension,
  "SSL": Icons.emoji_events,
  "NCI": Icons.computer,
  "SV": Icons.supervisor_account,
  "SM": Icons.settings,
  "MRR": Icons.analytics,
  "lab": Icons.biotech,
  // Add/adjust as needed!
};

IconData getSubjectIcon(String subject) {
  for (var key in subjectIcons.keys) {
    if (subject.toUpperCase().contains(key.toUpperCase())) {
      return subjectIcons[key]!;
    }
  }
  return Icons.library_books; // Default if nothing matched
}

class OrderSchedulePage extends StatefulWidget {
  const OrderSchedulePage({Key? key}) : super(key: key);

  @override
  _OrderSchedulePageState createState() => _OrderSchedulePageState();
}

class _OrderSchedulePageState extends State<OrderSchedulePage> {
  late String selectedDate;
  late String selectedOrderLetter;

  final List<String> availableDates = dateToLetterOrderMap.keys.toList();

  @override
  void initState() {
    super.initState();
    selectedDate = getTodayDate();
    selectedOrderLetter = dateToLetterOrderMap[selectedDate] ?? "A";
  }

  String getTodayDate() {
    final today = DateTime.now();
    return "${today.year.toString().padLeft(4, '0')}-"
        "${today.month.toString().padLeft(2, '0')}-"
        "${today.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final scheduleDocStream = FirebaseFirestore.instance
        .collection(uyear.value)
        .doc(udepartment.value)
        .collection('schedules')
        .doc(selectedOrderLetter)
        .snapshots();

    final List<String> periodOrder = ['I', 'II', 'III', 'IV', 'V'];
    final List<String> periodTimes = [
      "9:00 AM - 10:00 AM",
      "10:00 AM - 11:00 AM",
      "11:00 AM - 12:00 PM",
      "12:30 PM - 1:30 PM",
      "1:30 PM - 2:30 PM",
    ];

    final List<Color> periodCardColors = [
      Colors.lightBlue.shade100,
      Colors.blue.shade100,
      Colors.indigo.shade100,
      Colors.cyan.shade100,
      Colors.teal.shade100,
    ];
    String getLabelForSelectedDate(String selectedDate) {
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));
      final selected = DateTime.parse(selectedDate);

      String todayString = "${today.year.toString().padLeft(4, '0')}-"
          "${today.month.toString().padLeft(2, '0')}-"
          "${today.day.toString().padLeft(2, '0')}";
      String tomorrowString = "${tomorrow.year.toString().padLeft(4, '0')}-"
          "${tomorrow.month.toString().padLeft(2, '0')}-"
          "${tomorrow.day.toString().padLeft(2, '0')}";

      if (selectedDate == todayString) {
        return "Today (Order $selectedOrderLetter)";
      } else if (selectedDate == tomorrowString) {
        return "Tomorrow (Order $selectedOrderLetter)";
      } else {
        return "$selectedDate (Order $selectedOrderLetter)";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Schedule",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined,
                color: Colors.black87),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon:
                const Icon(Icons.arrow_drop_down_circle, color: Colors.black87),
            onSelected: (date) {
              setState(() {
                selectedDate = date;
                selectedOrderLetter = dateToLetterOrderMap[date] ?? "A";
              });
            },
            itemBuilder: (context) => availableDates
                .map((date) => PopupMenuItem(value: date, child: Text(date)))
                .toList(),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 12),
        child: StreamBuilder<DocumentSnapshot>(
          stream: scheduleDocStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(
                  child: Text(
                      "No schedule found for Order $selectedOrderLetter ($selectedDate)",
                      style: TextStyle(color: Colors.grey)));
            }

            final data = snapshot.data!;
            final schedule =
                Map<String, dynamic>.from(data.get('schedule') ?? {});

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getLabelForSelectedDate(selectedDate),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: periodOrder.length,
                    itemBuilder: (context, index) {
                      final period = periodOrder[index];
                      final periodName = schedule[period] ?? "-";
                      return Card(
                        color:
                            periodCardColors[index % periodCardColors.length],
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                        child: ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(getSubjectIcon(periodName),
                                color: Colors.blue),
                          ),
                          title: Text(
                            periodName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(periodTimes[index]),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded,
                              size: 18),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
