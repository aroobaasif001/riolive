import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:riolive/views/bottom_navi_screens/screens/live_streaming_screen/live_streaming_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/messages_screen/messages_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/moment&message/moment_message_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/profile_screen.dart';

import 'screens/home_navbar_screens/home_navbar_screen.dart';

class BottomNaviScreen extends StatefulWidget {
  final int? initialIndex;
  const BottomNaviScreen({super.key, this.initialIndex});

  @override
  State<BottomNaviScreen> createState() => _BottomNaviScreenState();
}

class _BottomNaviScreenState extends State<BottomNaviScreen> {
  int _selectedIndex = 0;

  // Keep your screens as before (you can replace the placeholder CustomText screens later)
  final List<Widget> _screens = [
    HomeScreen(), // 0
    const MomentMessageScreen(), // 1
    const StartCallDummyScreen(), // 2
    const MessagesScreen(), // 3
    const ProfileDashboardScreen(), // 4
  ];

  @override
  void initState() {
    super.initState();
    final idx = widget.initialIndex ?? 0;
    _selectedIndex = idx.clamp(0, _screens.length - 1);
  }

  void _onItemSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Let content extend under the curved bar for the floating effect
      extendBody: true,
      extendBodyBehindAppBar: true,
      // Keep the current tab state alive while switching
      body: IndexedStack(index: _selectedIndex, children: _screens),
      // Curved bottom nav (inspired by your first snippet)
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        index: _selectedIndex,
        items: <Widget>[
          // 🔁 Replace these asset paths with your own if different
          Image.asset(
            "assets/icons/CartoonParrotbottom1.png",
            width: 32,
            height: 32,
          ), // Call
          Image.asset(
            "assets/icons/bottom2.png",
            width: 32,
            height: 32,
          ), // Moment
          Image.asset(
            "assets/icons/bottom3.png",
            width: 32,
            height: 32,
          ), // Create
          Image.asset(
            "assets/icons/bottom4.png",
            width: 32,
            height: 32,
          ), // Messages
          Image.asset(
            "assets/icons/bottom5.png",
            width: 32,
            height: 32,
          ), // Profile
        ],
        color: Colors.grey.withOpacity(0.5), // Bar color
        buttonBackgroundColor: Colors.grey.withOpacity(0.5), // Selected bubble
        backgroundColor: Colors.transparent, // So body shows behind
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onItemSelected,
        letIndexChange: (index) => true,
      ),
    );
  }
}
