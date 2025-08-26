import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/messages_screen/messages_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/moment&message/moment_message_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/profile_screen.dart';

import '../../customwidgets/custombottomnavbar.dart';

class BottomNaviScreen extends StatefulWidget {
  final int? initialIndex;

  const BottomNaviScreen({super.key, this.initialIndex});

  @override
  State<BottomNaviScreen> createState() => _BottomNaviScreenState();
}

class _BottomNaviScreenState extends State<BottomNaviScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex ?? 1;
  }

  final List<Widget> screens = const [
    CustomText('Call screen'), // Index 0
    MomentMessageScreen(), // Index 1
    CustomText('Create'), // Index 2
    MessagesScreen(), // Index 3
    ProfileDashboardScreen(), // Index 4
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(currentIndex: _selectedIndex, onItemSelected: _onItemSelected),
    );
  }
}
