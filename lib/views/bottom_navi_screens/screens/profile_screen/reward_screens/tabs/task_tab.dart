import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

/// ==== Responsive helper (baseline 390x844) ====
class RS {
  final BuildContext context;
  late final Size _s;
  late final double _sw, _sh, _k;
  static const baseW = 390.0, baseH = 844.0;
  RS(this.context) {
    _s = MediaQuery.of(context).size;
    _sw = _s.width / baseW;
    _sh = _s.height / baseH;
    _k = math.min(_sw, _sh);
  }
  double w(num v) => v * _sw;
  double h(num v) => v * _sh;
  double sp(num v) => v * _k;
  double px(num v) => v * _k;
  SizedBox hGap(num v) => SizedBox(height: h(v));
  SizedBox wGap(num v) => SizedBox(width: w(v));
}
extension RSX on BuildContext { RS get rs => RS(this); }

/// ==== Reusable atoms ====
class GButton extends StatelessWidget {
  final String text;
  final bool success;
  const GButton({super.key, required this.text, this.success = false});
  @override
  Widget build(BuildContext context) {
    final r = context.rs;
    return CustomContainer(
      width: r.w(62), height: r.h(28), alignment: Alignment.center,
      borderRadius: BorderRadius.circular(r.px(24)),
      gradient: success
          ? const LinearGradient(colors: [Color(0xFF7EFF96), Color(0xFF7DD0B7), Color(0xFF7B6AFF)])
          : const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFE87EFF), Color(0xFFA96AFF)]),
      child: CustomText(text, color: Colors.white, fontSize: r.sp(12), fontWeight: FontWeight.w600),
    );
  }
}

class DayTile extends StatelessWidget {
  final String label; final double w; final double h; final double imgH;
  const DayTile({super.key, required this.label, required this.w, required this.h, required this.imgH});
  @override
  Widget build(BuildContext context) {
    final r = context.rs;
    return CustomContainer(
      width: r.w(w), height: r.h(h),
      borderRadius: BorderRadius.circular(r.px(18)),
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
        Colors.white.withOpacity(.45), Colors.white.withOpacity(.30),
      ]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset('assets/images/Layer 4.png', height: r.h(imgH), fit: BoxFit.contain),
        SizedBox(height: r.h(6)),
        CustomText(label, fontSize: r.sp(12), color: const Color(0xFF6A6A6A), fontWeight: FontWeight.w600),
      ]),
    );
  }
}

class RewardItem extends StatelessWidget {
  final String img, title; final double labelW;
  const RewardItem({super.key, required this.img, required this.title, required this.labelW});
  @override
  Widget build(BuildContext context) {
    final r = context.rs;
    return Column(children: [
      CustomContainer(
        height: r.h(48), width: r.w(50),
        borderRadius: BorderRadius.circular(r.px(16)),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0x1AD9D9D9), Color(0x80FFFFFF)]),
        child: Image.asset(img, fit: BoxFit.contain),
      ),
      SizedBox(height: r.h(6)),
      SizedBox(
        width: r.w(labelW),
        child: CustomText(title, textAlign: TextAlign.center, maxLines: 2,
            overflow: TextOverflow.ellipsis, color: Colors.black, fontSize: r.sp(8), fontWeight: FontWeight.w600, lineHeight: 1.2),
      ),
    ]);
  }
}

class TaskCard extends StatelessWidget {
  final String title, subtitle, reward; final bool claimed;
  const TaskCard({super.key, required this.title, required this.subtitle, required this.reward, this.claimed=false});
  @override
  Widget build(BuildContext context) {
    final r = context.rs;
    return CustomContainer(
      height: r.h(82), width: double.infinity,
      padding: EdgeInsets.fromLTRB(r.w(16), r.h(12), r.w(12), r.h(12)),
      conColor: const Color(0xFFF2F1FF),
      borderRadius: BorderRadius.circular(r.px(22)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: r.w(14), offset: Offset(0, r.h(8)))],
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomText(title, fontSize: r.sp(14), fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A)),
          SizedBox(height: r.h(6)),
          CustomText(subtitle, fontSize: r.sp(12), lineHeight: 1.25, color: const Color(0xFF8A8A8F), fontWeight: FontWeight.w500, maxLines: 2),
        ])),
        SizedBox(width: r.w(1)),
        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Image.asset('assets/icons/diamond_icon 2 1.png', width: r.h(18), height: r.h(18)),
            SizedBox(width: r.w(6)),
            CustomText(reward, color: Colors.black, fontWeight: FontWeight.w600, fontSize: r.sp(12)),
          ]),
          GButton(text: claimed ? 'Claimed' : 'Go', success: claimed),
        ]),
      ]),
    );
  }
}

/// ==== Screen ====
class TaskTab extends StatelessWidget {
  const TaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final r = context.rs;

    // data-driven (less lines, easy to change)
    const rewards = [
      ('assets/images/1.png',    'Decor - Star Trek', 74.0),
      ('assets/images/2.png',    'Bike Fire',         72.0),
      ('assets/images/car.png',  'Ferrari car',       72.0),
      ('assets/images/last.png', 'Goddess Crown',     72.0),
    ];
    const tasks = [
      ('call match 0/1',   'Complete 1 random call matches for\n more than 1 minutes', 'x100', true),
      ('Friend interaction 0/1','Send 5 messages to each other\n with friends','x50', false),
      ('To attend a party 0/1','Speak for more than 1 minutes in\n the party room','x100', false),
      ('invite Friend 0/1','invite friend when they join app\n & top-up 15k with your reference you get extra','x200', false),
      ('invite Friend 0/1','invite friend when they join app\n & top-up 15k with your\n reference you get extra','x1000', false),
    ];

    return MediaQuery(
      data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          r.hGap(30),

          /// Timer pill
          Align(
            alignment: Alignment.centerLeft,
            child: CustomContainer(
              conColor: Colors.transparent,
              child: Container(
                height: r.h(44), width: r.w(180), alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(0), bottomLeft: const Radius.circular(0),
                    topRight: Radius.circular(r.px(28)), bottomRight: Radius.circular(r.px(28)),
                  ),
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [Color(0xFFAFA3F0), Color(0xFF9F92EE)]),
                ),
                child: CustomText('23:59:50', fontSize: r.sp(18), fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),

          /// Header card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.w(13)),
            child: CustomContainer(
              width: double.infinity,
              image: const DecorationImage(image: AssetImage('assets/images/rewardsceondbg.png'), fit: BoxFit.fill),
              child: SizedBox(
                height: r.h(300),
                child: Stack(clipBehavior: Clip.none, children: [
                  // left text
                  Positioned(
                    top: r.h(40), left: r.w(15), right: r.w(120),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        CustomText('Require', color: Colors.black, fontSize: r.sp(20), fontWeight: FontWeight.w700),
                        r.wGap(6),
                        Image.asset('assets/icons/diamond_icon 2 1.png', height: r.h(18), width: r.h(18)),
                        r.wGap(4),
                        CustomText('x50', color: Colors.black, fontSize: r.sp(12), fontWeight: FontWeight.w700),
                      ]),
                      r.hGap(4),
                      CustomText('Need to be completed in 3 days', color: Colors.black, fontSize: r.sp(10), fontWeight: FontWeight.w500),
                    ]),
                  ),

                  // days + ruler
                  Positioned(
                    top: r.h(110), left: r.w(15), right: r.w(15),
                    child: LayoutBuilder(builder: (_, c) {
                      final barH = r.h(7), borderW = r.w(.5), barW = c.maxWidth;
                      return Column(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: r.w(12)),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                            DayTile(label: 'Day 1', w: 71, h: 61, imgH: 35),
                            DayTile(label: 'Day 2', w: 82, h: 69, imgH: 42),
                            DayTile(label: 'Day 3', w: 91, h: 67, imgH: 46),
                          ]),
                        ),
                        SizedBox(height: r.h(12)),
                        SizedBox(
                          width: barW, height: barH,
                          child: Stack(clipBehavior: Clip.none, children: [
                            CustomContainer(
                              borderRadius: BorderRadius.circular(barH/2),
                              border: Border.all(color: Colors.black, width: borderW),
                            ),
                            Positioned.fill(
                              child: Padding(
                                padding: EdgeInsets.all(borderW*1.5),
                                child: CustomContainer(
                                  borderRadius: BorderRadius.circular((barH-borderW*3)/2),
                                  conColor: const Color(0xFF2D2D35),
                                ),
                              ),
                            ),
                            Positioned(
                              left: borderW*1.5, top: borderW*1.5, bottom: borderW*1.5,
                              child: CustomContainer(
                                width: (barW-borderW*3)*0.88,
                                borderRadius: BorderRadius.circular((barH-borderW*3)/2),
                                conColor: const Color(0xFFB8BEE6),
                              ),
                            ),
                            ...[0.18, 0.50, 0.92].map((f) {
                              final innerW = barW - borderW*3, left = borderW*1.5 + innerW*f;
                              return Positioned(
                                left: left, top: borderW*2.8,
                                child: CustomContainer(
                                  width: r.w(1.6), height: barH - borderW*5.6,
                                  borderRadius: BorderRadius.circular(r.w(1)),
                                  conColor: const Color(0xFF2D2D35),
                                ),
                              );
                            }),
                          ]),
                        ),
                        SizedBox(height: r.h(6)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          CustomText('10', fontSize: r.sp(10), color: Colors.black),
                          CustomText('20', fontSize: r.sp(10), color: Colors.black),
                          CustomText('30', fontSize: r.sp(10), color: Colors.black),
                        ]),
                      ]);
                    }),
                  ),

                  // rewards belt
                  Positioned(
                    top: r.h(235), left: r.w(8), right: 0,
                    child: CustomContainer(
                      height: r.h(86),
                      borderRadius: BorderRadius.circular(r.px(20)),
                      image: const DecorationImage(image: AssetImage('assets/images/Union.png'), fit: BoxFit.cover),
                      padding: EdgeInsets.only(left: r.w(10), top: r.h(12)),
                      child: Row(children: [
                        for (final (img, title, wLab) in rewards) ...[
                          RewardItem(img: img, title: title, labelW: wLab),
                          r.wGap(10),
                        ],
                      ]),
                    ),
                  ),
                ]),
              ),
            ),
          ),

          r.hGap(50),

          /// Header row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.w(30)),
            child: Row(children: [
              CustomText('Day  Task', fontSize: r.sp(12), fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A)),
              const Spacer(),
              CustomText('Obtained today:', fontSize: r.sp(8), color: const Color(0xFF8A8A8F), fontWeight: FontWeight.w500),
              r.wGap(2),
              Image.asset('assets/icons/diamond_icon 2 1.png', width: r.h(13), height: r.h(13)),
              r.wGap(2),
              CustomText('x0', fontSize: r.sp(10), color: const Color(0xFF8A8A8F), fontWeight: FontWeight.w600),
            ]),
          ),

          r.hGap(15),

          /// Task list
          Padding(
            padding: EdgeInsets.symmetric(horizontal: r.w(25)),
            child: Column(children: [
              for (final (t, s, rw, c) in tasks) ...[
                TaskCard(title: t, subtitle: s, reward: rw, claimed: c),
                r.hGap(8),
              ],
              r.hGap(8),
            ]),
          ),
        ]),
      ),
    );
  }
}
