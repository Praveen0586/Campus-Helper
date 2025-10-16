import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/api/api_links.dart';
import 'package:hackathon_project/global/global.dart';
import 'package:hackathon_project/screens/answer.dart';
import 'package:http/http.dart' as http;
import '../global/global.dart' as globals;

class AICardScreen extends StatefulWidget {
  @override
  State<AICardScreen> createState() => _AICardScreenState();
}

class _AICardScreenState extends State<AICardScreen> {
  final TextEditingController _controller = TextEditingController();

  TextEditingController questionController = TextEditingController();
  bool loading = false;
  Future<void> askQuestion() async {
    try {
      if (globals.result_stored == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please pick a textbook PDF first")),
        );
        return;
      }

      File textbookFile = File(globals.result_stored!.files.single.path!);

      var uri = Uri.parse(APIinks.Ai_ask);
      var request = http.MultipartRequest("POST", uri);

      request.fields["question"] =
          _controller.text.isEmpty ? "Summarize first unit" : _controller.text;
      request.fields["syllabus"] =
          _controller.text.isEmpty ? "Summarize first unit" : _controller.text;

      request.files.add(
        await http.MultipartFile.fromPath("textbook", textbookFile.path),
      );
      request.files.add(
        await http.MultipartFile.fromPath("syllabus", textbookFile.path),
      );

      setState(() => loading = true);

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      setState(() => loading = false);

      if (response.statusCode == 200) {
        var jsonData = json.decode(responseData.body);
        String answer = jsonData["answer"] ?? "No answer found";

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AIAssistantScreen(responseText: answer),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('AI - Ask'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        // leading: Icon(Icons.arrow_back),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder), label: 'Flashcards'),
          BottomNavigationBarItem(
              icon: Icon(Icons.flash_on), label: 'AI Assistant'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Interactive Flashcard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ask any question and let our AI generate a concise answer for you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Question',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: 4,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'e.g., What is the powerhouse of the cell?',
                      hintStyle: TextStyle(color: Colors.white70),
                      contentPadding: EdgeInsets.all(12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    askQuestion();
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) {
                    //     return AIAssistantScreen(responseText: ,);
                    //   },
                    // ));
                    // Add action for generating answer
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF4A00E0),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.auto_awesome),
                  label: Text("Generate Answer"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FlashcardsDisplayScreen extends StatelessWidget {
  final List flashcards;

  FlashcardsDisplayScreen({required this.flashcards});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white), // Change color here

        title: Text(
          "Flashcards",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: flashcards.length,
          itemBuilder: (context, index) {
            final card = flashcards[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  card["question"] ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    card["answer"] ?? "",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
