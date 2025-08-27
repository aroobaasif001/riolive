import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'edit_profile_screen.dart';
import 'level_screens/rich_level_screen.dart';
import 'ranking_screens/ranking_main_screen.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/third_background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile section
                Stack(
                  children: [
                    Column(
                      children: [
                        const CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage(
                            "assets/images/avatar.png",
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Badges row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        "assets/images/one.png",
                        width: 60,
                        height: 40,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "23",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      Image.asset(
                        "assets/images/banner.png",
                        width: 60,
                        height: 40,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "11",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      Image.asset(
                        "assets/images/three.png",
                        width: 60,
                        height: 40,
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "VIP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
                        const Text(
                          "Wamiqa Jain",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 4),
                            Text(
                              "ID: 6523847",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  const ClipboardData(text: "6523847"),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ID copied to clipboard'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.copy,
                                size: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            _StatWidget(label: "Friend", value: "0"),
                            SizedBox(width: 40),
                            _StatWidget(label: "Followings", value: "303"),
                            SizedBox(width: 40),
                            _StatWidget(label: "Followers", value: "0"),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const EditProfileScreen());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            "assets/icons/profile_edit.png",
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Divider border
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  height: 1,
                  width: double.infinity,
                  color: Colors.black,
                ),

                const SizedBox(height: 16),

                // Balance Cards
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        color: const Color(0xFFCDFFBF),
                        icon: "assets/icons/diamondicon.png",
                        title: "Diamonds",
                        value: "10,000.00",
                        width: width,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoCard(
                        color: const Color(0xFFFFF4BE),
                        icon: "assets/icons/coin.png",
                        title: "Coins",
                        value: "20,000.00",
                        width: width,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Grid Sections
                _buildGridSection([
                  _GridItem("Recharge", "assets/icons/picon1.png"),
                  _GridItem("Verification", "assets/icons/picon2.png"),
                  _GridItem("Reward", "assets/icons/picon3.png"),
                  _GridItem("Shop", "assets/icons/picon4.png"),
                  _GridItem("Backpack", "assets/icons/picon5.png"),
                  _GridItem("Ranking List", "assets/icons/picon6.png"),
                  _GridItem("Game", "assets/icons/picon7.png"),
                  _GridItem("VIP", "assets/icons/picon8.png"),
                ], width),

                _buildGridSection([
                  _GridItem("Call Management", "assets/icons/picon9.png"),
                  _GridItem("My Agency", "assets/icons/picon10.png"),
                  _GridItem("Wallet", "assets/icons/picon11.png"),
                  _GridItem("Live Data", "assets/icons/picon12.png"),
                ], width),

                _buildGridSection([
                  _GridItem("Agency Management", "assets/icons/picon13.png"),
                  _GridItem("Add Host", "assets/icons/picon14.png"),
                  _GridItem("Invite Agent", "assets/icons/picon15.png"),
                  _GridItem("Official Support", "assets/icons/picon16.png"),
                ], width),

                _buildGridSection([
                  _GridItem("Coin Grab", "assets/icons/picon17.png"),
                  _GridItem("Diamond Trading", "assets/icons/picon18.png"),
                ], width),

                _buildGridSection([
                  _GridItem("Level", "assets/icons/picon19.png"),
                  _GridItem("Customer Service", "assets/icons/picon20.png"),
                  _GridItem("Settings", "assets/icons/picon21.png"),
                  _GridItem("About Rio Live", "assets/icons/picon22.png"),
                  _GridItem("Invite User", "assets/icons/picon15.png"),
                  _GridItem("Beauty Filter", "assets/icons/picon23.png"),
                ], width),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Grid builder
  Widget _buildGridSection(List<_GridItem> items, double width) {
    int crossAxisCount = width < 400 ? 3 : 4;
    double iconBoxSize = width < 400 ? 60 : 60; // responsive container size
    double iconSize = width < 400 ? 44 : 44; // responsive icon size

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: items.map((e) {
          return GestureDetector(
            onTap: () {
              if (e.label == "Level") {
                Get.to(() => const RichLevelScreen());
              } else if (e.label == "Ranking List") {
                Get.to(() => const RankingMainScreen());
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFE8D5FF).withOpacity(0.7),
                          const Color(0xFFF7D5F7).withOpacity(0.7),
                          const Color(0xFFFFE5D5).withOpacity(0.7),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: e.icon is String
                          ? Image.asset(
                              e.icon,
                              width: iconSize,
                              height: iconSize,
                            )
                          : Icon(
                              e.icon as IconData,
                              size: iconSize,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Flexible(
                    child: Text(
                      e.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Stat Widget
class _StatWidget extends StatelessWidget {
  final String label;
  final String value;
  const _StatWidget({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}

// InfoCard
class _InfoCard extends StatelessWidget {
  final Color color;
  final dynamic icon;
  final String title;
  final String value;
  final double width;
  const _InfoCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    double iconSize = width < 400 ? 22 : 28;
    double fontSize = width < 400 ? 12 : 14;
    double valueSize = width < 400 ? 14 : 16;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          icon is String
              ? Image.asset(icon, width: iconSize, height: iconSize)
              : Icon(icon as IconData, size: iconSize, color: Colors.black87),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: valueSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// GridItem Model
class _GridItem {
  final String label;
  final dynamic icon;
  _GridItem(this.label, this.icon);
}
