import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/wallet_sceens/my_order_screen.dart';

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

class GrabOrders1Screen extends StatelessWidget {
  const GrabOrders1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final r  = context.rs;

    return SafeArea(
      child: Scaffold(
        body: MediaQuery(
          data: mq.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: CustomContainer(
            width: double.infinity,
            height: double.infinity,
            image: const DecorationImage(
              image: AssetImage("assets/images/Livebroadcastdatabg.jpg"),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: r.h(24)),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const RioliveAppBar(title: 'Grab Orders'),
                  r.hGap(20),

                  // Main card
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.w(20), vertical: r.h(12)),
                    child: CustomContainer(
                      width: double.infinity,
                      // height removed -> lets content size naturally (prevents overflow)
                      padding: EdgeInsets.all(r.w(16)),
                      borderRadius: BorderRadius.circular(r.px(12)),
                      conColor: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Total Income Row
                          Row(
                            children: [
                              CustomText('Total income',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: r.sp(20)),
                              const Spacer(),
                              CustomText('100,000',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38,
                                  fontSize: r.sp(20)),
                            ],
                          ),
                          r.hGap(25),

                          // Order Income Row
                          Row(
                            children: [
                              CustomText('Order income',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: r.sp(18)),
                              const Spacer(),
                              CustomText('97,000',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black38,
                                  fontSize: r.sp(20)),
                            ],
                          ),
                          r.hGap(25),

                          // Reward Row
                          Row(
                            children: [
                              CustomText('Reward',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: r.sp(18)),
                              const Spacer(),
                              CustomText('3,000',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black38,
                                  fontSize: r.sp(20)),
                            ],
                          ),
                          r.hGap(20),

                          Divider(color: Colors.black.withOpacity(0.4), thickness: r.px(1)),
                          r.hGap(20),

                          // Order header
                          Row(
                            children: [
                              CustomText('Order:',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: r.sp(20)),
                              const Spacer(),
                              CustomText('100,000',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black38,
                                  fontSize: r.sp(20)),
                            ],
                          ),
                          r.hGap(25),

                          // Amount of Payment Row (use Spacer instead of fixed 70px)
                          Row(
                            children: [
                              CustomText('Amount of payment:',
                                  color: Colors.black,
                                  fontSize: r.sp(18),
                                  fontWeight: FontWeight.w400),
                              const Spacer(),
                              CustomText('\$10',
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w400,
                                  fontSize: r.sp(20)),
                            ],
                          ),
                          r.hGap(25),

                          // Payment Channels Row
                          Row(
                            children: [
                              CustomText('Payment channels:',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: r.sp(18)),
                              const Spacer(),
                              CustomText('Localpayment',
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w400,
                                  fontSize: r.sp(20)),
                            ],
                          ),

                          r.hGap(40),

                          // Grab Button
                          Center(
                            child: CustomGradientButton(
                              onPressed: () {
                                Get.to(()=>MyOrderScreen());
                              },
                              text: 'Grab',
                              textColor: const Color(0xffA62B2B),
                              height: r.h(52),
                              width:  r.w(180),
                              fontWeight: FontWeight.w500,
                              fontSize: r.sp(16),
                              borderRadius: r.px(30),
                              gradientColors: const [Color(0xffe496ff), Color(0xff8ec2fb)],
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
}
