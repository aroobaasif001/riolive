import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart'; // 👈 add this
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/reward_screens/tabs/hostreward_tab.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/reward_screens/tabs/invite_tab.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/reward_screens/tabs/task_tab.dart';

class RewardsTabs extends StatefulWidget {
  /// Optional: override gradients (else defaults will be used)
  final Gradient? selectedGradient;
  final Gradient? unselectedGradient;

  /// Optional: start tab (0: Task, 1: Host Reward, 2: Invite)
  final int initialIndex;

  const RewardsTabs({
    super.key,
    this.selectedGradient,
    this.unselectedGradient,
    this.initialIndex = 0,
  });

  @override
  _RewardsTabsState createState() => _RewardsTabsState();
}

class _RewardsTabsState extends State<RewardsTabs> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 2);
  }

  // title text tied to current tab
  String get _currentTitle {
    switch (_selectedIndex) {
      case 0:
        return 'Task';
      case 1:
        return 'Host Reward';
      case 2:
        return 'Invite';
      default:
        return 'Task';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomContainer(
          image: const DecorationImage(
            image: AssetImage('assets/images/Rewardbg.png'),
            fit: BoxFit.fill,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    const Icon(Icons.arrow_back),
                    Center(
                      child: CustomText(
                        _currentTitle,                // 👈 CustomText
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            _buildChip('Task', _selectedIndex == 0),
                            const SizedBox(width: 10),
                            _buildChip('Host Reward', _selectedIndex == 1),
                            const SizedBox(width: 10),
                            _buildChip('Invite', _selectedIndex == 2),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(child: _buildSelectedTab()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTab() {
    switch (_selectedIndex) {
      case 0:
        return TaskTab();
      case 1:
        return HostrewardTab();
      case 2:
        return const InviteTab();
      default:
        return const TaskTab();
    }
  }

  Widget _buildChip(String text, bool selected) {
    final Gradient selectedGrad = widget.selectedGradient ??
        const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFFBCFF), Color(0xFF6E6AFF)], // pink -> purple
        );

    final Gradient unselectedGrad = widget.unselectedGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFB5C6B8).withOpacity(0.65),
            const Color(0xFFA3B2A8).withOpacity(0.65),
          ],
        );

    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == 'Task') _selectedIndex = 0;
          if (text == 'Host Reward') _selectedIndex = 1;
          if (text == 'Invite') _selectedIndex = 2;
        });
      },
      child: Container(
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: selected ? selectedGrad : unselectedGrad,
          border: Border.all(
            color: selected ? const Color(0xFF00FF66) : Colors.transparent, // neon green
            width: selected ? 0.5 : 0,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: const Color(0xFF00FF66).withOpacity(0.55),
              blurRadius: 1,
              spreadRadius: 1.5,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(6, 6),
              blurRadius: 12,
            ),
          ]
              : [
            BoxShadow(color: Colors.white.withOpacity(0.65)),
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: const Offset(6, 6),
              blurRadius: 10,
            ),
          ],
        ),
        child: CustomText(
          text,                                 // 👈 CustomText on chips
          fontSize: 16,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          color: Colors.white,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
