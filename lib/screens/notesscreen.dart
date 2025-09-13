import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  // Sample syllabus
  final List<Map<String, String>> syllabus = const [
    {
      "title": "Syllabus",
      "type": "DOCX",
      "link":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/mca+sample.docx"
    },
  ];

  // Sample notes
  final List<Map<String, String>> notes = const [
    {
      "title": "Social Networks",
      "type": "PDF",
      "link":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/A+survival+guide+to+social+media.pdf"
    },
    {
      "title": "Big Data Analysis",
      "type": "PDF",
      "link":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/Big+Data+and+Analytics+(Seema+Acharya).pdf"
    },
    {
      "title": "C#",
      "type": "PDF",
      "link":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/Beginning+C%23+7+Programming+with+Visual+Studio++2017+(+PDFDrive+)+(1).pdf"
    },
    {
      "title": "Mobile Computing",
      "type": "PDF",
      "link":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/tutorialMobile-Communications-JochenSchiller+(1).pdf"
    },
    {
      "title": "Cyber Security",
      "type": "PDF",
      "link":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/Beginning+C%23+7+Programming+with+Visual+Studio++2017+(+PDFDrive+)+(1).pdf"
    },
  ];

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  Widget _buildNoteCard(Map<String, String> note) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.insert_drive_file, color: Colors.blue),
        ),
        title: Text(
          note["title"]!,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(note["type"] ?? ""),
        trailing: IconButton(
          icon: const Icon(Icons.download, color: Colors.grey),
          onPressed: () => _openLink(note["link"]!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Semester 1"), centerTitle: true),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("📘 Syllabus",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...syllabus.map(_buildNoteCard).toList(),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("📝 Notes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...notes.map(_buildNoteCard).toList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // TODO: Add navigation logic here
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
