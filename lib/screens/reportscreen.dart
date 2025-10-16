import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? selectedLocation;
  final TextEditingController descriptionController = TextEditingController();

  String? uploadedImageUrl;
  bool isUploading = false;

  final List<Map<String, String>> userIssues = [
    {
      "title": "Leaky Faucet in Library Restroom",
      "status": "Resolved",
      "time": "2 days ago"
    },
    {
      "title": "Broken Wi-Fi in Cafeteria",
      "status": "In Progress",
      "time": "5 hours ago"
    },
    {
      "title": "Vending Machine not working",
      "status": "Reported",
      "time": "1 hour ago"
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Resolved":
        return Colors.green;
      case "In Progress":
        return Colors.orange;
      case "Reported":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "Resolved":
        return Icons.check_circle;
      case "In Progress":
        return Icons.build_circle;
      case "Reported":
        return Icons.report_problem;
      default:
        return Icons.info;
    }
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      isUploading = true;
    });

    File imageFile = File(pickedFile.path);

    const String cloudName = "des6qtla3";
    const String uploadPreset = "unsigned_preset";

    var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
    var request = http.MultipartRequest("POST", uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath("file", imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var resData = await response.stream.bytesToString();
      var jsonRes = json.decode(resData);
      var url = jsonRes["secure_url"];
      setState(() {
        uploadedImageUrl = url;
        isUploading = false;
      });
    } else {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed with status ${response.statusCode}")),
      );
    }
  }

  Future<void> _submit() async {
    if (selectedLocation == null || descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill location and description")),
      );
      return;
    }

    final doc = {
      'location': selectedLocation,
      'description': descriptionController.text.trim(),
      'image': uploadedImageUrl ?? '',
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Reported',
    };

    await FirebaseFirestore.instance.collection('userIssues').add(doc);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Issue reported successfully")),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report an Issue"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Report a New Issue",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: selectedLocation,
              items: ["Library", "Cafeteria", "Restroom", "Gym", "Parking Lot"]
                  .map((location) => DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
              validator: (value) => value == null ? "Please select location" : null,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Describe the issue in detail",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text("Select & Upload Image"),
                  onPressed: isUploading ? null : pickAndUploadImage,
                ),
                if (isUploading) ...[
                  const SizedBox(width: 16),
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 12),

            if (uploadedImageUrl != null)
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(uploadedImageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submit,
                child: const Text("Submit Report"),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Track Your Issues",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userIssues.length,
              itemBuilder: (context, index) {
                final issue = userIssues[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      getStatusIcon(issue["status"]!),
                      color: getStatusColor(issue["status"]!),
                      size: 30,
                    ),
                    title: Text(issue["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      issue["time"]!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: Text(
                      issue["status"]!,
                      style: TextStyle(
                          color: getStatusColor(issue["status"]!),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
