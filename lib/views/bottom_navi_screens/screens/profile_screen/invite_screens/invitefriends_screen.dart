import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';

import '../../../../../utile/dialog_helper.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            // ✅ Ensures the background container is at least full screen height
            constraints: BoxConstraints(minHeight: size.height),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ========= BG IMAGE inside Stack (fills whole area) =========
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/invite Hostbg.jpg',
                    fit: BoxFit.fill, // ✅ true full-screen background
                  ),
                ),

                // ========= FOREGROUND DORY IMAGE (NOT BG) =========
                Positioned(
                  top: 50,    // 🔧 adjust if needed
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 361,
                      height: 284,
                      child: Image.asset(
                        'assets/images/imagebginvite.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // ========= ORIGINAL CONTENT (UNCHANGED) =========
                CustomContainer(
                  width: size.width,
                  // No decoration image here now; keep container transparent
                  conColor: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 6),
                      const RioliveAppBar(
                        title: 'Invite Friends',
                        titleFontWeight: FontWeight.w600,
                        titleFontSize: 20,
                      ),

                      // =================== TOP STACK ===================
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                        child: SizedBox(
                          // ✅ finite height prevents size.isFinite assertion
                          height: 190,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Rules pill (right)
                              Positioned(
                                left: 300, // ya MediaQuery se responsive kar sakte ho
                                top: 100,
                                child: InkWell(
                                  onTap: () {
                                    showRulesDialog(context); // ✅ recommended
                                  },
                                  child: CustomContainer(
                                    height: 36,
                                    width: 104,
                                    borderRadius: BorderRadius.circular(22),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFF3B38FD), Color(0xFF7EFFA5)],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF7D86FF).withOpacity(.28),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                    border: Border.all(color: const Color(0xff9557F9), width: 2),
                                    alignment: Alignment.center,
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomText(
                                          'Rules',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          shadows: [],
                                        ),
                                        SizedBox(width: 6),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Stats card (pulled-down look)
                              const Positioned(
                                left: 0,
                                right: 0,
                                top: 295,
                                child: _StatsCardMinusClaim(), // no claim inside
                              ),

                              // ✅ Floating CLAIM button inside the same stack
                              Positioned(
                                right: 10,  // 🔧 sit over the right side of the stats card
                                top: 370,    // 🔧 card top (40) + internal offset
                                child: CustomContainer(
                                  height: 26,
                                  width: 86,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF7A8CFF).withOpacity(.24),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomContainer(
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          color: const Color(0xFF7AA3FF),
                                          width: 1,
                                        ),
                                      ),
                                      CustomContainer(
                                        height: 24,
                                        width: 88,
                                        borderRadius: BorderRadius.circular(18),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [Color(0xFF38C3FD), Color(0xFFFF7E92)],
                                        ),
                                        alignment: Alignment.center,
                                        child: const CustomText(
                                          'Claim',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          shadows: [],
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

                      const SizedBox(height: 220),

                      // =================== INVITATIONS CARD ===================
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomContainer(
                          height: 382,
                          width: 385,
                          borderRadius: BorderRadius.circular(28),
                          conColor: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(color: const Color(0xFFE9E9EF), width: 1),
                          child: const Column(
                            children: [
                              SizedBox(height: 24),
                              CustomText(
                                'My Invitations',
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                shadows: [],
                              ),
                              SizedBox(height: 24),
                              Divider(
                                height: 1,
                                thickness: 0.6,
                                color: Color(0xFFEDEAFB),
                              ),
                              SizedBox(height: 36),
                              CustomText(
                                'You haven’t  invited anyone yet',
                                color: Color(0xFFB7B8C2),
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                shadows: [],
                              ),
                              SizedBox(height: 34),
                            ],
                          ),
                        ),
                      ),

                      // =================== INVITE BUTTON ===================
                      const SizedBox(height: 50),
                      Center(
                        child: CustomContainer(
                          height: 55,
                          width: 187,
                          borderRadius: BorderRadius.circular(26),
                          gradient: const LinearGradient(
                            colors: [Color(0xCC64FF6C), Color(0xCC64FF6C)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7BE48E).withOpacity(.35),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          alignment: Alignment.center,
                          child: const CustomText(
                            'Invite',
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            shadows: [],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Stats card (same as before, but WITHOUT the Claim button inside)
class _StatsCardMinusClaim extends StatelessWidget {
  const _StatsCardMinusClaim();

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 93,
      width: 385,
      borderRadius: BorderRadius.circular(26),
      conColor: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
      border: Border.all(color: const Color(0xFFE6E6EE), width: 1),
      padding: const EdgeInsets.fromLTRB(25, 1, 25, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          // Left stat
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: CustomText(
                  '0',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  shadows: [],
                ),
              ),
              SizedBox(height: 6),
              CustomText(
                'Register Invite',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8D8E98),
                shadows: [],
              ),
            ],
          ),
          Spacer(),
          // Right stat
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 19),
                child: CustomText(
                  '0',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  shadows: [],
                ),
              ),
              SizedBox(height: 6),
              CustomText(
                'My Reward',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8D8E98),
                shadows: [],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
