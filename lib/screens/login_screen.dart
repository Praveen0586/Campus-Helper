import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hackathon_project/api/api_links.dart';
import 'package:hackathon_project/api/coudinary.dart';
import 'package:hackathon_project/datas/userdatas/constants.dart';
import 'package:hackathon_project/screens/DashBoardScreen.dart';
// import 'package:hackathon_project/screens/CreateAccountScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ✅ Add controllers
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  // ✅ Login function as class method
  Future<void> login() async {
    // Validate inputs
    if (emailCtrl.text.trim().isEmpty || passwordCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse(APIinks.loginUser),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": emailCtrl.text.trim(),
          "password": passwordCtrl.text.trim(),
        }),
      );

      setState(() => loading = false);

      print("📥 Status: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user", json.encode(userData));

        // Update global variables
        uName.value = userData['name'] ?? '';
        uemail.value = userData['email'] ?? '';
        uimage.value = userData['img'] ?? '';
        uregnum.value = userData['studentId'] ?? '';
        ucollegeid.value = userData['studentId'] ?? '';
        udepartment.value = userData['dep'] ?? '';
        uyear.value = userData['year'] ?? '';
        uclass.value = "MCA";
        uintrest.value = List<String>.from(userData['interests'] ?? []);

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeDashboard()),
          );
        }
      } else {
        final error = json.decode(response.body);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error['message'] ?? 'Login failed')),
          );
        }
      }
    } catch (e) {
      setState(() => loading = false);
      print("❌ Login error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "A Product by",
            style: TextStyle(color: Colors.blue, fontSize: 14),
          ),
          Text(
            " Praveen",
            style: TextStyle(
                color: Colors.blue, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.language, size: 60, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  "Campus Connect",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Connect with your campus community and stay informed.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),

                // ✅ Email Input with controller
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ✅ Password Input (not College ID)
                TextField(
                  controller: passwordCtrl,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => obscurePassword = !obscurePassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ Continue Button - call login()
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: loading ? null : login,
                    child: loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Continue",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 16),
                const Text("OR"),
                const SizedBox(height: 16),

                // Create New User Button
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CreateAccountScreen()),
                    );
                  },
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text("Create New User"),
                ),

                const SizedBox(height: 24),
                const Text(
                  "By continuing, you agree to our Terms of Service and Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
