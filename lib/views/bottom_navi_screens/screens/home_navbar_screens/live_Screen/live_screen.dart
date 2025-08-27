import 'package:flutter/material.dart';
import 'tabs/new_tab.dart';
import 'tabs/explore_tab.dart';
import 'tabs/pk_tab.dart';
import 'tabs/multi_tab.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  int _selectedIndex = 1; // Default: Explore

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildChip('New', _selectedIndex == 0),
                const SizedBox(width: 10),
                _buildChip('Explore', _selectedIndex == 1),
                const SizedBox(width: 10),
                _buildChip('PK', _selectedIndex == 2),
                const SizedBox(width: 10),
                _buildChip('Multi', _selectedIndex == 3),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildSelectedTab()),
        ],
      ),
    );
  }

  Widget _buildSelectedTab() {
    switch (_selectedIndex) {
      case 0:
        return const NewTab();
      case 1:
        return const ExploreTab();
      case 2:
        return const PKTab();
      case 3:
        return const MultiTab();
      default:
        return const ExploreTab();
    }
  }

  Widget _buildChip(String text, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == 'New') _selectedIndex = 0;
          if (text == 'Explore') _selectedIndex = 1;
          if (text == 'PK') _selectedIndex = 2;
          if (text == 'Multi') _selectedIndex = 3;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
            BoxShadow(color: Colors.white.withOpacity(0.7), offset: const Offset(-4, -4), blurRadius: 10),
            BoxShadow(color: Colors.black.withOpacity(0.15), offset: const Offset(6, 6), blurRadius: 12),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF2F2F2F),
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
