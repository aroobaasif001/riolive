import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/shop_screens/frame_screen.dart';

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

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final r  = RS(context);

    // paddings & gaps (scaled)
    final double horizontalPad = r.w(0);
    final double topGridGap    = r.w(10); // 👈 sirf top grid ke liye
    final double mainGridGap   = r.w(3);  // 👈 Ride/Entrance/Frame sections ke liye

    return Scaffold(
      extendBodyBehindAppBar: true, // background image appbar ke peeche bhi dikhayega
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(r.h(56)),
        child: const RioliveAppBar(title: 'Shop'),
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
            top: false, // appbar ko bilkul top pe chipkayega
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  r.hGap(70),
                  // ===== Top grid (3 items x 2 rows) — uses topGridGap =====
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                    child: _Grid3(
                      gap: topGridGap, // 👈 separate gap
                      children: [
                        _TopItem(
                          asset: "assets/images/f.png",
                          label: "Frame",
                          onTap: () => Get.to(() => const FrameScreen()),
                        ),
                        _TopItem(
                          asset: "assets/images/f1.png",
                          label: "Party Theme",
                          onTap: () {
                            showRoomSettingsBottomSheet(
                              context,
                              initialMode: 1,   // 0 = Open, 1 = Invitation
                              initialSeats: 1,  // default selected seat
                              onModeChanged: (mode) {
                                // handle mode change
                                print("Mode selected: $mode");
                              },
                              onSeatChanged: (seat) {
                                // handle seat change
                                print("Seat selected: $seat");
                              },
                            );
                          },
                        ),

                        _TopItem(
                          asset: "assets/images/f2.png",
                          label: "Chat Bubble",
                          onTap: () {
                            showLiveEndDialog(
                              context,
                              viewers: 5482,
                              newFans: 5482,
                              coins: 100000,
                              callDuration: const Duration(minutes: 9),
                              liveTime: const Duration(minutes: 59),
                              fansAmount: 5,
                              bgImage: 'assets/images/invite Hostbg.jpg',   // background
                              badgeImage: 'assets/images/imagetop1.png',    // center badge
                            );
                          },
                        ),

                        const _TopItem(asset: "assets/images/f3.png", label: "Special ID"),
                        const _TopItem(asset: "assets/images/f4.png", label: "Entrance"),
                        const _TopItem(asset: "assets/images/f5.png", label: "Ride"),
                      ],
                    ),
                  ),

                  r.hGap(10),
                  Padding(
                    padding: EdgeInsets.only(left: r.w(25), right: r.w(20)),
                    child: Divider(thickness: r.px(1.5), color: Colors.black12),
                  ),

                  // ===== Ride =====
                  _SectionTitle(title: "Ride"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.w(15)),
                    child: _Grid3(
                      gap: mainGridGap, // 👈 main sections gap
                      children: const [
                        _ShopCard(asset: "assets/images/f6.png",  label: "Pink Rose Carriage",  price: "360,000"),
                        _ShopCard(asset: "assets/images/f7.png",  label: "Ultimate Sports Car",  price: "360,000"),
                        _ShopCard(asset: "assets/images/f8.png",  label: "Luxury Car Beauty",    price: "360,000"),
                      ],
                    ),
                  ),

                  r.hGap(20),

                  // ===== Entrance =====
                  _SectionTitle(title: "Entrance"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.w(15)),
                    child: _Grid3(
                      gap: mainGridGap,
                      children: const [
                        _ShopCard(asset: "assets/images/f9.png",  label: "Luxury Sports Ride", price: "360,000"),
                        _ShopCard(asset: "assets/images/f10.png", label: "Aurora Sports Car",  price: "360,000"),
                        _ShopCard(asset: "assets/images/f11.png", label: "Wansheng Car",       price: "360,000"),
                      ],
                    ),
                  ),

                  r.hGap(20),

                  // ===== Frame =====
                  _SectionTitle(title: "Frame"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.w(15)),
                    child: _Grid3(
                      gap: mainGridGap,
                      children: const [
                        _ShopCard(asset: "assets/images/f12.png", label: "Floral Bike", price: "360,000"),
                        _ShopCard(asset: "assets/images/f13.png", label: "Floral Bike", price: "360,000"),
                        _ShopCard(asset: "assets/images/f14.png", label: "Floral Bike", price: "360,000"),
                      ],
                    ),
                  ),

                  r.hGap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ====== 3-column responsive row without overflow ======
class _Grid3 extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  const _Grid3({required this.children, required this.gap});

  @override
  Widget build(BuildContext context) {
    final r = RS(context);
    return LayoutBuilder(
      builder: (context, c) {
        final totalWidth = c.maxWidth;
        // 3 columns → 2 gaps between them
        final itemW = (totalWidth - gap * 2) / 3;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children.map((w) {
            return SizedBox(width: itemW, child: w);
          }).toList(),
        );
      },
    );
  }
}

/// ===== Top item (icon + label) with ripple & onTap =====
class _TopItem extends StatelessWidget {
  final String asset, label;
  final VoidCallback? onTap;

  const _TopItem({
    required this.asset,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = RS(context);
    final radius = BorderRadius.circular(r.px(12));

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: r.h(4), horizontal: r.w(4)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                asset,
                height: r.h(70),
                width: r.w(70),
                fit: BoxFit.contain,
              ),
              r.hGap(6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: r.sp(14),
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===== Section title with "All >" =====
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final r = RS(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.w(20), vertical: r.h(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: r.sp(20),
                fontWeight: FontWeight.w800,
                color: Colors.black,
              )),
          Text("All >",
              style: TextStyle(
                fontSize: r.sp(18),
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              )),
        ],
      ),
    );
  }
}

/// ===== Shop card (image + label + price with diamond) =====
class _ShopCard extends StatelessWidget {
  final String asset, label, price;
  const _ShopCard({required this.asset, required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    final r = RS(context);
    return Container(
      height: r.h(152),
      width:  double.infinity, // width given by _Grid3
      padding: EdgeInsets.symmetric(horizontal: r.w(0), vertical: r.h(10)),
      decoration: BoxDecoration(
        border: Border.all(width: r.px(0.5), color: Colors.grey.withOpacity(0.5)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.px(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: r.px(10),
            offset: Offset(0, r.h(4)),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(asset, height: r.h(80), width: r.w(80), fit: BoxFit.contain),
          r.hGap(8),
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
          r.hGap(4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/f15daimend.png', height: r.h(14), width: r.w(14), fit: BoxFit.contain),
              r.wGap(5),
              Text(
                price,
                style: TextStyle(
                  fontSize: r.sp(12),
                  fontWeight: FontWeight.w500,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
