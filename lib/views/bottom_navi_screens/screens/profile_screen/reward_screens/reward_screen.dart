import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/reward_screens/tabs/hostreward_tab.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/reward_screens/tabs/invite_tab.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/reward_screens/tabs/task_tab.dart';

class RewardsTabs extends StatefulWidget {
  final Gradient? selectedGradient;
  final Gradient? unselectedGradient;
  final int initialIndex;

  const RewardsTabs({
    super.key,
    this.selectedGradient,
    this.unselectedGradient,
    this.initialIndex = 0,
  });

  @override
  State<RewardsTabs> createState() => _RewardsTabsState();
}

class _RewardsTabsState extends State<RewardsTabs> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 2);
  }

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
    // ---- MediaQuery-based responsive helpers (base 390x844) ----
    final size = MediaQuery.of(context).size;
    double sw(double v) => v * (size.width / 390);
    double sh(double v) => v * (size.height / 844);
    double sp(double v) => v * (size.width / 390);

    final mq = MediaQuery.of(context);

    return MediaQuery(
      data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        body: SafeArea(
          child: CustomContainer(
            image: const DecorationImage(
              image: AssetImage('assets/images/Rewardbg.png'),
              fit: BoxFit.fill,
            ),
            child: Column(
              children: [
                SizedBox(height: sh(10)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sw(15)),
                  child: SizedBox(
                    height: sh(36),
                    child: Stack(
                      children: [
                        // Back icon (tap area padded) — uses Get.back()
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: Get.back,
                            child: Padding(
                              // increases touch target without changing visual size
                              padding: EdgeInsets.all(sw(8)),
                              child: Icon(
                                Icons.arrow_back,
                                size: sw(30),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: CustomText(
                            _currentTitle,
                            fontSize: sp(18),
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
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw(0), vertical: sh(8)),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: sw(20)),
                          child: Row(
                            children: [
                              _buildChip(context, 'Task', _selectedIndex == 0),
                              SizedBox(width: sw(10)),
                              _buildChip(context, 'Host Reward', _selectedIndex == 1),
                              SizedBox(width: sw(10)),
                              _buildChip(context, 'Invite', _selectedIndex == 2),
                            ],
                          ),
                        ),
                        SizedBox(height: sh(10)),
                        Expanded(child: _buildSelectedTab()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  // Uses local MediaQuery so it scales perfectly even if called elsewhere.
  Widget _buildChip(BuildContext context, String text, bool selected) {
    final size = MediaQuery.of(context).size;
    double sw(double v) => v * (size.width / 390);
    double sh(double v) => v * (size.height / 844);
    double sp(double v) => v * (size.width / 390);

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
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (text == 'Task') _selectedIndex = 0;
          if (text == 'Host Reward') _selectedIndex = 1;
          if (text == 'Invite') _selectedIndex = 2;
        });
      },
      child: Container(
        height: sh(26),
        padding: EdgeInsets.symmetric(horizontal: sw(23), vertical: sh(2)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sw(28)),
          gradient: selected ? selectedGrad : unselectedGrad,
          border: Border.all(
            color: selected ? const Color(0xFF00FF66) : Colors.transparent,
            width: selected ? sw(0.5) : 0,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: const Color(0xFF00FF66).withOpacity(0.55),
              blurRadius: sh(1.2),
              spreadRadius: sw(1.5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              offset: Offset(sw(6), sh(6)),
              blurRadius: sh(12),
            ),
          ]
              : [
            BoxShadow(color: Colors.white.withOpacity(0.65)),
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: Offset(sw(6), sh(6)),
              blurRadius: sh(10),
            ),
          ],
        ),
        child: Center(
          child: CustomText(
            text,
            fontSize: sp(16),
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: Colors.white,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
