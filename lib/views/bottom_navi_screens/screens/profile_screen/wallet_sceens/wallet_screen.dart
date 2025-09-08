import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/wallet_sceens/withdraw_screen.dart';

import 'exhange_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _tab = 1;      // 0: Diamond, 1: Coins
  int _revTab = 0;   // 0: Today, 1: Last Week, 2: Last Month

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          image: const DecorationImage(
            image: AssetImage("assets/images/Livebroadcastdatabg.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RioliveAppBar(
                title: 'Wallet',
                rightImagePath: 'assets/icons/mic_icon.png',
              ),

              // ===== Tabs (Diamond / Coins) =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _TopTab(
                      title: 'Diamond',
                      isActive: _tab == 0,
                      onTap: () => setState(() => _tab = 0),
                    ),
                    _TopTab(
                      title: 'Coins',
                      isActive: _tab == 1,
                      onTap: () => setState(() => _tab = 1),
                    ),
                  ],
                ),
              ),

              // ===== Balance Card (reused) =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: _buildBalanceCard(
                  label: _tab == 0 ? 'Diamond Balance' : 'Coins Balance',
                  showActions: _tab == 1, // Coins => show Withdraw/Exchange
                  iconPath: _tab == 0
                      ? 'assets/images/daimondlastframe.png'   // DIAMOND icon
                      : 'assets/icons/dolloricon.png',         // COINS icon
                  iconSize: _tab == 0 ? 30 : null,             // 🔹 Diamond = 15x15
                ),
              ),

              // ===== Revenue filter pills =====
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 22, 15, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _FilterPill(
                        label: 'Today',
                        active: _revTab == 0,
                        onTap: () => setState(() => _revTab = 0),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _FilterPill(
                        label: 'Last Week',
                        active: _revTab == 1,
                        onTap: () => setState(() => _revTab = 1),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _FilterPill(
                        label: 'Last Month',
                        active: _revTab == 2,
                        onTap: () => setState(() => _revTab = 2),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== Revenue details title + centered underline =====
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Revenue details',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: CustomContainer(
                        width: 20,
                        height: 3,
                        borderRadius: BorderRadius.circular(2),
                        conColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== Empty state =====
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Image(
                        image: AssetImage('assets/icons/emptyicon.png'),
                        height: 86,
                        width: 86,
                      ),
                      SizedBox(height: 12),
                      CustomText(
                        'No data available',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9A9EA4),
                      ),
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

  // ===== Reusable balance card (minimal change) =====
  Widget _buildBalanceCard({
    required String label,
    required bool showActions,
    required String iconPath,
    double? iconSize, // 🔹 NEW (if provided, use as plain image)
  }) {
    return CustomContainer(
      height: 126,
      width: 385,
      conColor: const Color(0xffB1ABF7),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  label, // coins/diamond
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // 🔹 if size provided (diamond), render as raw image 15x15
                    if (iconSize != null)
                      Image.asset(iconPath, width: iconSize, height: iconSize)
                    else
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/icons/dolloricon.png'),
                      ),
                    const SizedBox(width: 10),
                    const CustomText(
                      '34,576,540',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // Right (only for Coins)
          if (showActions)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: const Offset(0, -6),
                  child: const _OutlinePill(text: 'Withdraw'),
                ),
                const SizedBox(height: 2),
                const _OutlinePill(text: 'Exchange'),
              ],
            ),
        ],
      ),
    );
  }
}

// ===== Helpers =====

class _TopTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  const _TopTab({required this.title, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            title,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          const SizedBox(height: 2),
          if (isActive)
            CustomContainer(
              width: 20,
              height: 4,
              borderRadius: BorderRadius.circular(2),
              conColor: Colors.black,
            )
          else
            const SizedBox(height: 3),
        ],
      ),
    );
  }
}

class _OutlinePill extends StatelessWidget {
  final String text;
  const _OutlinePill({required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: () {
        // Add navigation based on the text (to differentiate between buttons)
        if (text == "Withdraw") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WithdrawScreen(), // Navigate to WithdrawScreen
            ),
          );
        } else if (text == "Exchange") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExhangeScreen(), // Navigate to ExhangeScreen
            ),
          );
        }
      },
      width: 123,
      height: 44,
      borderRadius: BorderRadius.circular(22),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      conColor: Colors.transparent,
      border: Border.all(
        color: Colors.black,
        width: 1,
      ),
      child: Center(
        child: CustomText(
          text,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black54,
        ),
      ),
    );
  }
}

/// Mint/grey rounded filter chips (responsive, no overflow)
class _FilterPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = active ? const Color(0xFFB9F1C4) : const Color(0xFFD5D5D5);
    final Color fg = active ? Colors.black : const Color(0xFF6F6F6F);

    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: CustomContainer(
        height: 44,
        width: double.infinity,
        borderRadius: BorderRadius.circular(26),
        conColor: bg,
        child: Center(
          child: CustomText(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: fg,
          ),
        ),
      ),
    );
  }
}
