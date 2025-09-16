import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/views/bottom_navi_screens/screens/host_video_call_screen/host_video_call_screen.dart';
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

  // ✅ 4 regular screens (center camera button will navigate separately)
  final List<Widget> _screens = [
    HomeScreen(), // 0 - Home/Match
    const MomentMessageScreen(), // 1 - Moment
    const MessagesScreen(), // 2 - Messages (shifted from index 3)
    const ProfileDashboardScreen(), // 3 - Profile (shifted from index 4)
  ];

  @override
  void initState() {
    super.initState();
    final idx = widget.initialIndex ?? 0;
    _selectedIndex = idx.clamp(0, _screens.length - 1);
  }

  void _onItemSelected(int index) {
    debugPrint("📍 Navigation tap: index $index");
    
    // ✅ TikTok-style center button handling
    if (index == 2) {
      // Center camera button - navigate to HostVideoCallScreen
      debugPrint("📷 Camera button tapped - navigating to HostVideoCallScreen");
      Get.to(() => const HostVideoCallScreen());
      return; // Don't change selectedIndex
    }
    
    // ✅ Handle other indices (map 5-button layout to 4-screen array)
    int screenIndex;
    if (index < 2) {
      screenIndex = index; // 0,1 -> 0,1
    } else {
      screenIndex = index - 1; // 3,4 -> 2,3
    }
    
    if (screenIndex == _selectedIndex) return;
    setState(() => _selectedIndex = screenIndex);
  }

  // ✅ Map screen index to navigation bar index for highlighting
  int _getNavigationIndex() {
    // Screen Index -> Navigation Index
    // 0 -> 0 (Home)
    // 1 -> 1 (Moment)  
    // 2 -> 3 (Messages)
    // 3 -> 4 (Profile)
    // Center button (index 2) is never selected
    
    if (_selectedIndex < 2) {
      return _selectedIndex; // 0,1 -> 0,1
    } else {
      return _selectedIndex + 1; // 2,3 -> 3,4
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Let content extend under the curved bar for the floating effect
      extendBody: true,
      extendBodyBehindAppBar: true,
      // Keep the current tab state alive while switching
      body: IndexedStack(index: _selectedIndex, children: _screens),
      // ✅ TikTok-style curved navigation with center camera button
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        index: _getNavigationIndex(), // Custom index mapping
        items: <Widget>[
          // 0 - Home/Match
          Image.asset(
            "assets/icons/CartoonParrotbottom1.png",
            width: 32,
            height: 32,
          ),
          // 1 - Moment
          Image.asset(
            "assets/icons/bottom2.png",
            width: 32,
            height: 32,
          ),
          // 2 - Camera (Center) - Special navigation to HostVideoCallScreen
          InkWell(
            onTap: (){
              Get.to(HostVideoCallScreen());
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/icons/bottom3.png",
                width: 28,
                height: 28,
                // color: Colors.white,
              ),
            ),
          ),
          // 3 - Messages
          Image.asset(
            "assets/icons/bottom4.png",
            width: 32,
            height: 32,
          ),
          // 4 - Profile
          Image.asset(
            "assets/icons/bottom5.png",
            width: 32,
            height: 32,
          ),
        ],
        color: Colors.grey.withOpacity(0.5), // Bar color
        buttonBackgroundColor: Colors.grey.withOpacity(0.5), // Selected bubble
        backgroundColor: Colors.transparent, // So body shows behind
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onItemSelected,
        letIndexChange: (index) => index != 2, // Prevent selection of center camera button
      ),
    );
  }
}
