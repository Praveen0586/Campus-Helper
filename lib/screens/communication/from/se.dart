import 'package:flutter/material.dart';
import 'package:hackathon_project/api/api_links.dart';
import 'package:hackathon_project/datas/userdatas/constants.dart';
import 'package:hackathon_project/screens/communication/chatscreen.dart';
import 'package:hackathon_project/screens/communication/from/privatechat/chatScreen.dart';
import 'package:hackathon_project/screens/communication/from/privatechat/methods.dart';
import 'package:hackathon_project/screens/communication/from/sd.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    final currentUserId = uregnum.value; // Get logged-in user ID

    APICalls().fetchUsersFromBackend().then((users) {
      setState(() {
        allUsers = users;
        filteredUsers =
            users.where((user) => user['studentId'] != currentUserId).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchUsers(String query) {
    final queryLower = query.toLowerCase();
    filteredUsers = allUsers.where((user) {
      final name = (user['name'] ?? '').toString().toLowerCase();
      final email = (user['email'] ?? '').toString().toLowerCase();
      final department = (user['dep'] ?? '').toString().toLowerCase();
      return name.contains(queryLower) ||
          email.contains(queryLower) ||
          department.contains(queryLower);
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Students"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by name, student ID, or department",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            filteredUsers = allUsers;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                searchUsers(value);
              },
              onSubmitted: (value) {
                searchUsers(value);
              },
            ),
          ),

          // Search Results
          Expanded(
              child: filteredUsers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No students found",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Try searching with a different term",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        final userName = user['name'] ?? 'Unknown';
                        final userImage =
                            user['img'] ?? 'https://via.placeholder.com/150';
                        final studentId = user['studentId'] ?? '';
                        final dep = user['dep'] ?? '';
                        final year = user['year'] ?? '';
                        final interests = user['interests'] as List<dynamic>?;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Navigate to FirestoreChatScreen or your chat screen
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Profile Image
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(userImage),
                                    backgroundColor: Colors.grey[200],
                                  ),
                                  const SizedBox(width: 12),

                                  // User Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "$dep • $year",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                        if (studentId.isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Text(
                                              "ID: $studentId",
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        if (interests != null &&
                                            interests.isNotEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: Wrap(
                                              spacing: 4,
                                              runSpacing: 4,
                                              children: interests
                                                  .take(3)
                                                  .map(
                                                    (interest) => Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 3),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue[50],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                          color:
                                                              Colors.blue[200]!,
                                                          width: 0.5,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        interest.toString(),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Chat Button
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        final currentUserId = uregnum
                                            .value; // Replace with your logged-in user ID
                                        final otherUserId = user[
                                            'studentId']; // The selected user's ID
                                        final otherUserName =
                                            user['name'] ?? 'Unknown';
                                        final otherUserImage = user['img'] ??
                                            'https://via.placeholder.com/150';

                                        final chatId = getChatId(
                                            currentUserId, otherUserId);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FirestoreChatScreen(
                                              receiverId: otherUserId,
                                              receiverName: userName,
                                              receiverImage: userImage,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.chat_bubble_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
        ],
      ),
    );
  }
}
