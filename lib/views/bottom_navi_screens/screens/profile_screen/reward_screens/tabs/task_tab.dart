import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class TaskTab extends StatelessWidget {
  const TaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // ⏱️ timer pill (left edge sharp)
          Align(
            alignment: Alignment.centerLeft,
            child: CustomContainer(
              conColor: Colors.transparent,
              child: Container(
                height: 44,
                width: 180,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                    topRight: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFAFA3F0), Color(0xFF9F92EE)],
                  ),
                ),
                child: const CustomText(
                  '23:59:50',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // 🌈 HEADER CARD (BG image + positioned blocks)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: CustomContainer(
              width: double.infinity,
              image: const DecorationImage(
                image: AssetImage('assets/images/rewardsceondbg.png'),
                fit: BoxFit.fill,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // base height to fit everything (tiles + bar + belt)
                  const SizedBox(height: 300),

                  // 1) "Require x50" + subtitle
                  const Positioned(
                    top: 40,
                    left: 15,
                    right: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              'Require',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              shadows: [],
                            ),
                            SizedBox(width: 6),
                            Image(
                              image:
                              AssetImage('assets/icons/diamond_icon 2 1.png'),
                              height: 18,
                              width: 18,
                            ),
                            SizedBox(width: 4),
                            CustomText(
                              'x50',
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              shadows: [],
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        CustomText(
                          'Need to be completed in 3 days',
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          shadows: [],
                        ),
                      ],
                    ),
                  ),

                  // 2) Day tiles + capsule ruler + 10/20/30 (positions tuned to screenshot)
                  Positioned(
                    top: 110,
                    left: 15,
                    right: 15,
                    child: LayoutBuilder(
                      builder: (context, c) {
                        const double barH = 7.0;
                        const double borderW = 0.5;
                        final double barW = c.maxWidth;

                        return Column(
                          children: [
                            // Day 1 / Day 2 / Day 3 tiles (above the bar)
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  // Day 1
                                  CustomContainer(
                                    width: 71,
                                    height: 61,
                                    borderRadius: BorderRadius.circular(18),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(.45),
                                        Colors.white.withOpacity(.30)
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: const [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/Layer 4.png'),
                                          height: 35,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(height: 6),
                                        CustomText(
                                          'Day 1',
                                          fontSize: 12,
                                          color: Color(0xFF6A6A6A),
                                          fontWeight: FontWeight.w600,
                                          shadows: [],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Day 2
                                  CustomContainer(
                                    width: 82,
                                    height: 69,
                                    borderRadius: BorderRadius.circular(18),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(.45),
                                        Colors.white.withOpacity(.30)
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: const [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/Layer 4.png'),
                                          height: 42,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(height: 6),
                                        CustomText(
                                          'Day 2',
                                          fontSize: 12,
                                          color: Color(0xFF6A6A6A),
                                          fontWeight: FontWeight.w600,
                                          shadows: [],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Day 3
                                  CustomContainer(
                                    width: 91,
                                    height: 67,
                                    borderRadius: BorderRadius.circular(18),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(.45),
                                        Colors.white.withOpacity(.30)
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: const [
                                        Image(
                                          image: AssetImage(
                                              'assets/images/Layer 4.png'),
                                          height: 46,
                                          fit: BoxFit.contain,
                                        ),
                                        SizedBox(height: 6),
                                        CustomText(
                                          'Day 3',
                                          fontSize: 12,
                                          color: Color(0xFF6A6A6A),
                                          fontWeight: FontWeight.w600,
                                          shadows: [],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Capsule ruler (0.5 border, height 7) + notches
                            SizedBox(
                              width: barW,
                              height: barH,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // outer border
                                  CustomContainer(
                                    borderRadius:
                                    BorderRadius.circular(barH / 2),
                                    border: Border.all(
                                        color: Colors.black, width: borderW),
                                  ),
                                  // dark track
                                  Positioned.fill(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.75),
                                      child: CustomContainer(
                                        borderRadius: BorderRadius.circular(
                                            barH / 2 - 0.75),
                                        conColor: const Color(0xFF2D2D35),
                                      ),
                                    ),
                                  ),
                                  // light fill (progress)
                                  Positioned(
                                    left: 0.75,
                                    top: 0.75,
                                    bottom: 0.75,
                                    child: CustomContainer(
                                      width: (barW - 1.5) * 0.88, // 0..1
                                      borderRadius: BorderRadius.circular(
                                          (barH - 1.5) / 2),
                                      conColor: const Color(0xFFB8BEE6),
                                    ),
                                  ),
                                  // notches under Day1/2/3 (fractions tuned)
                                  ...[0.18, 0.50, 0.92].map((f) {
                                    final double innerW = barW - 1.5;
                                    final double left = 0.75 + innerW * f;
                                    return Positioned(
                                      left: left,
                                      top: 1.2,
                                      child: CustomContainer(
                                        width: 1.6,
                                        height: barH - 2.4,
                                        borderRadius: BorderRadius.circular(1),
                                        conColor: const Color(0xFF2D2D35),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),

                            const SizedBox(height: 6),

                            // 10 / 20 / 30 labels
                            SizedBox(
                              width: barW,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: const [
                                  CustomText('10',
                                      fontSize: 10,
                                      color: Colors.black,
                                      shadows: []),
                                  CustomText('20',
                                      fontSize: 10,
                                      color: Colors.black,
                                      shadows: []),
                                  CustomText('30',
                                      fontSize: 10,
                                      color: Colors.black,
                                      shadows: []),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // 3) Items belt (rounded glass slab) — under the bar
                  Positioned(
                    top: 235,
                    left: 8,
                    right: 0,
                    child: CustomContainer(
                      height: 86,
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Union.png'),
                        fit: BoxFit.cover,
                      ),
                      padding: const EdgeInsets.only(left: 10, top: 12),
                      child: Row(
                        children: [
                          _rewardItem(
                              'assets/images/1.png', 'Decor - Star Trek', 74),
                          const SizedBox(width: 10),
                          _rewardItem('assets/images/2.png', 'Bike Fire', 72),
                          const SizedBox(width: 10),
                          _rewardItem(
                              'assets/images/car.png', 'Ferrari car', 72),
                          const SizedBox(width: 13),
                          _rewardItem('assets/images/last.png',
                              'Goddess Crown', 72),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: const [
                CustomText(
                  'Day  Task',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                  shadows: [],
                ),
                Spacer(),
                CustomText(
                  'Obtained today:',
                  fontSize: 8,
                  color: Color(0xFF8A8A8F),
                  fontWeight: FontWeight.w500,
                  shadows: [],
                ),
                SizedBox(width: 2),
                Image(
                  image: AssetImage('assets/icons/diamond_icon 2 1.png'),
                  width: 13,
                  height: 13,
                ),
                SizedBox(width: 2),
                CustomText(
                  'x0',
                  fontSize: 10,
                  color: Color(0xFF8A8A8F),
                  fontWeight: FontWeight.w600,
                  shadows: [],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 📜 Task list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: const [
                _TaskCard(
                  title: 'call match 0/1',
                  subtitle:
                  'Complete 1 random call matches for\n more than 1 minutes',
                  reward: 'x100',
                  claimed: true,
                ),
                SizedBox(height: 8),
                _TaskCard(
                  title: 'Friend interaction 0/1',
                  subtitle: 'Send 5 messages to each other\n with friends',
                  reward: 'x50',
                ),
                SizedBox(height: 8),
                _TaskCard(
                  title: 'To attend a party 0/1',
                  subtitle:
                  'Speak for more than 1 minutes in\n the party room',
                  reward: 'x100',
                ),
                SizedBox(height: 8),
                _TaskCard(
                  title: 'invite Friend 0/1',
                  subtitle:
                  'invite friend when they join app\n & top-up 15k with your reference you get extra',
                  reward: 'x200',
                ),
                SizedBox(height: 8),
                _TaskCard(
                  title: 'invite Friend 0/1',
                  subtitle:
                  'invite friend when they join app\n & top-up 15k with your\n reference you get extra',
                  reward: 'x1000',
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------- Small UI parts -------

Widget _rewardItem(String img, String title, double labelWidth) {
  return Column(
    children: [
      CustomContainer(
        height: 48,
        width: 50,
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x1AD9D9D9), Color(0x80FFFFFF)],
        ),
        child: Image.asset(img, fit: BoxFit.contain),
      ),
      const SizedBox(height: 6),
      SizedBox(
        width: labelWidth,
        child: CustomText(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          color: Colors.black,
          fontSize: 8,
          fontWeight: FontWeight.w600,
          lineHeight: 1.2,
          shadows: const [],
        ),
      ),
    ],
  );
}

class _TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String reward;
  final bool claimed;
  const _TaskCard({
    required this.title,
    required this.subtitle,
    required this.reward,
    this.claimed = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 82,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      conColor: const Color(0xFFF2F1FF),
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.08),
          blurRadius: 14,
          offset: const Offset(0, 8),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // left text block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                  shadows: const [],
                ),
                const SizedBox(height: 6),
                CustomText(
                  subtitle,
                  fontSize: 12,
                  lineHeight: 1.25,
                  color: const Color(0xFF8A8A8F),
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                  shadows: const [],
                ),
              ],
            ),
          ),
          const SizedBox(width: 1),

          // reward + button
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('assets/icons/diamond_icon 2 1.png',
                      width: 18, height: 18),
                  const SizedBox(width: 6),
                  CustomText(
                    reward,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    shadows: const [],
                  ),
                ],
              ),
              CustomContainer(
                width: 62,
                height: 28,
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(24),
                gradient: claimed
                    ?  LinearGradient(
                  colors: [Color(0xFF7EFF96), Color(0xFF7DD0B7),Color(
                      0xFF7B6AFF)],
                )
                    :  LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE87EFF), Color(0xFFA96AFF)],
                ),
                child: CustomText(
                  claimed ? 'Claimed' : 'Go',
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  shadows: const [],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
