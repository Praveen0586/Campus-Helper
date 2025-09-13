import 'package:flutter/material.dart';

class LostAndFoundScreen extends StatefulWidget {
  const LostAndFoundScreen({super.key});

  @override
  State<LostAndFoundScreen> createState() => _LostAndFoundScreenState();
}

class _LostAndFoundScreenState extends State<LostAndFoundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> lostItems = [
    {
      "title": "Gold Chain",
      "description": "Lost near the library",
      "date": "October 26, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/UU01800-YG0000_1_lar.jpg"
    },
    {
      "title": "Bangles - Gold",
      "description": "Lost in the cafeteria",
      "date": "October 25, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/2.6-size-original-1-gram-gold-bangles-design-online-bng645-1-850x1000.jpg.jpg"
    },
    {
      "title": "Id Card -Name : Viswa",
      "description": "Lost in the gym",
      "date": "October 24, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/66b5b06410260_BLUE-1431-bg.webp"
    },
    {
      "title": "Water Bottle",
      "description": "Lost in the parking lot",
      "date": "October 23, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/1_18641b2e-f293-4509-8b9b-8d4b52873dc5.webp"
    },
    {
      "title": "Anklet",
      "description": "Lost in the parking lot",
      "date": "October 23, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/ank102-10-inches-trendy-gold-look-mango-design-one-gram-gold-anklet-buy-online-5-850x1000.jpg.jpg"
    },
  ];

  final List<Map<String, String>> founditems = [
    {
      "title": "Mobile Phone",
      "description": "Found near the library",
      "date": "October 26, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/redmi-note-7-4gb-64gb-mobile-phone.jpg"
    },
    {
      "title": "Keys",
      "description": "Found in the cafeteria",
      "date": "October 25, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/images.jpg"
    },
    {
      "title": "Id Card -Name : Viswa",
      "description": "Found in the gym",
      "date": "October 24, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/66b5b06410260_BLUE-1431-bg.webp"
    },
    {
      "title": "Water Bottle",
      "description": "Found in the parking lot",
      "date": "October 23, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/1_18641b2e-f293-4509-8b9b-8d4b52873dc5.webp"
    },
    {
      "title": "Anklet",
      "description": "Found in the parking lot",
      "date": "October 23, 2023",
      "image":
          "https://learningbucket250825.s3.ap-southeast-2.amazonaws.com/ank102-10-inches-trendy-gold-look-mango-design-one-gram-gold-anklet-buy-online-5-850x1000.jpg.jpg"
    },
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildItemCard(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item["image"]!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item["title"]!,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item["description"] ?? ""),
            const SizedBox(height: 4),
            Text(
              item["date"] ?? "",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Opening ${item['title']} details...")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lost & Found"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: "Lost"),
            Tab(text: "Found"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar + Filters
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search for items",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterChip(
                        label: const Text("Category"), onSelected: (_) {}),
                    FilterChip(
                        label: const Text("Location"), onSelected: (_) {}),
                    FilterChip(label: const Text("Date"), onSelected: (_) {}),
                  ],
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Lost Items
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: lostItems.length,
                  itemBuilder: (context, index) =>
                      buildItemCard(lostItems[index]),
                ),

                // Found Items (reuse for now)
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: founditems.length,
                  itemBuilder: (context, index) =>
                      buildItemCard(founditems[index]),
                ),
              ],
            ),
          ),
        ],
      ),

      // Report Button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () {
          // TODO: Navigate to report screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Report Item clicked")),
          );
        },
        label: const Text("Report Item"),
        icon: const Icon(Icons.add),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Lost & Found selected
        onTap: (index) {
          // TODO: Implement navigation
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat), label: "Communication"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Lost & Found"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
