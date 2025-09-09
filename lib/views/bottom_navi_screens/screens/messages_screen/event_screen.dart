import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart';

/// --- Responsive helper (baseline 390x844) ---
class RS {
  final BuildContext context;
  late final Size _s;
  late final double _sw, _sh, _k;
  static const baseW = 390.0, baseH = 844.0;
  RS(this.context) {
    _s  = MediaQuery.of(context).size;
    _sw = _s.width / baseW;
    _sh = _s.height / baseH;
    _k  = math.min(_sw, _sh);
  }
  double w(num v)  => v * _sw;   // scale by width
  double h(num v)  => v * _sh;   // scale by height
  double sp(num v) => v * _k;
  double px(num v) => v * _k;
  SizedBox hGap(num v) => SizedBox(height: h(v));
}
extension RSX on BuildContext { RS get rs => RS(this); }

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final r  = context.rs;
    final double radius = r.px(14);

    return SafeArea(
      child: Scaffold(
        body: MediaQuery(
          data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: CustomContainer(
            width: double.infinity,
            height: double.infinity,
            image: const DecorationImage(
              image: AssetImage('assets/images/Livebroadcastdatabg.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: r.h(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RioliveAppBar(title: 'Events'),
                  r.hGap(12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.w(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _EventItem(
                          rs: r,
                          title: 'Combat pack',
                          date: 'Coming out on 27-06',
                          assetPath: 'assets/images/e1.png',
                          radius: radius,
                        ),
                        r.hGap(20),
                        _EventItem(
                          rs: r,
                          title: 'Fish hunters',
                          date: 'Coming out on 27-06',
                          assetPath: 'assets/images/e2.png',
                          radius: radius,
                        ),
                        r.hGap(20),
                        _EventItem(
                          rs: r,
                          title: 'Bravery & Greed',
                          date: 'Coming out on 27-06',
                          assetPath: 'assets/images/e3.png',
                          radius: radius,
                        ),
                      ],
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
}

class _EventItem extends StatelessWidget {
  final RS rs;
  final String title;
  final String date;
  final String assetPath;
  final double radius;

  const _EventItem({
    required this.rs,
    required this.title,
    required this.date,
    required this.assetPath,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    // 🔑 Height tied to WIDTH scale (keeps banner ratio consistent)
    final double h = rs.w(138);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title,
          fontSize: rs.sp(16),
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          shadows: const [],
        ),
        rs.hGap(4),
        CustomText(
          date,
          fontSize: rs.sp(12.5),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF8F95A3),
          shadows: const [],
        ),
        rs.hGap(12),

        // Rounded image card with soft shadow
        CustomContainer(
          width: double.infinity,
          height: h,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: rs.px(12),
              offset: Offset(0, rs.h(6)),
            ),
          ],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.asset(
              assetPath,
              width: double.infinity,
              height: h,
              fit: BoxFit.cover, // crops evenly, matches screenshot look
            ),
          ),
        ),
      ],
    );
  }
}
