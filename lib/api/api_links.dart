import 'dart:convert';

import 'package:http/http.dart' as http;

class APIinks {
  static String live = "https://hackathon-server-18ab.onrender.com";
  static String local = "http://10.188.69.246:5000";

  static String currentbase = live;

  static String askchatgpt =
      "https://hackathon-server-18ab.onrender.com/chatbot/ask";

  static String adduser = "${currentbase}/users/add";
  static String loginUser = "${currentbase}/users/login";
  static String getAllUser = "${currentbase}/users/all";

  //Ai
  static String Ai_ask = "${currentbase}/chatbot/ask";

  static String AI_FlashCards = "${currentbase}/chatbot/flashcards";
  static String AI_StudyPlanner = "${currentbase}/chatbot/api/studyplan";
}

class APICalls {
  Future<List<Map<String, dynamic>>> fetchUsersFromBackend() async {
    final response = await http.get(Uri.parse(APIinks.getAllUser));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load users from backend');
    }
  }
}
