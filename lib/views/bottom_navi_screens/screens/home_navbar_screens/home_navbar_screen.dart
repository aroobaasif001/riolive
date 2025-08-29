import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customnavbar.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/party_screen/party_tab.dart';

import '../../../../utile/app_url.dart';
import 'call_screen/call_screen.dart';
import 'live_Screen/live_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedItem = "Match"; // Default tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // ✅ Screens switch with IndexedStack
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: selectedItem == 'Match'
                ? AssetImage("assets/images/callscreenbgimage.png")
                : selectedItem == "Live"
                ? AssetImage("assets/images/hbg3.jpg")
                : AssetImage("assets/images/hbg4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 35),
            CustomNavBar(
              selectedItem: selectedItem,
              onItemTap: (item) {
                setState(() {
                  selectedItem = item;
                });
              },
            ),
            Expanded(
              child: IndexedStack(
                index: selectedItem == "Match"
                    ? 0
                    : selectedItem == "Live"
                    ? 1
                    : 2,
                children: [
                  MatchScreen(token: AppUrl.token ?? ''),
                  const LiveScreen(),
                  const PartyScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
