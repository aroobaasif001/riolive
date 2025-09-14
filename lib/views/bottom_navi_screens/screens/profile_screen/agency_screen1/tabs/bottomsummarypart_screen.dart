import 'package:flutter/material.dart';
import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/customtext.dart';

/// 🔥 Gradient Text Widget
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(
      this.text, {
        super.key,
        required this.style,
        required this.gradient,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

class BottomSummaryScreen extends StatelessWidget {
  const BottomSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          children: [
            CustomContainer(
              height: 500,
              conColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==== Top Row (Total Bonus) ====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CustomText(
                            "Total Bonus:",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(width: 6),
                          Image.asset("assets/icons/dolloricon.png",
                              height: 18, width: 18),
                          const SizedBox(width: 2),
                          GradientText(
                            "0",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF512F), Color(0xFFF09819)],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.help_outline,
                            size: 16,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          CustomText(
                            "Details",
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ==== Reward 1 ====
                  CustomContainer(
                    conColor: const Color(0xFFFFF3DB),
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GradientText(
                              "Reward 1",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFC4A1A), Color(0xFFF98427),Color(
                                    0xFFF7B733)],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CustomText(
                              "HostCommission",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff491E19),
                            ),
                            SizedBox(width: 20,),
                            CustomContainer(
                              height: 11,
                              width: 12,
                              child: Image(image: AssetImage('assets/images/circulerfarwodicon.png'))
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                             CustomText(
                              "Commission",
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const CustomText(
                                  "6%",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/dolloricon.png",
                                      height: 18,
                                      width: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    const CustomText(
                                      "0",
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==== Reward 2 ====
                  CustomContainer(
                    conColor: const Color(0xFFE8F3FF),
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GradientText(
                              "Reward 2",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                              gradient: const LinearGradient(
                                colors: [Color(0xff3779d8), Color(0xff8baccd)],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CustomText(
                              "Agent Commission",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            SizedBox(width: 15,),
                            CustomContainer(
                                height: 11,
                                width: 12,
                                child: Image(image: AssetImage('assets/images/circulerfarwodicon.png'))
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const CustomText(
                              "Commission",
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const CustomText(
                                  "6%",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/dolloricon.png",
                                      height: 18,
                                      width: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    const CustomText(
                                      "0",
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==== Total Commission ====
                  CustomContainer(
                    height: 87,
                    conColor: const Color(0xFFFFE2E6),
                    borderRadius: BorderRadius.circular(12),
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GradientText(
                              "Reward",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                              ),
                              gradient: const LinearGradient(
                                colors: [Color(0xffd85152), Color(0xff914f44)],
                              ),
                            ),
                            SizedBox(width: 50,),
                            const CustomText(
                              "Total Commission",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A6281),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomContainer(
                          height: 40,
                          width: double.infinity, // full width like screenshot
                          conColor: const Color(0xFFFFCDD4), // light pink strip
                          borderRadius: BorderRadius.circular(12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // center the whole row
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/dolloricon.png",
                                  height: 21,  // bigger coin like the shot
                                  width: 21,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    CustomText(
                                      "Earned",
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    CustomText(
                                      "1,917,32",
                                      fontSize: 14,                // bold & larger
                                      fontWeight: FontWeight.w700, // same emphasis
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
