import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/screens/homescreenbottomnaviagtionbar/call_screen/call_screen.dart';
import 'package:riolive/screens/homescreenbottomnaviagtionbar/profile_screen/profile_screen.dart';

import '../../customwidgets/custombottomnavbar.dart';
import 'messages_screen/messages_screen.dart';
// import 'package:riolive/customwidgets/custom_bottom_nav_bar.dart'; // if needed

class HomeScreenBottomNaviagtionBar extends StatefulWidget {
  final int? initialIndex;

  const HomeScreenBottomNaviagtionBar({super.key, this.initialIndex});

  @override
  State<HomeScreenBottomNaviagtionBar> createState() =>
      _HomeScreenBottomNaviagtionBarState();
}

class _HomeScreenBottomNaviagtionBarState
    extends State<HomeScreenBottomNaviagtionBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 0;
  }

  final List<Widget> screens = const [
    CallScreen(), // Index 0
    CustomText(text: 'Search'), // Index 1
    CustomText(text: 'Create'), // Index 2
    MessagesScreen(), // Index 3 - Messages Screen
    CustomText(text: 'Profile'), // Index 4
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onItemSelected: _onItemSelected,
        ),
      ),
    );
  }
}
