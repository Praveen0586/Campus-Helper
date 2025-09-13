import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hackathon_project/screens/DashBoardScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController studentIdCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController interestController = TextEditingController();

  String? selectedDepartment;
  String? selectedYear;
  String gender = "Male";
  int depYear = 2025;

  final List<String> departments = ["MCA"];
  final List<String> years = ["1st Year", "2nd Year"];
  final List<String> interests = ["Sports", "Music", "Gaming"];

  bool agree = false;
  bool loading = false;

  String uploadedImageUrl = "";

  // ---------- ADD INTEREST ----------
  void addInterest() {
    if (interestController.text.isNotEmpty &&
        !interests.contains(interestController.text)) {
      setState(() {
        interests.add(interestController.text);
        interestController.clear();
      });
    }
  }

  // ---------- UPLOAD IMAGE ----------
  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);

    const String cloudName = "des6qtla3";
    const String uploadPreset = "unsigned_preset"; // create this in Cloudinary

    var uri =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
    var request = http.MultipartRequest("POST", uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath("file", imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var resData = await response.stream.bytesToString();
      var jsonRes = json.decode(resData);

      setState(() {
        uploadedImageUrl = jsonRes["secure_url"];
      });

      print("✅ Uploaded Image URL: $uploadedImageUrl");
    } else {
      print("❌ Upload failed: ${response.statusCode}");
    }
  }

  // ---------- REGISTER ----------
  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || !agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete the form properly")),
      );
      return;
    }

    if (uploadedImageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a profile picture")),
      );
      return;
    }

    setState(() => loading = true);

    // Map<String, dynamic> body = {
    //   "name": nameCtrl.text.trim(),
    //   "img": uploadedImageUrl,
    //   "studentId": studentIdCtrl.text.trim(),
    //   "gender": gender,
    //   "dep": selectedDepartment ,
    //   "Year": 2025,
    //   "interests": interests,
    //   "email": emailCtrl.text.trim(),
    //   "password": passwordCtrl.text.trim(),
    // };
    Map<String, dynamic> body = {
      "name": nameCtrl.text.trim(),
      "studentId": studentIdCtrl.text.trim(),
      "img": uploadedImageUrl,
      "gender": gender,
      "dep": "MCA",
      "year": 2025,
      "interests": interests,
      "email": emailCtrl.text.trim(),
      "password": passwordCtrl.text.trim()
    };
    try {
      final response = await http.post(
        Uri.parse("https://hackathon-server-18ab.onrender.com/users/add"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      setState(() => loading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);

        // ✅ Save locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user", json.encode(result));

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeDashboard()),
          );
        }
      } else {
        print("❌ Error: ${response.statusCode}, ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      print("❌ Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture
              GestureDetector(
                onTap: pickAndUploadImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: uploadedImageUrl.isNotEmpty
                      ? NetworkImage(uploadedImageUrl)
                      : null,
                  child: uploadedImageUrl.isEmpty
                      ? const Icon(Icons.camera_alt,
                          size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Full Name
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 16),

              // College ID
              TextFormField(
                controller: studentIdCtrl,
                decoration: const InputDecoration(
                  labelText: "College ID",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter college ID" : null,
              ),
              const SizedBox(height: 16),

              // Department Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Department",
                  border: OutlineInputBorder(),
                ),
                value: selectedDepartment,
                items: departments
                    .map((dept) =>
                        DropdownMenuItem(value: dept, child: Text(dept)))
                    .toList(),
                onChanged: (val) => setState(() => selectedDepartment = val),
                validator: (val) => val == null ? "Select a department" : null,
              ),
              const SizedBox(height: 16),

              // Year Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Year",
                  border: OutlineInputBorder(),
                ),
                value: selectedYear,
                items: years
                    .map((yr) => DropdownMenuItem(value: yr, child: Text(yr)))
                    .toList(),
                onChanged: (val) => setState(() => selectedYear = val),
                validator: (val) => val == null ? "Select year" : null,
              ),
              const SizedBox(height: 16),

              // Interests
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  children: interests
                      .map((e) => Chip(
                            label: Text(e),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () {
                              setState(() {
                                interests.remove(e);
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: interestController,
                      decoration: const InputDecoration(
                        hintText: "Add or search interests",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: addInterest,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || !val.contains("@")
                    ? "Enter valid email"
                    : null,
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.length < 6 ? "Min 6 characters" : null,
              ),
              const SizedBox(height: 16),

              // Terms
              Row(
                children: [
                  Checkbox(
                    value: agree,
                    onChanged: (val) => setState(() => agree = val!),
                  ),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "I agree to the ",
                        children: [
                          TextSpan(
                            text: "Terms and Conditions",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: loading ? null : _register,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
