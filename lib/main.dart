import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hackathon_project/datas/userdatas/constants.dart';
import 'package:hackathon_project/screens/DashBoardScreen.dart';
import 'package:hackathon_project/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import "package:get/get.dart";
import "package:hackathon_project/local_notifications/lns.dart";

// ...
String? userJson;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  userJson = prefs.getString("user");
  initNotifications();
  listenToAnnouncements();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadUserDataAndNavigate();
    listenToPrivateChats(currentUserId: uregnum.value);
    listenToLostItems(currentUserId: uregnum.value);
    listenToFoundItems(currentUserId: uregnum.value);
  }

  void loadUserDataAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    userJson = prefs.getString('user');

    if (userJson != null && userJson!.isNotEmpty) {
      final userData = json.decode(userJson!);

      // Update globals
      uName.value = userData['name'] ?? '';
      uemail.value = userData['email'] ?? '';
      uimage.value = userData['img'] ?? '';
      uregnum.value = userData['studentId'] ?? '';
      ucollegeid.value = userData['studentId'] ?? '';
      udepartment.value = userData['dep'] ?? '';
      uyear.value = userData['year'] ?? '';
      uclass.value = "MCA";
      uintrest.value = List<String>.from(userData['interests'] ?? []);
    }

    Timer(Duration(seconds: 4), () {
      if (userJson == null || userJson!.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeDashboard()),
        );
      }
    });
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
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            " Praveen",
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "Campus Connect",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
