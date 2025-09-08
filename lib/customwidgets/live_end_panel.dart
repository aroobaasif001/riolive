import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/share_circle.dart';
import 'package:riolive/customwidgets/user_chip.dart';

import '../models/live_card_data.dart';
import 'custom_container.dart';
import 'customtext.dart';
import 'gradient_headline.dart';
import 'live_card.dart';

class LiveEndPanel extends StatelessWidget {
  const LiveEndPanel({
    required this.height,
    required this.userName,
    required this.avatar,
    required this.cards,
  });

  final double height;
  final String userName;
  final String avatar;
  final List<LiveCardData> cards;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      borderRadius: BorderRadius.circular(28),
      padding: const EdgeInsets.fromLTRB(16, 74, 16, 88),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: UserChip(
              avatar: avatar,
              name: userName,
              trailingGradient: const [Color(0xFFF700FF), Color(0xFFFF9A4D)],
            ),
          ),
          const SizedBox(height: 18),
          const GradientHeadline('Live End'),
          const SizedBox(height: 14),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(top: 6),
              itemCount: cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
                childAspectRatio: .92,
              ),
              itemBuilder: (_, i) => LiveCard(
                image: cards[i].image,
                name: cards[i].name,
                isGray: cards[i].isGray,
              ),
            ),
          ),

          CustomText(
            'Share With Friends',
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShareCircle(icon: Icons.link, onTap: () {}),
              const SizedBox(width: 16),
              ShareCircle(
                asset: 'assets/icons/facebook.png',
                onTap: () {},
              ), // <-- replace if needed
              const SizedBox(width: 16),
              ShareCircle(
                asset: 'assets/icons/instagram.png',
                onTap: () {},
              ), // <-- replace if needed
            ],
          ),
        ],
      ),
    );
  }
}
