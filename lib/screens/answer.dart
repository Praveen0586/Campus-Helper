import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AIAssistantScreen extends StatelessWidget {
  final String responseText; // ✅ field

  const AIAssistantScreen({
    super.key,
    required this.responseText,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Assistant'),
        centerTitle: true,
        leading: Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(text: responseText),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButtonWithLabel(
                    icon: Icons.thumb_up_alt_outlined, label: '12'),
                SizedBox(width: 10),
                IconButtonWithLabel(
                    icon: Icons.thumb_down_alt_outlined, label: '2'),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: responseText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Copied to clipboard")),
                    );
                  },
                  icon: Icon(Icons.copy),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    // Implement share functionality
                  },
                  icon: Icon(Icons.share),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class IconButtonWithLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconButtonWithLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22),
        SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
