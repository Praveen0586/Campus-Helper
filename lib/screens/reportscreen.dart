import 'package:flutter/material.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? selectedLocation;
  final TextEditingController descriptionController = TextEditingController();

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
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Location Dropdown
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
            ),
            const SizedBox(height: 12),

            // Description Field
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

            // Upload Photo Placeholder
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add_a_photo, color: Colors.grey, size: 40),
                  SizedBox(height: 8),
                  Text("Drag & drop a photo or\nBrowse Files",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Issue submitted successfully ✅")),
                  );
                },
                child: const Text("Submit Report"),
              ),
            ),
            const SizedBox(height: 24),

            // Track Issues
            const Text("Track Your Issues",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
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
