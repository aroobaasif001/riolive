import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/DiamondTrading/diamond_records_screen.dart';

class RechargeScreen extends StatelessWidget {
  const RechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Diamond packages with bonus data
    final List<Map<String, dynamic>> diamondPackages = [
      {
        'diamonds': '6325',
        'originalPrice': '5500',
        'price': '\$0.99',
        'bonus': '+15%',
        'bonusColor': const Color(0xFFFFA726),
      },
      {
        'diamonds': '66,000',
        'originalPrice': '55,000',
        'price': '\$9.99',
        'bonus': '+20%',
        'bonusColor': const Color(0xFFFF7043),
      },
      {
        'diamonds': '103,125',
        'originalPrice': '82,2500',
        'price': '\$14.99',
        'bonus': '+25%',
        'bonusColor': const Color(0xFFFFA726),
      },
      {
        'diamonds': '213,436',
        'originalPrice': '164,945',
        'price': '\$29.99',
        'bonus': '+30%',
        'bonusColor': const Color(0xFFFF7043),
      },
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/m&mBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                          'Recharge',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const DiamondRecordsScreen()),
                        child: const CustomText(
                          'Records',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Diamonds Label
                        const Align(
                          alignment: Alignment.centerRight,
                          child: CustomText(
                            'Diamonds',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Diamond Balance Card
                        Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFBCFF), // Purple
                                Color(0xFF6E6AFF), // Blue
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Diamond Icon
                              Positioned(
                                left: -30,
                                top: -35,
                                // child: Transform.rotate(
                                //   angle: -pi / 8,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icons/gem_icon.png',
                                      width: 150,
                                      height: 150,
                                      // color: Colors.white.withOpacity(0.9),
                                    ),
                                  // ),
                                ),
                              ),

                              // Balance Text
                              const Positioned(
                                right: 20,
                                bottom: 40,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      '0',
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                    CustomText(
                                      'Diamond Balance',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Top Up Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  'Top Up',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                Container(
                                  height: 3,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                            const CustomText(
                              'Agent upto 40% extra',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Diamond Packages Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 18/12,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: diamondPackages.length,
                          itemBuilder: (context, index) {
                            final package = diamondPackages[index];
                            return _buildDiamondPackageCard(package);
                          },
                        ),

                        const SizedBox(height: 30),

                        // Recharge Notice Section
                        const CustomText(
                          'Recharge Notice',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                '1. If you have multiple recharge coupons, first use the one with the highest discount amount.',
                                fontSize: 14,
                                color: Colors.black87,
                                lineHeight: 1.4,
                              ),
                              SizedBox(height: 12),
                              CustomText(
                                '2. Refunds are not supported after successful recharge.',
                                fontSize: 14,
                                color: Colors.black87,
                                lineHeight: 1.4,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
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

  Widget _buildDiamondPackageCard(Map<String, dynamic> package) {
    return GestureDetector(
      onTap: () {
        // Handle package selection
        Get.snackbar(
          'Selected',
          '${package['diamonds']} diamonds for ${package['price']}',
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
                         // Bonus Badge with CustomPaint
             Positioned(
               top: 8,
               right: 8,
               child: CustomPaint(
                 painter: BonusBadgePainter(package['bonusColor']),
                 child: Container(
                   width: 50,
                   height: 30,
                   alignment: Alignment.center,
                   child: Padding(
                     padding: const EdgeInsets.only(bottom: 2),
                     child: CustomText(
                       package['bonus'],
                       fontSize: 11,
                       fontWeight: FontWeight.bold,
                       color: Colors.white,
                     ),
                   ),
                 ),
               ),
             ),

            Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const SizedBox(height: 20),

                        // Diamond Icon and Count
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/diamondicon.png',
                              width: 24,
                              height: 24,
                              // color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomText(
                                package['diamonds'],
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Original Price (Strikethrough)
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: CustomText(
                              package['originalPrice'],
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Price
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomText(
                        package['price'],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
     }
}

// Custom Painter for Bonus Badge exactly like the image
class BonusBadgePainter extends CustomPainter {
  final Color baseColor;
  
  BonusBadgePainter(this.baseColor);
  
  @override
  void paint(Canvas canvas, Size size) {
    // Create gradient colors based on the base color
    final List<Color> gradientColors = _createGradientColors(baseColor);
    
    // Main rounded rectangle (full height minus small pointer space)
    final mainRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - 8),
      const Radius.circular(12),
    );
    
    // Gradient paint for main body
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: gradientColors,
      ).createShader(mainRect.outerRect)
      ..style = PaintingStyle.fill;
    
    // Draw main rounded rectangle
    canvas.drawRRect(mainRect, gradientPaint);
    
    // Create small triangular pointer at bottom RIGHT corner (like your image)
    final pointerPath = Path();
    final rightX = size.width - 12; // Position from right edge
    final bottomY = size.height - 8;
    
    // Small triangle pointer at bottom right - exactly like in your image
    pointerPath.moveTo(rightX - 3, bottomY); // Left point of triangle
    pointerPath.lineTo(rightX + 3, bottomY); // Right point of triangle  
    pointerPath.lineTo(rightX, size.height); // Bottom tip
    pointerPath.close();
    
    // Pointer paint (slightly darker than main gradient)
    final pointerPaint = Paint()
      ..color = gradientColors[1]
      ..style = PaintingStyle.fill;
    
    // Draw pointer
    canvas.drawPath(pointerPath, pointerPaint);
  }
  
  List<Color> _createGradientColors(Color baseColor) {
    // Create gradient exactly like your image - simple left to right
    if (baseColor == const Color(0xFFFFA726)) {
      // Yellow/Orange gradient like your image
      return [
        const Color(0xFFFFC107), // Yellow
        const Color(0xFFFF9800), // Orange
      ];
    } else if (baseColor == const Color(0xFFFF7043)) {
      // Orange/Red gradient like your image
      return [
        const Color(0xFFFF9800), // Orange
        const Color(0xFFFF5722), // Red-Orange
      ];
    } else {
      // Default
      return [baseColor, baseColor.withOpacity(0.8)];
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
