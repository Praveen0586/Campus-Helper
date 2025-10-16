import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hackathon_project/api/api_links.dart';
import 'package:hackathon_project/screens/raisequestionscreen.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../global/global.dart' as globals;

class PDFUpload extends StatefulWidget {
  const PDFUpload({super.key});

  @override
  State<PDFUpload> createState() => _PDFUploadState();
}

class _PDFUploadState extends State<PDFUpload> {
  bool loading = false; // loading state

  Future<void> pickAndGenerateFlashcards() async {
    try {
      // Pick textbook PDF
      globals.result_stored2 = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (globals.result_stored2 == null) return;

      File textbookFile = File(globals.result_stored2!.files.single.path!);

      setState(() => loading = true);

      var uri = Uri.parse(
          APIinks.AI_FlashCards);
      var request = http.MultipartRequest("POST", uri);

      request.files.add(
        await http.MultipartFile.fromPath("textbook", textbookFile.path),
      );

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      setState(() => loading = false);

      if (response.statusCode == 200) {
        var jsonData = json.decode(responseData.body);

        String qnaString = jsonData["qna"] ?? "{}";
        qnaString = qnaString.replaceAll(RegExp(r"```json|```"), "").trim();
        var flashcardsData = json.decode(qnaString);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardsDisplayScreen(
                flashcards: flashcardsData["flashcards"]),
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
      body: Center(
        child: loading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text(
                    "Generating flashcards...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : TextButton(
                child: Text("Upload PDF"),
                onPressed: pickAndGenerateFlashcards,
              ),
      ),
    );
  }
}
