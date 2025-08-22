import 'package:flutter/material.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  int _selectedIndex = 1; // Default selected index (Explore)

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        // Top filters row with updated tab content
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildChip("New", _selectedIndex == 0),
            _buildChip("Explore", _selectedIndex == 1),
            _buildChip("PK", _selectedIndex == 2),
            _buildChip("Multi", _selectedIndex == 3),
          ],
        ),
        const SizedBox(height: 10),
        // Display the active tab's name
        Center(
          child: Text(
            "Selected Tab: ${_getTabName()}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(height: 10),
        // Banner
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            "assets/images/banner.png", // replace with your banner
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        // Dynamic Grid based on selected tab
        _buildTabContent(),
      ],
    );
  }

  // Returns the name of the currently selected tab
  String _getTabName() {
    switch (_selectedIndex) {
      case 0:
        return "New";
      case 1:
        return "Explore";
      case 2:
        return "PK";
      case 3:
        return "Multi";
      default:
        return "";
    }
  }

  // Displays dynamic content based on selected tab
  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0:
      // Content for "New" tab
        return _buildGridView("New Tab - User 1", "New Tab - User 2");
      case 1:
      // Content for "Explore" tab
        return _buildGridView("Explore Tab - User 1", "Explore Tab - User 2");
      case 2:
      // Content for "PK" tab
        return _buildGridView("PK Tab - User 1", "PK Tab - User 2");
      case 3:
      // Content for "Multi" tab
        return _buildGridView("Multi Tab - User 1", "Multi Tab - User 2");
      default:
        return Container();
    }
  }

  // Method to build the grid view for the given tab content
  Widget _buildGridView(String user1, String user2) {
    return GridView.builder(
      itemCount: 2, // 2 items per grid for simplicity
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return _buildLiveCard(
          "assets/images/user${index + 1}.png", // replace with user images
          index == 0 ? user1 : user2,
        );
      },
    );
  }

  Widget _buildChip(String text, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == "New") {
            _selectedIndex = 0;
          } else if (text == "Explore") {
            _selectedIndex = 1;
          } else if (text == "PK") {
            _selectedIndex = 2;
          } else if (text == "Multi") {
            _selectedIndex = 3;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: selected
              ? Border.all(color: Colors.yellow, width: 0.5) // Yellow border when selected
              : Border.all(color: Colors.transparent), // No border when unselected
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLiveCard(String imagePath, String name) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
