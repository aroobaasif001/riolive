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

  final images = const [
    'assets/images/girl_img1.png',
    'assets/images/girl_img2.png',
    'assets/images/hbg3.jpg',
    'assets/images/hbg4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Base your UI on iPhone 11-ish width (375). We cap to keep "same UI" feel.
    final double s = (size.width / 375.0).clamp(0.90, 1.15);

    // keep textScaleFactor under control to avoid overflow
    final media = MediaQuery.of(context);
    final safeTextScale = media.textScaleFactor.clamp(0.85, 1.10);

    // Heights derived from width so tall/short phones still look right
    final double bannerHeight = (110.0 * s).clamp(90.0, 130.0);
    final double bannerStackHeight = bannerHeight + (10.0 * s); // room for dots
    final double dotSize = (10.0 * s).clamp(6.0, 12.0);

    // Grid card heights (image + footer)
    final double gridImageH = (159.0 * s).clamp(130.0, 190.0);
    final double gridFooterH = (35.0 * s).clamp(28.0, 44.0);
    final double gridItemMainExtent = gridImageH + gridFooterH + (6.0 * s);

    return MediaQuery(
      data: media.copyWith(textScaleFactor: safeTextScale),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 12 * s)),

          // ====== Banner with inside dots (responsive) ======
          SliverToBoxAdapter(
            child: SizedBox(
              height: bannerStackHeight,
              child: Stack(
                children: [
                  CarouselSlider(
                    items: banners.map((b) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4 * s),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14 * s),
                          child: Image.asset(
                            b,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: bannerHeight,
                      viewportFraction: 0.93,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        setState(() => _bannerIndex = index);
                      },
                    ),
                  ),

                  // dots inside
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: (20 * s).clamp(12, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        banners.length,
                            (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: EdgeInsets.symmetric(horizontal: 4 * s),
                          width: dotSize,
                          height: dotSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(_bannerIndex == i ? 1 : 0.35),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 14 * s)),

          // ====== Global row + chips (responsive paddings/sizes) ======
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12 * s),
              child: Row(
                children: [
                  SizedBox(width: 3 * s),
                  const Image(
                    image: AssetImage('assets/icons/globleicon.png'),
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(width: 6 * s),
                  Flexible(
                    child: Text(
                      'Global',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: (24 * s).clamp(18, 26),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10 * s),
                  _CountryChip(
                    label: 'Philippines',
                    emoji: '🇵🇭',
                    scale: s,
                    flagAsset: 'assets/icons/flagicon.png',
                  ),
                  SizedBox(width: 5 * s),

                  // Overlapped mini flags pill
                  CustomContainer(
                    height: (27 * s).clamp(22, 32),
                    width: (63 * s).clamp(54, 76),
                    borderRadius: BorderRadius.circular(90 * s),
                    conColor: Colors.white54,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _miniFlag(left: 3 * s),
                        _miniFlag(left: 18 * s),
                        _miniFlag(left: 35 * s),
                      ],
                    ),
                  ),

                  SizedBox(width: 20 * s),

                  InkWell(
                    onTap: () => showCountryDialogTop(context),
                    child: CustomContainer(
                      shape: BoxShape.circle,
                      conColor: Colors.white.withOpacity(0.4),
                      height: (27 * s).clamp(22, 32),
                      width: (27 * s).clamp(22, 32),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/multiicon.png',
                          height: (16 * s).clamp(12, 18),
                          width: (16 * s).clamp(12, 18),
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 10 * s)),

          // ====== Grid (always 2 columns, responsive height) ======
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 12 * s),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // keep same UI
                mainAxisExtent: gridItemMainExtent,
                mainAxisSpacing: 12 * s,
                crossAxisSpacing: 12 * s,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final img = images[index % images.length];
                  final name = index.isEven ? 'Himanshi Khurana' : 'Kaanch';

                  return Column(
                    children: [
                      // image panel
                      CustomContainer(
                        height: gridImageH,
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10 * s,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25 * s),
                          topRight: Radius.circular(25 * s),
                        ),
                        image: DecorationImage(
                          image: AssetImage(img),
                          fit: BoxFit.cover,
                        ),
                      ),

                      // footer panel
                      CustomContainer(
                        height: gridFooterH,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 11 * s),
                        conColor: const Color(0x306517DA),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25 * s),
                          bottomRight: Radius.circular(25 * s),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$name 🥰',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: (13.5 * s).clamp(12, 15),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                childCount: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // tiny overlapped flag helper
  Widget _miniFlag({required double left}) {
    return Positioned(
      left: left,
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
            // optional glossy overlay
            CustomContainer(
              width: 26,
              height: 18,
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withOpacity(.80), Colors.white.withOpacity(0)],
                stops: const [0.0, 0.55],
              ),
            ),
          ],
        ),
      ),
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
    final s = scale;
    return Padding(
      padding: EdgeInsets.all(8.0 * s),
      child: CustomContainer(
        height: (27 * s).clamp(22, 32),
        width: (105 * s).clamp(92, 126),
        padding: EdgeInsets.symmetric(horizontal: 5 * s, vertical: 2 * s),
        conColor: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(28 * s),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FlagBadge(diameter: (20 * s).clamp(16, 24), emoji: emoji, flagAsset: flagAsset),
            SizedBox(width: 8 * s),
            Expanded(
              child: CustomText(
                label,
                color: const Color(0xFF1D1D1F),
                fontWeight: FontWeight.w600,
                fontSize: (11 * s).clamp(9.5, 13),
                letterSpacing: 0.1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
        width: diameter,
        height: diameter,
        child: ClipOval(
          child: Image.asset(
            flagAsset!,
            width: diameter,
            height: diameter,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Center(
        child: CustomText(
          emoji ?? '',
          fontSize: diameter * 0.72,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
