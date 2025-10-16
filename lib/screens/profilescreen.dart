import 'package:flutter/material.dart';
import 'package:hackathon_project/datas/userdatas/constants.dart';
import 'package:hackathon_project/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                uimage.value,
              ),
            ),
            const SizedBox(height: 12),

            // Name & Details
            Text(
              uName.value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Reg. No: ${uregnum.value}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              "${udepartment.value} | ${uyear.value}",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // Sections
            buildSection("My Reports", [
              buildTile(Icons.menu_book, "Academic Reports"),
              buildTile(Icons.calendar_today, "Attendance Reports"),
            ]),

            buildSection("My Events", [
              buildTile(Icons.event_available, "Upcoming Events"),
              buildTile(Icons.history, "Past Events"),
            ]),

            buildSection("My Notes", [
              buildTile(Icons.note, "Course Notes"),
              buildTile(Icons.edit_note, "Personal Notes"),
            ]),

            // Settings
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Settings",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800]),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Dark Mode",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Text("Enable for better viewing at night",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                    Switch(value: false, onChanged: (val) {}),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.red),
              onTap: () async {
                try {
                  // 1️⃣ Clear SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove("user"); // Remove specific key
                  // OR
                  // await prefs.clear();  // Clear everything

                  // 2️⃣ Clear global variables (from your constants.dart)
                  uName.value = '';
                  uemail.value = '';
                  uimage.value = '';
                  uclass.value = '';
                  uregnum.value = '';
                  ucollegeid.value = '';
                  uintrest.value = [];
                  upassword.value = '';
                  uyear.value = '';
                  udepartment.value = '';

                  // 3️⃣ Navigate to login screen (remove all previous routes)
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const LoginScreen()), // Your login screen
                      (route) => false, // Remove all previous routes
                    );
                  }

                  print("✅ Logout successful");
                } catch (e) {
                  print("❌ Logout error: $e");
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logout failed")),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),

      // Bottom Navigation
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 2,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.notifications), label: "Notifications"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      // ),
    );
  }

  // Helper widget for sections
  Widget buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(children: children),
        ),
      ],
    );
  }

  // Helper widget for list tiles
  Widget buildTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
