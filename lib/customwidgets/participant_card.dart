import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class ParticipantCard extends StatelessWidget {
  final int index;
  final String name;
  final String image;
  final String coins;

  const ParticipantCard({
    Key? key,
    required this.index,
    required this.name,
    required this.image,
    required this.coins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.zero, // 👈 no external space
      padding: EdgeInsets.zero,
      conColor: Colors.white.withOpacity(0.25),
      border: Border.all(color: Colors.white.withOpacity(0.5)),

      child: Stack(
        children: [
          // Coins top-right
          Positioned(
            right: 6,
            top: 6,
            child: CustomContainer(
              borderRadius: BorderRadius.circular(25),
              conColor: Colors.black.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Image.asset("assets/icons/coin.png", height: 14),
                    const SizedBox(width: 2),
                    CustomText(
                      coins,
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 👇 Centered Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 32, backgroundImage: AssetImage(image)),
                const SizedBox(height: 5),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Icon(
                        Icons.mic_off,
                        color: Colors.white70,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
