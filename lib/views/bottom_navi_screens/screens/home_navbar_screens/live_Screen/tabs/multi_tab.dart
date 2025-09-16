import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customcirclebutton.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/live_Screen/tabs/multi_room_screen/multi_room_screen.dart';

import '../../../../../../utile/dialog_helper.dart';

class MultiTab extends StatelessWidget {
  const MultiTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final padH = isTablet ? 20.0 : 14.0;
    final scale = (size.width / 375).clamp(0.85, 1.25);

    // 2 columns on phones, 3 on tablets
    final columns = isTablet ? 3 : 2;

    return CustomContainer(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(padH, 12, padH, 12),
            sliver: SliverToBoxAdapter(child: _HeaderBar(scale: scale)),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: padH),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, i) {
                final isRightCard = (i % columns) == (columns - 1);

                // LEFT (and middle on tablet) => Himanshi; RIGHT => HAPPY NEW YEAR
                final forcedTitle = isRightCard
                    ? 'HAPPY NEW YEAR 🥰'
                    : 'Himanshi Khurana 🥰';
                const forcedLocation = 'Habiganj District, bangladesh';

                return InkWell(
                  onTap: () {
                    Get.to(() => MultiRoomScreen());
                  },
                  child: _ProfileCard(
                    profile: _profiles[i],
                    scale: scale,
                    showBadge: isRightCard, // right-only
                    showCoins: isRightCard, // right-only
                    forceTitle: forcedTitle, // <- set titles as requested
                    forceLocation:
                        forcedLocation, // <- set location same for both
                  ),
                );
              }, childCount: _profiles.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,
                // fixed tile height 212 (design)
                mainAxisExtent: 212,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

/// ====================== Header ======================
class _HeaderBar extends StatelessWidget {
  final double scale;
  const _HeaderBar({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CountryChip(
          label: 'Philippines',
          emoji: '🇵🇭',
          scale: scale,
          flagAsset: 'assets/icons/flagicon.png',
        ),
        const Spacer(),
        InkWell(
          onTap: () => showCountryDialogTop(context),
          borderRadius: BorderRadius.circular(999),
          child: CustomContainer(
            shape: BoxShape.circle,
            conColor: Colors.white.withOpacity(0.4), // same frosted look
            height: 27, // fixed size (no responsiveness)
            width: 27,  // fixed size (no responsiveness)
            child: Center(
              child: Image.asset(
                'assets/icons/multiicon.png',
                height: 16,
                width: 16,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        )

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
        padding: EdgeInsets.symmetric(
          horizontal: 5 * scale,
          vertical: 2 * scale,
        ),
        conColor: Colors.white38,
        borderRadius: BorderRadius.circular(28 * scale),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FlagBadge(
              diameter: 20 * scale,
              emoji: emoji,
              flagAsset: flagAsset,
            ),
            SizedBox(width: 10 * scale),
            CustomText(
              label,
              color: const Color(0xFF1D1D1F),
              fontWeight: FontWeight.w600,
              fontSize: 11 * scale,
              letterSpacing: 0.1,
            ),
          ],
        ),
      ),
    );
  }
}

class _FlagBadge extends StatelessWidget {
  final double diameter;
  final String? emoji; // fallback if image not provided
  final String? flagAsset;
  const _FlagBadge({required this.diameter, this.emoji, this.flagAsset});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: ClipOval(
        child: flagAsset != null
            ? Image.asset(
                flagAsset!,
                width: diameter,
                height: diameter,
                fit: BoxFit.cover,
              )
            : Center(child: CustomText(emoji ?? '', fontSize: diameter * 0.72)),
      ),
    );
  }
}

/// ===================== Card (212h, 189w design) =====================
class _ProfileCard extends StatelessWidget {
  final _Profile profile;
  final double scale;

  // right-only controls
  final bool showBadge;
  final bool showCoins;

  // NEW: override text
  final String? forceTitle;
  final String? forceLocation;

  const _ProfileCard({
    required this.profile,
    required this.scale,
    this.showBadge = false,
    this.showCoins = false,
    this.forceTitle,
    this.forceLocation,
  });

  @override
  Widget build(BuildContext context) {
    final radius = 26 * scale;
    final titleText = forceTitle ?? profile.title;
    final locationText = forceLocation ?? profile.location;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Media block expands within fixed 212 tile height → no overflow
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // CHANGED: Asset image instead of network
                Image.asset(profile.imageUrl, fit: BoxFit.cover),

                Positioned.fill(
                  child: CustomContainer(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Colors.black45, Colors.transparent],
                    ),
                  ),
                ),

                if (showBadge)
                  Positioned(
                    top: 10 * scale,
                    left: 10 * scale,
                    child: CustomContainer(
                      height: 19,
                      width: 66,
                      conColor: const Color(0xFF151515).withOpacity(0.75),
                      borderRadius: BorderRadius.circular(10 * scale),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText('🥰', fontSize: 8 * scale),
                          SizedBox(width: 3 * scale),
                          CustomText(
                            'Sentimental',
                            color: const Color(0xFF40FF00),
                            fontWeight: FontWeight.w500,
                            fontSize: 8 * scale,
                          ),
                        ],
                      ),
                    ),
                  ),

                if (showCoins)
                  Positioned(
                    top: 10 * scale,
                    right: 10 * scale,
                    child: CustomText(
                      '${profile.coins}',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13 * scale,
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),

                // --- Avatars (3) ---
                Positioned(
                  left: 10 * scale,
                  bottom: 10 * scale,
                  child: _AvatarStack(
                    urls: profile.peers,
                    size: 33, // exact 33 px avatar
                    step: 29, // small gap/overlap
                    avatarBorderWidth: 1, // border width 1 around avatars
                    reactionAsset: 'assets/icons/fi_1791293.png',
                    reactionSize: 8, // exact 8 px reaction image
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 8 * scale),

        // Title — 12px, weight 500
        CustomText(
          titleText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: Colors.black,
          fontSize: 12 * scale,
          fontWeight: FontWeight.w500,
        ),

        SizedBox(height: 4 * scale),

        // Location — 12px, weight 400
        CustomText(
          locationText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          color: Colors.black,
          fontSize: 12 * scale,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}

/// ============== Avatar Stack (33px, border=1, emoji image=8px) ==============
class _AvatarStack extends StatelessWidget {
  final List<String> urls;
  final double size; // avatar circle size (e.g., 33)
  final double step; // distance between circles
  final double avatarBorderWidth;
  final String? reactionAsset; // PNG overlay
  final double reactionSize; // e.g., 8 px

  const _AvatarStack({
    required this.urls,
    required this.size,
    required this.step,
    this.avatarBorderWidth = 1,
    this.reactionAsset,
    this.reactionSize = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size + (urls.length - 1) * step,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < urls.length; i++)
            Positioned(
              left: i * step,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomContainer(
                    width: size,
                    height: size,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: avatarBorderWidth,
                    ),
                    image: DecorationImage(
                      image: AssetImage(urls[i]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // small reaction image (no border)
                  Positioned(
                    right: -0,
                    bottom: -1,
                    child: SizedBox(
                      width: reactionSize,
                      height: reactionSize,
                      child: reactionAsset == null
                          ? const SizedBox.shrink()
                          : Image.asset(reactionAsset!, fit: BoxFit.contain),
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

/// ==================== Demo data (8 items) =====================
class _Profile {
  final String title;
  final String location;
  final String imageUrl;
  final int coins;
  final List<String> peers;

  const _Profile({
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.coins,
    required this.peers,
  });
}

const _profiles = <_Profile>[
  _Profile(
    title: 'HAPPY NEW YEAR 🥰',
    location: 'Habiganj District, bangladesh',
    imageUrl: 'assets/images/girl_img1.png',
    coins: 500,
    peers: [
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
    ],
  ),
  _Profile(
    title: 'Himanshi Khurana 🥰',
    location: 'Habiganj District, bangladesh',
    imageUrl: 'assets/images/girl_img1.png',
    coins: 500,
    peers: [
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
    ],
  ),
  _Profile(
    title: 'HAPPY NEW YEAR 🥰',
    location: 'Habiganj District, bangladesh',
    imageUrl: 'assets/images/girl_img1.png',
    coins: 500,
    peers: [
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
    ],
  ),
  _Profile(
    title: 'Himanshi Khurana 🥰',
    location: 'Habiganj District, bangladesh',
    imageUrl: 'assets/images/girl_img1.png',
    coins: 500,
    peers: [
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
    ],
  ),
  _Profile(
    title: 'Model • 5',
    location: 'Habiganj District, bangladesh',
    imageUrl: 'assets/images/girl_img1.png',
    coins: 500,
    peers: [
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
    ],
  ),
  _Profile(
    title: 'Model • 6',
    location: 'Habiganj District, bangladesh',
    imageUrl: 'assets/images/girl_img1.png',
    coins: 500,
    peers: [
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
    ],
  ),
  _Profile(
    title: 'Model • 7',
    location: 'Habiganj District, bangladesh',
    imageUrl: 'assets/images/girl_img1.png',
    coins: 500,
    peers: [
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
    ],
  ),
  _Profile(
    title: 'Model • 8',
    location: 'Habiganj District, bangladesh',
    imageUrl: 'assets/images/girl_img1.png',
    coins: 500,
    peers: [
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
      'assets/images/girl_img1.png',
    ],
  ),
];
