import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/invite_screens/invitehost_screen.dart';

import '../../../../../utile/dialog_helper.dart';

// ===== Responsive helper (baseline 390x844) =====
class RS {
  final BuildContext context;
  late final Size _s;
  late final double _sw, _sh, _k;
  static const baseW = 390.0, baseH = 844.0;
  RS(this.context) {
    _s = MediaQuery.of(context).size;
    _sw = _s.width / baseW;
    _sh = _s.height / baseH;
    _k  = math.min(_sw, _sh);
  }
  double w(num v)  => v * _sw;   // width-based
  double h(num v)  => v * _sh;   // height-based
  double sp(num v) => v * _k;    // font/icon/radius
  double px(num v) => v * _k;
  SizedBox hGap(num v) => SizedBox(height: h(v));
  SizedBox wGap(num v) => SizedBox(width:  w(v));
}
extension RSX on BuildContext { RS get rs => RS(this); }

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final r  = context.rs;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: mq.size.height),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ========= BG IMAGE =========
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/invite Hostbg.jpg',
                    fit: BoxFit.fill,
                  ),
                ),

                // ========= FOREGROUND DECOR IMAGE =========
                Positioned(
                  top: r.h(50),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width:  r.w(361),
                      height: r.h(284),
                      child: Image.asset(
                        'assets/images/imagebginvite.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // ========= CONTENT =========
                CustomContainer(
                  width: mq.size.width,
                  conColor: Colors.transparent,
                  child: MediaQuery(
                    data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        r.hGap(6),
                        RioliveAppBar(
                          title: 'Invite Friends',
                          titleFontWeight: FontWeight.w600,
                          titleFontSize: r.sp(20),
                        ),

                        // =================== TOP STACK ===================
                        Padding(
                          padding: EdgeInsets.fromLTRB(r.w(16), r.h(6), r.w(16), 0),
                          child: SizedBox(
                            height: r.h(190),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Rules pill (anchored to right)
                                Positioned(
                                  right: r.w(-55),
                                  top:   r.h(100),
                                  child: InkWell(
                                    onTap: () => showRulesDialog(context),
                                    child: CustomContainer(
                                      height: r.h(36),
                                      width:  r.w(104),
                                      borderRadius: BorderRadius.circular(r.px(22)),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Color(0xFF3B38FD), Color(0xFF7EFFA5)],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF7D86FF).withOpacity(.28),
                                          blurRadius: r.px(12),
                                          offset: Offset(0, r.h(6)),
                                        ),
                                      ],
                                      border: Border.all(color: const Color(0xff9557F9), width: r.px(2)),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomText(
                                            'Rules',
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: r.sp(14),
                                            shadows: const [],
                                          ),
                                          SizedBox(width: r.w(6)),
                                          Icon(Icons.keyboard_arrow_right, size: r.sp(18), color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // Stats card (pulled down)
                                Positioned(
                                  left: r.w(0),
                                  right: r.w(0),
                                  top: r.h(295),
                                  child: _StatsCardMinusClaim(),
                                ),

                                // Floating CLAIM button (anchored to right over stats)
                                Positioned(
                                  right: r.w(10),
                                  top:   r.h(370),
                                  child: CustomContainer(
                                    height: r.h(26),
                                    width:  r.w(86),
                                    borderRadius: BorderRadius.circular(r.px(22)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF7A8CFF).withOpacity(.24),
                                        blurRadius: r.px(10),
                                        offset: Offset(0, r.h(4)),
                                      ),
                                    ],
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CustomContainer(
                                          borderRadius: BorderRadius.circular(r.px(22)),
                                          border: Border.all(color: const Color(0xFF7AA3FF), width: r.px(1)),
                                        ),
                                        CustomContainer(
                                          height: r.h(24),
                                          width:  r.w(88),
                                          borderRadius: BorderRadius.circular(r.px(18)),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [Color(0xFF38C3FD), Color(0xFFFF7E92)],
                                          ),
                                          alignment: Alignment.center,
                                          child: CustomText(
                                            'Claim',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: r.sp(14),
                                            shadows: const [],
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

                        r.hGap(220),

                        // =================== INVITATIONS CARD ===================
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: r.w(16)),
                          child: CustomContainer(
                            height: r.h(382),
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(r.px(28)),
                            conColor: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: r.px(16),
                                offset: Offset(0, r.h(8)),
                              ),
                            ],
                            border: Border.all(color: const Color(0xFFE9E9EF), width: r.px(1)),
                            child: Column(
                              children: [
                                r.hGap(24),
                                CustomText(
                                  'My Invitations',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: r.sp(14),
                                  shadows: const [],
                                ),
                                r.hGap(24),
                                const Divider(height: 1, thickness: 0.6, color: Color(0xFFEDEAFB)),
                                r.hGap(36),
                                CustomText(
                                  'You haven’t  invited anyone yet',
                                  color: const Color(0xFFB7B8C2),
                                  fontWeight: FontWeight.w500,
                                  fontSize: r.sp(13),
                                  shadows: const [],
                                ),
                                r.hGap(34),
                              ],
                            ),
                          ),
                        ),

                        // =================== INVITE BUTTON ===================
                        r.hGap(50),
                        GestureDetector(
                          onTap: () {

                            Get.to(()=>InviteHostScreen());
                          },
                          child: Center(
                            child: CustomContainer(
                              height: r.h(55),
                              width:  r.w(187),
                              borderRadius: BorderRadius.circular(r.px(26)),
                              gradient: const LinearGradient(colors: [Color(0xCC64FF6C), Color(0xCC64FF6C)]),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7BE48E).withOpacity(.35),
                                  blurRadius: r.px(14),
                                  offset: Offset(0, r.h(6)),
                                ),
                              ],
                              alignment: Alignment.center,
                              child: CustomText(
                                'Invite',
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: r.sp(16),
                                shadows: const [],
                              ),
                            ),
                          ),
                        ),

                        r.hGap(24),
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
}

/// Stats card (responsive)
class _StatsCardMinusClaim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = context.rs;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.w(16)),
      child: CustomContainer(
        height: r.h(93),
        width: double.infinity,
        borderRadius: BorderRadius.circular(r.px(26)),
        conColor: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: r.px(16),
            offset: Offset(0, r.h(8)),
          ),
        ],
        border: Border.all(color: const Color(0xFFE6E6EE), width: r.px(1)),
        padding: EdgeInsets.fromLTRB(r.w(25), r.h(1), r.w(25), r.h(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left stat
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: r.w(25)),
                  child: CustomText(
                    '0',
                    fontSize: r.sp(18),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    shadows: const [],
                  ),
                ),
                r.hGap(6),
                CustomText(
                  'Register Invite',
                  fontSize: r.sp(12),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8D8E98),
                  shadows: const [],
                ),
              ],
            ),
            const Spacer(),
            // Right stat
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: r.w(19)),
                  child: CustomText(
                    '0',
                    fontSize: r.sp(18),
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    shadows: const [],
                  ),
                ),
                r.hGap(6),
                CustomText(
                  'My Reward',
                  fontSize: r.sp(12),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8D8E98),
                  shadows: const [],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
