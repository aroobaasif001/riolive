import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';

import '../../../../../utile/dialog_helper.dart';

class InviteHostScreen extends StatefulWidget {
  const InviteHostScreen({super.key});

  @override
  State<InviteHostScreen> createState() => _InviteHostScreenState();
}

class _InviteHostScreenState extends State<InviteHostScreen> {
  final TextEditingController _inviterIdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ---- Fixed positions/heights (unchanged to match your design) ----
    const double side = 16;

    const double headerTop     = 200;
    const double headerHeight  = 51;

    const double cardTop       = 270;
    const double cardHeight    = 134;

    const double statsTop      = 470;
    const double statsHeight   = 92;

    const double invitesTop    = 580;
    const double invitesHeight = 382;

    const double bottomHeight   = 130;
    const double gapAboveBottom = 70;

    final double bottomTop    = invitesTop + invitesHeight + gapAboveBottom;
    final double canvasHeight = bottomTop + bottomHeight;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: CustomContainer(
              width: size.width,
              // ✅ Keep background image as requested
              image: const DecorationImage(
                image: AssetImage('assets/images/invite Hostbg.jpg'),
                fit: BoxFit.fill,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 6),

                  // AppBar (unchanged)
                  const RioliveAppBar(
                    title: 'Invite Friends',
                    titleFontWeight: FontWeight.w600,
                    titleFontSize: 20,
                  ),

                  // ======= Everything below is absolutely positioned =======
                  SizedBox(
                    height: canvasHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // ======= imagebginvite.png AS A FOREGROUND IMAGE (NOT BG) =======
                        Positioned(
                          // 🔧 You can adjust these to place the image where you want
                          top: 0,          // <- change as needed
                          left: 0,         // <- change as needed
                          right: 0,        // keeps it centered with the Center()
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

                        // ---------------- Purple header (full width) ----------------
                        Positioned(
                          left: 0,
                          right: 0,
                          top: headerTop,
                          child: CustomContainer(
                            width: size.width,
                            height: headerHeight,
                            conColor: const Color(0xFFBC9EF4),
                            alignment: Alignment.center,
                            child: const CustomText(
                              'Host Invitation',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [],
                            ),
                          ),
                        ),

                        // --------------- Inviter card + Rules + Send ---------------
                        Positioned(
                          left: side,
                          right: side,
                          top: cardTop,
                          child: SizedBox(
                            height: cardHeight,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Card
                                CustomContainer(
                                  width: double.infinity,
                                  borderRadius: BorderRadius.circular(28),
                                  conColor: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: const Color(0xFFE9E9EF),
                                    width: 1,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 4),
                                      const CustomText(
                                        "Enter the inviter’s ID",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFF9000),
                                        shadows: [],
                                      ),
                                      const SizedBox(height: 10),

                                      // rounded input
                                      CustomContainer(
                                        height: 45,
                                        width: 311,
                                        borderRadius: BorderRadius.circular(40),
                                        conColor: const Color(0xFFEDEDF0),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 26),
                                        child: TextField(
                                          controller: _inviterIdCtrl,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: const InputDecoration(
                                            isCollapsed: true,
                                            border: InputBorder.none,
                                            hintText: 'Please enter the inviter ID',
                                            hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF9EA0A8),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Rules button (unchanged)
                                Positioned(
                                  right: -50,
                                  bottom: 250,
                                  child: InkWell(
                                    onTap: () => showRulesDialog(context),
                                    child: CustomContainer(
                                      height: 36,
                                      width: 104,
                                      borderRadius: BorderRadius.circular(22),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF3B38FD),
                                          Color(0xFF7EFFA5),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF7D86FF).withOpacity(.28),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: const Color(0xff9557F9),
                                        width: 2,
                                      ),
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

                                // Send button (floating)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: -28,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        // TODO: send logic
                                      },
                                      child: CustomContainer(
                                        height: 45,
                                        width: 161,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: Color(0xff9557F9), width: 2),
                                        gradient: const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFF46B4FF),
                                            Color(0xFFFF7F87),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.12),
                                            blurRadius: 16,
                                            offset: Offset(0, 6),
                                          ),
                                        ],
                                        alignment: Alignment.center,
                                        child: const CustomText(
                                          'Send',
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          shadows: [],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ------------------- Stats container (no dividers) -------------------
                        Positioned(
                          left: side,
                          right: side,
                          top: statsTop,
                          child: CustomContainer(
                            height: statsHeight,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(22),
                            conColor: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.08),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFE6E6EE),
                              width: 1,
                            ),
                            child: const Row(
                              children: [
                                _StatCell(title: 'Total Inviter', value: '0'),
                                _StatCell(title: 'Pending', value: '0'),
                                _StatCell(title: 'Accepted', value: '0'),
                              ],
                            ),
                          ),
                        ),

                        // ------------------- My Invitations -------------------
                        Positioned(
                          left: side,
                          right: side,
                          top: invitesTop,
                          child: CustomContainer(
                            height: invitesHeight,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(28),
                            conColor: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xFFE9E9EF),
                              width: 1,
                            ),
                            child: const Column(
                              children: [
                                SizedBox(height: 24),
                                CustomText(
                                  'My Invitations',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  shadows: [],
                                ),
                                SizedBox(height: 20),
                                Divider(
                                  height: 1,
                                  thickness: 0.6,
                                  color: Color(0xFFEDEAFB),
                                ),
                                SizedBox(height: 60),
                                CustomText(
                                  "You haven’t  invited anyone yet",
                                  color: Color(0xFFB7B8C2),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  shadows: [],
                                ),
                              ],
                            ),
                          ),
                        ),


                        // -------- Bottom purple area with green "Invite Now" --------
                        Positioned(
                          left: 0,
                          right: 0,
                          top: bottomTop,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 1, 0),
                            child: SizedBox(
                              height: bottomHeight,
                              child: Stack(
                                children: [
                                  CustomContainer(
                                    height: bottomHeight,
                                    width: double.infinity,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    conColor: const Color(0xFFCDB3F6),
                                  ),
                              Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => InviteDialog.showInviteSheet(context),
                                  child: CustomContainer(
                                    // ❌ onTap: ...  <-- remove this
                                    height: 55,
                                    width: 187,
                                    borderRadius: BorderRadius.circular(28),
                                    conColor: const Color(0xFF73F277),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                    alignment: Alignment.center,
                                    child: const CustomText(
                                      'Invite Now',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      shadows: [],
                                    ),
                                  ),
                                ),
                              ),

                              ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // No extra spacer needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ====== Helpers for the stats cells (no divider) ======
class _StatCell extends StatelessWidget {
  final String title;
  final String value;
  const _StatCell({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomContainer(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              value,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              shadows: const [],
            ),
            const SizedBox(height: 6),
            CustomText(
              title,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8D8E98),
              shadows: const [],
            ),
          ],
        ),
      ),
    );
  }
}
