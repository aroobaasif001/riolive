import 'package:flutter/material.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/party_screen/tabs/all_tab.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/party_screen/tabs/friends_tab.dart';

class PartyTab extends StatefulWidget {
  const PartyTab({super.key});

  @override
  State<PartyTab> createState() => _PartyTabState();
}

class _PartyTabState extends State<PartyTab> {
  int _selectedIndex = 0; // Default: All

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildChip('All', _selectedIndex == 0),
                const SizedBox(width: 10),
                _buildChip('Friends', _selectedIndex == 1),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildSelectedTab()),
        ],
      ),
    );
  }

  Widget _buildChip(String text, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == 'All') _selectedIndex = 0;
          if (text == 'Friends') _selectedIndex = 1;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFC6F7C8).withOpacity(0.85), const Color(0xFFA8F0B0).withOpacity(0.85)],
          ),
          border: Border.all(
            color: selected ? const Color(0xFFEFEA97) : Colors.transparent,
            width: selected ? 3 : 0,
          ),
          boxShadow: [
            BoxShadow(color: Colors.white.withOpacity(0.7)),
            BoxShadow(color: Colors.black.withOpacity(0.15), offset: const Offset(6, 6), blurRadius: 12),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: selected ? FontWeight.w600 : null,
            color: const Color(0xFF2F2F2F),
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTab() {
    switch (_selectedIndex) {
      case 0:
        return const AllTab();
      case 1:
        return const FriendsTab();
      default:
        return const AllTab();
    }
  }
}
