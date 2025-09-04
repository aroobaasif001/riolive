import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/roundActionButton.dart';
import 'package:riolive/customwidgets/startColumn.dart';
import 'package:riolive/utile/app_url.dart';

import 'actionButton.dart';
import 'customtext.dart';
import 'medalIcon.dart';

void showProfilePopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context),
        child: DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controller) {
            return CustomContainer(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8B4F8),
                  Color(0xFFD8A7F8),
                  Color(0xFFC89AF8),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),

              child: Column(
                children: [
                  // Handle bar
                  CustomContainer(
                    margin: EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    conColor: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),

                  // Top icons row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/icons/warning.png",
                          width: 24,
                          height: 24,
                        ),
                        Icon(
                          Icons.alternate_email,
                          color: Colors.black,
                          size: 24,
                        ),
                      ],
                    ),
                  ),

                  // Profile section
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [
                        // Profile picture
                        CustomContainer(
                          width: 80,
                          height: 80,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),

                          child: CircleAvatar(
                            radius: 37,
                            backgroundImage: AssetImage(
                              'assets/images/profile.jpg',
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        // Name and verification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              "${AppUrl.user_name}",
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.verified, color: Colors.blue, size: 20),
                          ],
                        ),

                        SizedBox(height: 8),

                        // ID and location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomContainer(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),

                              // conColor: Colors.blue.withOpacity(0.2),
                              // borderRadius: BorderRadius.circular(12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/icons/id.png",
                                    width: 36,
                                    height: 36,
                                  ),
                                  CustomText(
                                    ": ${AppUrl.riolive_id}",
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(width: 6),

                                  Icon(
                                    Icons.copy_outlined,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 8),
                            Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 22,
                            ),
                            CustomText(
                              "India",
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.female, color: Colors.pink, size: 22),
                          ],
                        ),

                        SizedBox(height: 8),

                        // Level and VIP badges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomContainer(
                              child: Image.asset(
                                "assets/icons/level.png", // 👈 آپ اپنا path بدل لیں
                                height: 26,
                              ),
                            ),
                            SizedBox(width: 8),
                            CustomContainer(
                              child: Image.asset(
                                "assets/icons/mic.png", // 👈 آپ اپنا path بدل لیں
                                height: 26,
                              ),
                            ),
                            SizedBox(width: 8),
                            CustomContainer(
                              child: Image.asset(
                                "assets/icons/vip_4.png", // 👈 آپ اپنا path بدل لیں
                                height: 26,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Medal Wall section
                  CustomContainer(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                      left: 30,
                      right: 30,
                    ),
                    conColor: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        CustomText(
                          "Medal Wall :",
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 8),

                        medalIcon('assets/icons/medal_1.png'),
                        SizedBox(width: 8),
                        medalIcon('assets/icons/medal_2.png'),
                        SizedBox(width: 8),
                        medalIcon('assets/icons/medal_3.png'),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Stats section
                  CustomContainer(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(12),
                    conColor: Colors.blueAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        statColumn("0", "Followers"),
                        Container(width: 1, height: 30, color: Colors.grey),
                        statColumn("0", "Following"),
                        Container(width: 1, height: 30, color: Colors.grey),
                        statColumn("0", "Send"),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: actionButton(
                            "Follow",
                            Colors.purple,
                            LinearGradient(
                              colors: [
                                Color(0xFF8A3FFC), // Purple
                                Color(0xFFD16BA5), // Pinkish purple
                                Color(0xFFFF6F61), // Coral pink
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        roundActionButton('assets/icons/message.png'),
                        SizedBox(width: 12),
                        roundActionButton('assets/icons/call.png'),
                        SizedBox(width: 12),
                        roundActionButton('assets/icons/gift.png'),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
