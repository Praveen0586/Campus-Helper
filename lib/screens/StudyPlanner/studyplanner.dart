import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hackathon_project/api/api_links.dart';
import 'package:http/http.dart' as http;

class StudyPlannerScreen extends StatefulWidget {
  @override
  _StudyPlannerScreenState createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
  final TextEditingController _subjectsController = TextEditingController();
  final TextEditingController _examsController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  Map<String, dynamic> _plan = {};
  bool _loading = false;

  Future<void> _getPlan() async {
    setState(() => _loading = true);
// https://hackathon-server-18ab.onrender.com
    final url = Uri.parse(
       APIinks.AI_StudyPlanner); // change when hosted
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "subjects": _subjectsController.text,
          "exams": _examsController.text,
          "hours": _hoursController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Clean JSON if wrapped inside ```json ```
        String planString = data["plan"]
            .toString()
            .replaceAll("```json", "")
            .replaceAll("```", "")
            .trim();

        final planMap = jsonDecode(planString);

        setState(() {
          _plan = planMap;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() {
        _plan = {};
        _loading = false;
      });
      print("Error: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _subjectsController.text = "Maths, Physics, Chemistry, Python, English";
    _examsController.text =
        "Maths - Nov 25, Physics - Nov 27, Chemistry - Nov 29, Python - Oct 2, English - Oct 4";
        
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📅 AI Study Planner"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_subjectsController, "Subjects (comma Novarated)"),
            SizedBox(height: 10),
            _buildTextField(_examsController, "Exams (e.g. Math - Nov 20)"),
            SizedBox(height: 10),
            _buildTextField(_hoursController, "Hours per day", isNumber: true),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.auto_awesome),
                  onPressed: _getPlan,
                  label: Text("Generate Plan"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _plan.isEmpty
                      ? Center(child: Text("No plan yet"))
                      : ListView.builder(
                          itemCount: _plan.length,
                          itemBuilder: (context, index) {
                            final entry = _plan.entries.elementAt(index);

                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade50,
                                    Colors.blue.shade100
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: entry.value
                                        .toString()
                                        .split(",")
                                        .map((task) => Chip(
                                              backgroundColor: Colors.white,
                                              label: Text(
                                                task.trim(),
                                                style: TextStyle(
                                                  color: Colors.blue.shade900,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
