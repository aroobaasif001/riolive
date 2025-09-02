import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/tiny_round.dart';

import 'customtext.dart';
import 'frosted_pill.dart';
import 'gradient_pill.dart';

class GiftStrip extends StatelessWidget {
  GiftStrip();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // 👈 allow overlap outside container
      children: [
        GradientPill(
          width: 250,
          height: 58,
          gradient: const LinearGradient(
            colors: [Color(0xffD74FFF), Color(0xff6CD6FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          child: Row(
            children: [
              const TinyRound(
                size: 36,
                image: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'David Son',
                      fontType: AppFont.poppins,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    FrostedPill(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.ac_unit_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Flexible(
                            child: CustomText(
                              'Crystal Diamond',
                              fontSize: 12,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // 👇 yeh row hata di kyunki ab pearl top-right pe jayegi
            ],
          ),
        ),

        // 👇 Pearl image aur x1 ko border ke upar top-right pe rakhne ke liye
        Positioned(
          top: -12, // thoda bahar float karwane ke liye
          right: -12,
          child: Row(
            children: [
              Image.asset("assets/icons/pearl.png", height: 40, width: 40),
              const SizedBox(width: 4),
              const CustomText(
                'x1',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
