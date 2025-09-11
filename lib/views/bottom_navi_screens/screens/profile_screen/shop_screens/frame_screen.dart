import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/settings_screen/settings_screen.dart';

import '../../../../../customwidgets/customtext.dart';
import '../../../../../utile/dialog_helper.dart';

/// ===== Responsive helper (baseline 390x844) =====
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

class FrameScreen extends StatefulWidget {
  const FrameScreen({super.key});

  @override
  _FrameScreenState createState() => _FrameScreenState();
}

class _FrameScreenState extends State<FrameScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final r  = context.rs;

    return Scaffold(
      extendBodyBehindAppBar: true, // 👈 background goes behind app bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(r.h(56)),
        child: const RioliveAppBar(title: 'Frame'), // 👈 app bar at the top now
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/invite Hostbg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: MediaQuery(
          data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: SafeArea(
            top: false, // 👈 let content start under the app bar edge
            bottom: true,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  r.hGap(85), // 👈 spacer so content appears below the app bar

                  // === Preview / Selected big item ===
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.w(12)),
                    child: Container(
                      height: r.h(194),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: r.px(1),
                            offset: Offset(0, r.h(4)),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/ff1.png', height: r.h(108), width: r.w(108)),
                          Text(
                            'Angle',
                            style: TextStyle(
                              fontSize: r.sp(14),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  r.hGap(10),

                  // === Row 1 ===
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: r.w(7)),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _rideItem(0, "assets/icons/ff1.png", "Angle", "360,000"),
                        r.wGap(0),
                        _rideItem(1, "assets/icons/ff2.png", "Floral Bike", "360,000"),
                        r.wGap(0),
                        _rideItem(2, "assets/icons/ff3.png", "Floral Bike", "360,000"),
                      ],
                    ),
                  ),

                  r.hGap(20),

                  // === Row 2 ===
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: r.w(7)),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _rideItem(3, "assets/icons/ff4.png", "Floral Bike", "360,000"),
                        r.wGap(0),
                        _rideItem(4, "assets/icons/ff5.png", "Floral Bike", "360,000"),
                        r.wGap(0),
                        _rideItem(5, "assets/icons/ff6.png", "Floral Bike", "360,000"),
                      ],
                    ),
                  ),

                  r.hGap(20),

                  // === Row 3 ===
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: r.w(7)),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _rideItem(6, "assets/icons/f7.png", "Floral Bike", "360,000"),
                        r.wGap(0),
                        _rideItem(7, "assets/icons/f7.png", "Floral Bike", "360,000"),
                        r.wGap(0),
                        _rideItem(8, "assets/icons/f7.png", "Floral Bike", "360,000"),
                      ],
                    ),
                  ),

                  r.hGap(40),

                  // === Bottom purchase bar ===
                  Container(
                    height: r.h(77),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffEEBFBF),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(r.px(20)),
                        topLeft:  Radius.circular(r.px(20)),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: r.w(12)),
                      child: Row(
                        children: [
                          Image.asset('assets/images/daimondlastframe.png', height: r.h(18), width: r.w(16)),
                          r.wGap(6),
                          CustomText('360,000', fontWeight: FontWeight.w400, fontSize: r.sp(14)),
                          const Spacer(),
                          ConstrainedBox(
                            constraints: BoxConstraints(minWidth: r.w(128)),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: CustomGradientButton(
                                text: 'Purchase',
                                onPressed: () => showAngelGiftBottomSheet(context),
                                width:  r.w(114),
                                height: r.h(36),
                                textColor: Color(0xff373434),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
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
        ),
      ),
    );
  }

  // ==== Item card with selected state (responsive) ====
  Widget _rideItem(int index, String asset, String label, String price) {
    final r = context.rs;
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = isSelected ? null : index),
      child: Container(
        height: r.h(151),
        width:  r.w(125),
        padding: EdgeInsets.symmetric(horizontal: r.w(8), vertical: r.h(10)),
        margin: EdgeInsets.only(right: r.w(0)),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(r.px(12)),
          border: isSelected ? Border.all(color: const Color(0xffDF9B44), width: r.px(1)) : null,
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: r.px(10), offset: Offset(0, r.h(4)))]
              : null,
        ),
        child: Column(
          children: [
            Image.asset(asset, height: r.h(80), width: r.w(80), fit: BoxFit.contain),
            SizedBox(height: r.h(8)),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: r.sp(11),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: r.h(4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/f15daimend.png', height: r.h(14), width: r.w(14), fit: BoxFit.contain),
                SizedBox(width: r.w(4)),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: r.sp(12),
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
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
