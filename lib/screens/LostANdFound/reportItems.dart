import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/datas/userdatas/constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ReportItemScreen extends StatefulWidget {
  @override
  _ReportItemScreenState createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  bool isUploading = false;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  DateTime? selectedDate;
  String category = 'lost'; // or 'found'
  final imageUrlController = TextEditingController();

  String? uploadedImageUrl;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      setState(() {
        isUploading = false;
      });
      return;
    }

    setState(() {
      isUploading = true; // Start loading
    });

    File imageFile = File(pickedFile.path);

    const String cloudName = "des6qtla3";
    const String uploadPreset = "unsigned_preset";

    var uri =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
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
        imageUrlController.text = url;
        isUploading = false; // Stop loading on success
      });
    } else {
      setState(() {
        isUploading = false; // Stop loading on failure
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Image upload failed with status ${response.statusCode}")),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;

    final doc = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'location': locationController.text.trim(),
      'date': selectedDate != null ? selectedDate!.toIso8601String() : '',
      'image': imageUrlController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'creatorId': uregnum.value,
    };

    final collectionName = category == 'lost' ? 'lostItems' : 'foundItems';

    await FirebaseFirestore.instance.collection(collectionName).add(doc);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Item reported successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Lost/Found Item")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.image),
                    label: Text("Select & Upload Image"),
                    onPressed: isUploading ? null : pickAndUploadImage,
                  ),
                  if (isUploading) ...[
                    const SizedBox(width: 12),
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  ]
                ],
              ),
              const SizedBox(height: 12),
              if (uploadedImageUrl != null)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(uploadedImageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text("Date: "),
                  Text(selectedDate == null
                      ? "Not selected"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'lost',
                    groupValue: category,
                    onChanged: (val) => setState(() => category = val!),
                  ),
                  const Text("Lost"),
                  Radio<String>(
                    value: 'found',
                    groupValue: category,
                    onChanged: (val) => setState(() => category = val!),
                  ),
                  const Text("Found"),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 40,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: Colors.blue, // Button background color
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white), // Text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
