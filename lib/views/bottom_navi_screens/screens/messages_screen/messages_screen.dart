import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';

import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/second_background.png'), fit: BoxFit.fill),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 20.0 : 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                CustomText(text: 'Messages', fontSize: isSmallScreen ? 24 : 32, color: Colors.black87),
                SizedBox(height: isSmallScreen ? 25 : 35),

                // Category Icons Section
                SizedBox(
                  height: isSmallScreen ? 100 : 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryItem(
                        imagePath: 'assets/icons/micon1.png',
                        label: 'Official',
                        gradientColors: const [Color(0xFF9055FA), Color(0xFFD149FE)],
                        onTap: () {},
                        screenWidth: screenWidth,
                      ),
                      _buildCategoryItem(
                        imagePath: 'assets/icons/micon2.png',
                        label: 'Event',
                        gradientColors: const [Color(0xFFFA66BD), Color(0xFFFEB05C)],
                        onTap: () {},
                        screenWidth: screenWidth,
                      ),
                      _buildCategoryItem(
                        imagePath: 'assets/icons/micon3.png',
                        label: 'Event',
                        gradientColors: const [Color(0xFF2DBDFE), Color(0xFF1AE1FC)],
                        onTap: () {},
                        screenWidth: screenWidth,
                      ),
                      _buildCategoryItem(
                        imagePath: 'assets/icons/micon4.png',
                        label: 'Support',
                        gradientColors: const [Color(0xFF70ED84), Color(0xFF88FB84)],
                        onTap: () {},
                        screenWidth: screenWidth,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 30 : 40),

                // Messages List
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: isSmallScreen ? 20 : 30, bottom: isSmallScreen ? 20 : 30),
                    children: [
                      _buildMessageItem(
                        context: context,
                        profileImage: 'assets/images/backgrondimage.png',
                        name: 'Danny',
                        message: 'Hello! Are you available for toni...',
                        time: '2:58 PM',
                        unreadCount: 2,
                        screenWidth: screenWidth,
                      ),
                      _buildMessageItem(
                        context: context,
                        profileImage: 'assets/images/backgrondimage.png',
                        name: 'Chloe',
                        message: 'Hello! Are you available for toni...',
                        time: '2:58 PM',
                        unreadCount: 2,
                        screenWidth: screenWidth,
                      ),
                      _buildMessageItem(
                        context: context,
                        profileImage: 'assets/images/backgrondimage.png',
                        name: 'Jimmy',
                        message: '✓ Have a good one!',
                        time: '3:02 PM',
                        unreadCount: null,
                        screenWidth: screenWidth,
                      ),
                      _buildMessageItem(
                        context: context,
                        profileImage: 'assets/images/backgrondimage.png',
                        name: 'Chris',
                        message: 'Hello! Are you available for toni...',
                        time: '2:58 PM',
                        unreadCount: 2,
                        screenWidth: screenWidth,
                      ),
                      _buildMessageItem(
                        context: context,
                        profileImage: 'assets/images/backgrondimage.png',
                        name: 'Chloe',
                        message: 'Hello! Are you available for toni...',
                        time: '2:58 PM',
                        unreadCount: 2,
                        screenWidth: screenWidth,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required String imagePath,
    required String label,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    final isSmallScreen = screenWidth < 600;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: isSmallScreen ? 60 : 80,
            height: isSmallScreen ? 60 : 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          CustomText(
            text: label,
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem({
    required BuildContext context,
    required String profileImage,
    required String name,
    required String message,
    required String time,
    int? unreadCount,
    required double screenWidth,
  }) {
    final isSmallScreen = screenWidth < 600;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(contactName: name, profileImage: profileImage),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 20),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Profile Picture
            Container(
              width: isSmallScreen ? 50 : 60,
              height: isSmallScreen ? 50 : 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: AssetImage(profileImage), fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: isSmallScreen ? 16 : 20),

            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: name,
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  CustomText(
                    text: message,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Time and Unread Count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: time,
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                if (unreadCount != null) ...[
                  SizedBox(height: isSmallScreen ? 8 : 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 10,
                      vertical: isSmallScreen ? 4 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9558F8).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                      boxShadow: [
                        // Outer shadow only below
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        CustomText(
                          text: unreadCount.toString(),
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
