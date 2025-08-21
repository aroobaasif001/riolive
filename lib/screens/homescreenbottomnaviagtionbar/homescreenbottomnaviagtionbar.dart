import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../../customwidgets/custombottomnavbar.dart';
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
    CustomText(text: 'Allah'),
    CustomText(text: 'Allah'),
    CustomText(text: 'Allah'),
    CustomText(text: 'Allah'),
    CustomText(text: 'Allah'),
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
