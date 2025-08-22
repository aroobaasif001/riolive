import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customnavbar.dart';
import 'package:riolive/customwidgets/customtext.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ---- Responsive sizes via MediaQuery ----
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double spaceXS = (h * 0.012).clamp(6.0, 14.0);      // ~10
    final double spaceMD = (h * 0.06).clamp(32.0, 56.0);       // ~50
    final double spaceLG = (h * 0.08).clamp(44.0, 72.0);       // ~65
    final double gap = (w * 0.012).clamp(4.0, 10.0);           // ~5 between diamond & text

    final double logoSize = (w * 0.7).clamp(180.0, 340.0).toDouble(); // ~310
    final double titleSize = (w * 0.06).clamp(18.0, 28.0).toDouble(); // ~24
    final double priceSize = (w * 0.055).clamp(16.0, 26.0).toDouble(); // ~24

    final double diamondH = (h * 0.025).clamp(16.0, 24.0).toDouble();  // ~20
    final double diamondW = (diamondH * 1.35).toDouble();              // ~27

    final double phoneSize = (w * 0.2).clamp(60.0, 100.0).toDouble();  // ~80

    return Scaffold(
      extendBodyBehindAppBar: true, // Makes the body extend behind the AppBar
      backgroundColor: Colors.transparent,
      // AppBar has been removed from here
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 50,),
          Image(
            image: const AssetImage('assets/images/CIRCLE LOGO.png'),
            height: logoSize,
            width: logoSize,
          ),
          SizedBox(height: spaceXS),
          CustomText(
            text: 'Match Random Video Call',
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xff5EBFEF),
          ),
          SizedBox(height: spaceLG),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('assets/icons/diamondicon.png'),
                height: diamondH,
                width: diamondW,
              ),
              SizedBox(width: gap),
              CustomText(
                text: '800/min',
                fontWeight: FontWeight.w600,
                fontSize: priceSize,
                color: const Color(0xff60ED59),
              )
            ],
          ),
          SizedBox(height: spaceMD),
          Image(
            image: const AssetImage('assets/icons/phoneicon.png'),
            height: phoneSize,
            width: phoneSize,
          ),
        ],
      ),
    );
  }
}
