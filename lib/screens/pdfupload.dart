import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hackathon_project/global/global.dart';
import 'package:hackathon_project/screens/raisequestionscreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class FlashcardsScreen extends StatefulWidget {
  @override
  _FlashcardsScreenState createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  TextEditingController questionController = TextEditingController();

  List<FileSystemEntity> savedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadSavedFiles();
  }

  // Pick a PDF/Doc and save locally
  Future<void> _pickFile() async {
    result_stored = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return AICardScreen();
      },
    ));
    if (result_stored != null && result_stored!.files.single.path != null) {
      File file = File(result_stored!.files.single.path!);

      // Save to app's local directory
      Directory appDir = await getApplicationDocumentsDirectory();
      String newPath = "${appDir.path}/${result_stored!.files.single.name}";
      await file.copy(newPath);

      _loadSavedFiles(); // refresh list
    }
  }

  // Load all saved files
  Future<void> _loadSavedFiles() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = appDir.listSync();
    setState(() {
      savedFiles = files;
    });
  }

  String answer = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Flashcards'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Upload a Document Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.upload_file, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('Upload a Document',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text(
                      'Upload a PDF or document to automatically generate flashcards.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _pickFile,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Upload Document'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),
              Text('Saved Documents',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),

              // Show saved documents list
              ...savedFiles.map((file) {
                String name = file.path.split('/').last;
                return Card(
                  child: ListTile(
                    leading: Icon(
                      name.endsWith('.pdf')
                          ? Icons.picture_as_pdf
                          : Icons.description,
                      color: Colors.blue,
                    ),
                    title: Text(name),
                    subtitle: Text("Stored locally"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
