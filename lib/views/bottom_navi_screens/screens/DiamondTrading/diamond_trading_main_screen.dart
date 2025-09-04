import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/DiamondTrading/coin_seller_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/DiamondTrading/recharge_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/DiamondTrading/recharge_country_screen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/DiamondTrading/diamond_transfer_screen.dart';

class DiamondTradingMainScreen extends StatelessWidget {
  const DiamondTradingMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB),
              Color(0xFFE6E6FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: CustomText(
                        'Diamond Trading',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the back button
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Diamond Trading Options
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Recharge Option
                      _buildTradingOption(
                        title: 'Recharge',
                        subtitle: 'Buy diamond packages with bonuses',
                        iconPath: 'assets/icons/diamondicon.png',
                        onTap: () => Get.to(() => const RechargeScreen()),
                        gradientColors: [
                          const Color(0xFF9C27B0),
                          const Color(0xFF2196F3),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Diamond Transfer Option
                      _buildTradingOption(
                        title: 'Diamond Transfer',
                        subtitle: 'Send diamonds to other users',
                        iconPath: 'assets/icons/diamondicon.png',
                        onTap: () => Get.to(() => const DiamondTransferScreen()),
                        gradientColors: [
                          const Color(0xFF9C27B0),
                          const Color(0xFF2196F3),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Country Recharge Option
                      _buildTradingOption(
                        title: 'Country Recharge',
                        subtitle: 'Select country for regional packages',
                        iconPath: 'assets/icons/diamondicon.png',
                        onTap: () => Get.to(() => const RechargeCountryScreen()),
                        gradientColors: [
                          const Color(0xFF4FC3F7),
                          const Color(0xFF29B6F6),
                        ],
                      ),
                      
                      
                      const SizedBox(height: 16),
                      
                      // Coin Seller Option
                      _buildTradingOption(
                        title: 'Become Coin Seller',
                        subtitle: 'Apply to become a verified coin seller',
                        iconPath: 'assets/icons/coin.png',
                        onTap: () => Get.to(() => const CoinSellerScreen()),
                        gradientColors: [
                          const Color(0xFFFFB347),
                          const Color(0xFFFF6B6B),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Info Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Diamond Trading Center',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            SizedBox(height: 8),
                            CustomText(
                              '• Top up diamonds for gifts and features\n• Become a coin seller to earn rewards\n• Secure and verified transactions\n• 24/7 customer support',
                              fontSize: 14,
                              color: Colors.black54,
                              lineHeight: 1.4,
                            ),
                          ],
                        ),
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

  Widget _buildTradingOption({
    required String title,
    required String subtitle,
    required String iconPath,
    required VoidCallback onTap,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CustomContainer(
              height: 50,
              width: 50,
              conColor: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Image.asset(
                  iconPath,
                  height: 28,
                  width: 28,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    subtitle,
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
