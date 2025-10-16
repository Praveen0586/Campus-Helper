import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_project/api/api_links.dart';
import 'package:hackathon_project/datas/userdatas/constants.dart';
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
  final List<String> years = ["2024-2026", "2025-2027"];
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

  // // ---------- REGISTER ----------
  // Future<void> _register() async {
  //   if (!_formKey.currentState!.validate() || !agree) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please complete the form properly")),
  //     );
  //     return;
  //   }

  //   if (uploadedImageUrl.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please upload a profile picture")),
  //     );
  //     return;
  //   }

  //   setState(() => loading = true);

  //   // Map<String, dynamic> body = {
  //   //   "name": nameCtrl.text.trim(),
  //   //   "img": uploadedImageUrl,
  //   //   "studentId": studentIdCtrl.text.trim(),
  //   //   "gender": gender,
  //   //   "dep": selectedDepartment ,
  //   //   "Year": 2025,
  //   //   "interests": interests,
  //   //   "email": emailCtrl.text.trim(),
  //   //   "password": passwordCtrl.text.trim(),
  //   // };
  //   Map<String, dynamic> body = {
  //     "name": nameCtrl.text.trim(),
  //     "studentId": studentIdCtrl.text.trim(),
  //     "img": uploadedImageUrl,
  //     "gender": gender,
  //     "dep": "MCA",
  //     "year": selectedYear,
  //     "interests": interests,
  //     "email": emailCtrl.text.trim(),
  //     "password": passwordCtrl.text.trim()
  //   };

  //   // uName.value = nameCtrl.text;
  //   // uemail.value = emailCtrl.text;
  //   // uimage.value = uploadedImageUrl;
  //   // uclass.value = "MCA";
  //   // uregnum.value = studentIdCtrl.text;
  //   // ucollegeid.value = studentIdCtrl.text;
  //   // uintrest.value = interests;
  //   // upassword.value = passwordCtrl.text;
  //   // uyear.value = selectedYear ?? "";
  //   // udepartment.value = selectedDepartment ?? "";
  //   uName.value = nameCtrl.text;
  //   uemail.value = emailCtrl.text;
  //   uimage.value = uploadedImageUrl;
  //   uclass.value = "MCA";
  //   uregnum.value = studentIdCtrl.text;
  //   ucollegeid.value = studentIdCtrl.text;
  //   uintrest.value = interests;
  //   upassword.value = passwordCtrl.text;
  //   uyear.value = selectedYear ?? "";
  //   udepartment.value = selectedDepartment ?? "";
  //   print(uName.value);
  //   print(uemail.value);
  //   print(uimage.value);
  //   print(uclass.value);
  //   print(uregnum.value);
  //   print(ucollegeid.value);
  //   print(uintrest.value);
  //   print(upassword.value);
  //   print(uyear.value);
  //   print(udepartment.value);

  //   try {
  //     final response = await http.post(
  //       Uri.parse(APIinks.adduser),
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(body),
  //     );

  //     setState(() => loading = false);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final result = json.decode(response.body);

  //       // ✅ Save locally
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString("user", json.encode(result));

  //       if (context.mounted) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (_) => const HomeDashboard()),
  //         );
  //       }
  //     } else {
  //       print("❌ Error: ${response.statusCode}, ${response.body}");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error: ${response.body}")),
  //       );
  //     }
  //   } catch (e) {
  //     setState(() => loading = false);
  //     print("❌ Exception: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Something went wrong")),
  //     );
  //   }
  // }
  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || !agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete the form properly")),
      );
      return;
    }

    if (selectedDepartment == null || selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select department and year")),
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

    Map<String, dynamic> body = {
      "name": nameCtrl.text.trim(),
      "img": uploadedImageUrl,
      "studentId": studentIdCtrl.text.trim(),
      "gender": gender,
      "dep": selectedDepartment!,
      "year": selectedYear!,
      "interests": interests,
      "email": emailCtrl.text.trim(),
      "password": passwordCtrl.text.trim(),
    };

    print("📤 Request Body: ${json.encode(body)}");

    try {
      final response = await http.post(
        Uri.parse(APIinks.adduser),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      setState(() => loading = false);

      // ... [API POST logic remains unchanged above]

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);

        // ✅ Extract user from response
        final userData = result['user'] ?? result; // Handle both formats

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user", json.encode(userData));

        // Update global variables
        uName.value = userData['name'];
        uemail.value = userData['email'];
        uimage.value = userData['img'];
        uclass.value = userData['dep'];
        uregnum.value = userData['studentId'];
        ucollegeid.value = userData['studentId'];
        uintrest.value = userData['interests'];
        upassword.value = userData['password'];
        uyear.value = userData['year'];
        udepartment.value = userData['dep'];

        // 💡 (NEW) Firebase Firestore storage:
        String userId = userData['studentId']; // or Firebase UID if available
        try {
          // 1. Main profile
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .set(userData);
          // 2. Batch/department membership
          await FirebaseFirestore.instance
              .collection(userData['year'])
              .doc(userData['dep'])
              .collection('students')
              .doc(userId)
              .set(userData);
          print('✅ User stored in Firestore');
        } catch (e) {
          print('❌ Failed to store user in Firestore: $e');
        }

        // UI feedback and navigation
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Account created successfully!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeDashboard()),
          );
        }
      }
    } catch (e) {
      setState(() => loading = false);
      print("❌ Exception: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
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
                readOnly: false,
                controller: studentIdCtrl,
                decoration: const InputDecoration(
                  labelText: "Student ID",
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
