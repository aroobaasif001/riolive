import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

import '../../../../../../customwidgets/customcirclebutton.dart';
import '../../../../../../customwidgets/customtext.dart';
import '../../../../../../utile/dialog_helper.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  int _bannerIndex = 0;
  final List<String> banners = const [
    'assets/images/slide_image.png',
    'assets/images/slide_image.png',
    'assets/images/slide_image.png',
  ];
  final images = [
    'assets/images/girl_img1.png',
    'assets/images/girl_img2.png',
    'assets/images/hbg3.jpg',
    'assets/images/hbg4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ define scale (and make it double)
    final size = MediaQuery.of(context).size;
    final double scale = (size.width / 375).clamp(0.85, 1.25).toDouble();

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: CarouselSlider(
            items: banners
                .map(
                  (b) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(b, fit: BoxFit.cover, width: double.infinity),
                ),
              ),
            )
                .toList(),
            options: CarouselOptions(
              height: 110,
              viewportFraction: 0.93,
              autoPlay: true,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() => _bannerIndex = index);
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
                  (i) => Container(
                width: _bannerIndex == i ? 18 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                decoration: BoxDecoration(
                  color: _bannerIndex == i ? Colors.green : Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 14)),
        SliverToBoxAdapter(
          child: Row(
            children: [
              const SizedBox(width: 15),
              const Image(image: AssetImage('assets/icons/globleicon.png'), height: 25, width: 25),
              const SizedBox(width: 6),
              const Text('Global', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(width: 10),
              _CountryChip(
                label: 'Philippines',
                emoji: '🇵🇭',
                scale: scale, // ✅ now defined
                flagAsset: 'assets/icons/flagicon.png',
              ),
              // === Mint pill with 3 glossy, overlapped flag circles ===
              // Mini pill with 3 overlapped glossy flags (each 18x26)
              SizedBox(width: 20,),
              CustomContainer(
                height: 27,
                width: 63,
                borderRadius: BorderRadius.circular(90),
                conColor: Colors.white54,

                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // left flag (France)
                    Positioned(
                      left: 3,
                      top: 4.5, // vertically center 18px inside 27px
                      child: SizedBox(
                        width: 26,
                        height: 18,
                        child: Stack(
                          children: [
                            CustomContainer(
                              width: 26,
                              height: 18,
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('assets/icons/flagicon.png'),
                                fit: BoxFit.cover,
                              ),

                            ),
                            // glossy sheen
                            CustomContainer(
                              width: 26,
                              height: 18,
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                colors: [Colors.white.withOpacity(.80), Colors.white.withOpacity(0)],
                                stops: const [0.0, 0.55],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // center flag (Turkey) – sits above others
                    Positioned(
                      left: 18, // overlap a bit
                      top: 4.5,
                      child: SizedBox(
                        width: 26,
                        height: 18,
                        child: Stack(
                          children: [
                            CustomContainer(
                              width: 26,
                              height: 18,
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('assets/icons/flagicon.png'),
                                fit: BoxFit.cover,
                              ),


                            ),
                            CustomContainer(
                              width: 26,
                              height: 18,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // right flag (Palestine)
                    Positioned(
                      left: 35, // overlap on the right
                      top: 4.5,
                      child: SizedBox(
                        width: 26,
                        height: 18,
                        child: Stack(
                          children: [
                            CustomContainer(
                              width: 26,
                              height: 18,
                              borderRadius: BorderRadius.circular(12),
                              image: const DecorationImage(
                                image: AssetImage('assets/icons/flagicon.png'),
                                fit: BoxFit.cover,
                              ),

                            ),
                            CustomContainer(
                              width: 26,
                              height: 18,
                              borderRadius: BorderRadius.circular(12),

                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),



              const SizedBox(width: 20),

              CustomCircleButton(
                child: const Image(
                  image: AssetImage('assets/icons/multiicon.png'),
                  height: 10,
                  width: 12,
                ),
                onPressed: () {
                  showCountryDialogTop(context);
                },
                size: 25,
              )
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 230,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final img = images[index % images.length];
              final name = index % 2 == 0 ? 'Himanshi Khurana' : 'Kaanch';
              final viewers = index.isEven ? '56' : '91';
              return Column(
                children: [
                  CustomContainer(
                    height: 159,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    image: DecorationImage(image: AssetImage(img), fit: BoxFit.fill),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          conColor: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                          child: const Text(
                            'Live',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                        ),
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          conColor: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.favorite, color: Colors.pinkAccent, size: 14),
                              const SizedBox(width: 4),
                              const SizedBox.shrink(),
                              Text(
                                viewers,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomContainer(
                    height: 35,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    conColor: const Color(0x306517DA),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$name 🥰',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }, childCount: 8),
          ),
        ),
      ],
    );
  }
}

class _CountryChip extends StatelessWidget {
  final String label;
  final String? emoji;
  final String? flagAsset;
  final double scale;

  const _CountryChip({
    required this.label,
    required this.scale,
    this.emoji,
    this.flagAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomContainer(
        height: 27,
        width: 105,
        padding: EdgeInsets.symmetric(horizontal: 5 * scale, vertical: 2 * scale),
        conColor: Colors.white38,
        borderRadius: BorderRadius.circular(28 * scale),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _FlagBadge(diameter: 20 * scale, emoji: emoji, flagAsset: flagAsset),
          SizedBox(width: 10 * scale),
          CustomText(
            label,
            color: const Color(0xFF1D1D1F),
            fontWeight: FontWeight.w600,
            fontSize: 11 * scale,
            letterSpacing: 0.1,
          ),
        ]),
      ),
    );
  }
}

class _FlagBadge extends StatelessWidget {
  final double diameter;
  final String? emoji;
  final String? flagAsset;
  const _FlagBadge({required this.diameter, this.emoji, this.flagAsset});

  @override
  Widget build(BuildContext context) {
    if (flagAsset != null && flagAsset!.isNotEmpty) {
      return SizedBox(
        width: diameter, height: diameter,
        child: ClipOval(
          child: Image.asset(flagAsset!, width: diameter, height: diameter, fit: BoxFit.cover),
        ),
      );
    }
    // fallback to emoji or blank
    return SizedBox(
      width: diameter, height: diameter,
      child: Center(child: CustomText(emoji ?? '', fontSize: diameter * 0.72)),
    );
  }
}

