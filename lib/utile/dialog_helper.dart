import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../customwidgets/custom_container.dart';
import '../customwidgets/customtext.dart';

class DialogHelper {
  // Show a draggable bottom sheet with custom content
  static Future<T?> showDraggableBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    double initialChildSize = 0.7,
    double minChildSize = 0.5,
    double maxChildSize = 0.95,
    bool isScrollControlled = true,
    Color backgroundColor = Colors.transparent,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: child,
        ),
      ),
    );
  }

  // Show a simple bottom sheet
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    Color backgroundColor = Colors.transparent,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: child,
      ),
    );
  }

  // Show comments bottom sheet
  static Future<T?> showCommentsBottomSheet<T>(BuildContext context) {
    return showDraggableBottomSheet<T>(
      context: context,
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Comments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          const Divider(),
          // Comments list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 15, // Dummy count
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage('assets/images/girl_img${(index % 3) + 1}.png'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'User_${index + 1}',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${index + 1}h ago',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('This is comment number ${index + 1}. Great content! 👍'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'Like',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    'Reply',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Comment input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show share options bottom sheet
  static Future<T?> showShareOptions<T>(BuildContext context) {
    return showBottomSheet<T>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Share to', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shareOption(Icons.copy, 'Copy Link', () {}),
                _shareOption(Icons.share, 'Share', () {}),
                _shareOption(Icons.download, 'Download', () {}),
                _shareOption(Icons.report, 'Report', () {}),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Helper method for share options
  static Widget _shareOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
//search box
void openTopSearchDialog(BuildContext context) {
  final recent = const [
    "Arpit", "Arpit02", "Arpit02", "Arpit02",
    "Arpit", "Arpit02", "Arpit02", "Arpit02",
    "Arpit", "Arpit02", "Arpit02", "Arpit02",
  ];

  final padTop = MediaQuery.of(context).padding.top;
  final w = MediaQuery.of(context).size.width;

  showGeneralDialog(
    context: context,
    barrierLabel: 'search',
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.15),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, a1, a2) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            // background blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: const SizedBox(),
              ),
            ),

            // frosted panel pinned to TOP (bottom radius = 10)
            Positioned(
              left: 0, right: 0, top: 120,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Container(
                  width: 430,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.30),
                    border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // space for top bar
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        'Recent',
                        fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white,
                      ),
                      const SizedBox(height: 14),
                      // pills
                      Wrap(
                        spacing: 10, runSpacing: 10,
                        children: recent.map((e) {
                          return Container(
                            height: 26,
                            width: 89,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7EBF5).withOpacity(0.95),
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(child: CustomText(e, fontWeight: FontWeight.w400, fontSize: 12)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // top floating bar: TextFormField (smaller width) + logo, with inner shadow
            Positioned(
              left: 80, right: 5, top: 50,
              child: Row(
                children: [
                  SizedBox( // <- width kam kiya (≈70% screen)
                    width: w * 0.58,
                    height: 38,
                    child: Stack(
                      children: [
                        // base dark gradient with outer shadow + border
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4A4656), Color(0xFF2D2433)],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.25), width: 0.8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                        ),
                        // faux inner shadow (top highlight + bottom shade)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withOpacity(0.18),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.18),
                                  ],
                                  stops: const [0.0, 0.55, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // TextFormField UI
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                            child: TextFormField(
                              initialValue: "",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                border: InputBorder.none,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Image.asset('assets/icons/searchiconcolor.png', height: 20, width: 20),
                                ),
                                suffixIconConstraints: const BoxConstraints(minHeight: 20, minWidth: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // brand/logo right side
                  Image.asset('assets/images/textlogo.png', height: 34),
                ],
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (ctx, anim, _, child) {
      final a = CurvedAnimation(parent: anim, curve: Curves.easeOut);
      return FadeTransition(
        opacity: a,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, -0.06), end: Offset.zero).animate(a),
          child: child,
        ),
      );
    },
  );
}
//day task box

/// Top-anchored country dialog (matches your screenshot)
void showCountryDialogTop(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'country-dialog',
    barrierColor: Colors.black.withOpacity(.0),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, a1, a2) {
      // NULL-SAFE chip
      Widget chip(String? label, String? flagPath, {bool highlighted = false}) {
        final Color txt = highlighted ? const Color(0xFF1C2B74) : const Color(0xFF202124);

        Widget flagBox;
        if (flagPath == null || flagPath.isEmpty) {
          // fallback if image path missing
          flagBox = CustomContainer(
            height: 16, width: 16,
            borderRadius: BorderRadius.circular(11),
            conColor: Colors.white,
          );
        } else {
          flagBox = CustomContainer(
            height: 16, width: 16,
            borderRadius: BorderRadius.circular(11),
            conColor: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.30), blurRadius: 20, offset: const Offset(5, 2)),
            ],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(flagPath, fit: BoxFit.cover),
            ),
          );
        }

        return CustomContainer(
          conColor: Colors.white,
          height: 26,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(.75), width: 1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              flagBox,
              const SizedBox(width: 10),
              CustomText(
                label ?? '',          // <- safe
                color: txt,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                shadows: const [],
              ),
            ],
          ),
        );
      }

      final BorderRadius cardRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );

      final dialogCard = ClipRRect(
        borderRadius: cardRadius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Padding(
            padding: const EdgeInsets.only(top: 70),
            child: CustomContainer(
              height: 380,
              width: MediaQuery.of(ctx).size.width,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              borderRadius: cardRadius,
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xA0FFFFFF), Color(0x80FFFFFF), Color(0x66E6EAFF)],
              ),
              border: Border.all(color: Colors.white.withOpacity(.35), width: 1),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.26), blurRadius: 24, offset: Offset(0, 12))],
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText('Recent', color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12, shadows: []),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16, runSpacing: 14,
                      children: [
                        chip('Afghanistan', 'assets/icons/flagicon.png'),
                        chip('Albania', 'assets/icons/flagicon.png'),
                        chip('Algeria', 'assets/icons/flagicon.png'),
                        chip('India', 'assets/icons/flagicon.png'),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const CustomText('Country list', color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12, shadows: []),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16, runSpacing: 14,
                      children: [
                        chip('Afghanistan', 'assets/icons/flagicon.png'),
                        chip('Philippines', 'assets/icons/flagicon.png', highlighted: true),
                        chip('Algeria', 'assets/icons/flagicon.png'),
                        chip('India', 'assets/icons/flagicon.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        elevation: 0,
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.black.withOpacity(0.08)),
              ),
            ),
            Align(alignment: Alignment.topCenter, child: Padding(padding: const EdgeInsets.only(top: 14), child: dialogCard)),
          ],
        ),
      );
    },
    transitionBuilder: (ctx, anim, _, child) {
      final a = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return SlideTransition(position: Tween<Offset>(begin: const Offset(0, -0.06), end: Offset.zero).animate(a), child: child);
    },
  );
}



/// ✅ Rules Popup Box Widget
/// NEW WAY: call this from onTap
void showRulesDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent, // 👈 fully transparent behind
    builder: (ctx) => rulesPopupBox(),
  );
}

Widget rulesPopupBox() {
  return Center(
    child: Transform.translate(
      offset: const Offset(0, -40), // thoda upar shift
      child: Material(
        type: MaterialType.transparency, // 👈 removes blur & yellow border
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 🔳 Main dark box using CustomContainer
            CustomContainer(
              width: 320,
              borderRadius: BorderRadius.circular(12),
              conColor: const Color(0xFF222222), // dark background
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CustomText(
                      'Rules',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [],
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomText(
                    '1. Sent invitation to your Friend',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    maxLines: 3,
                    shadows: [],
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    '2. Download Application from your reference and create account',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    maxLines: 3,
                    shadows: [],
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    '3. On first 5 recharge Diamond you got up-to 5% of diamond which they recharge',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    maxLines: 3,
                    shadows: [],
                  ),
                ],
              ),
            ),

            // ▲ triangle top-right
            const Positioned(
              right: 26,
              top: -10,
              child: _TrianglePointer(),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Little black triangle
class _TrianglePointer extends StatelessWidget {
  const _TrianglePointer();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TriangleClipper(),
      child: Container(
        width: 16,
        height: 16,
        color: const Color(0xFF222222),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();
    p.moveTo(0, size.height);
    p.lineTo(size.width / 2, 0);
    p.lineTo(size.width, size.height);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}




// invite box






class InviteDialog {
  static Future<void> showInviteSheet(BuildContext context) async {
    // inline share item
    Widget shareItem({
      required String label,
      required String asset,
      VoidCallback? onTap,
    }) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap ?? () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              asset,
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 72,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // transparent base
      builder: (ctx) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                // ⬇️ ONLY CHANGE: make sheet color a bit more opaque for a clean glass look
                color: Colors.white.withOpacity(0.80),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15), // blur effect behind
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Invite user',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Share To',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          shareItem(label: 'Copy Link', asset: 'assets/images/link.png'),
                          shareItem(label: 'Image Sharing', asset: 'assets/images/gallery.png'),
                          shareItem(label: 'WhatsApp', asset: 'assets/images/whatsapp.png'),
                          shareItem(label: 'Facebook', asset: 'assets/images/facebook.png'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


// purchase box


Future<void> showAngelGiftBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) {
      return SafeArea(
        top: false,
        child: CustomContainer(
          height: 514, // aapka current layout ke hisaab se
          conColor: const Color(0xFFEFD2F7),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 18),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 75),

                    // ------- White Card -------
                    CustomContainer(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                      conColor: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            'Angel',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 14),

                          const CustomText(
                            'Props Classification',
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              CustomText(
                                'Validity period',
                                fontSize: 14,
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                              ),
                              CustomText(
                                '2025-02-06',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          const CustomText(
                            'Days',
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              _DayChip('5 Days', false),
                              _DayChip('14 Days', true),
                              _DayChip('30 Days', false),
                            ],
                          ),

                          const SizedBox(height: 18),
                          // Divider
                          CustomContainer(
                            height: 1,
                            conColor: const Color(0xFFE7E7E7),
                            margin: const EdgeInsets.only(bottom: 14),
                          ),

                          // Gift to friend row
                          CustomContainer(
                            height: 42,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            conColor: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(18),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: CustomText(
                                    'Gift to friend :',
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                CustomContainer(
                                  height: 30,
                                  width: 79,
                                  alignment: Alignment.center,
                                  conColor: const Color(0xFFA976E5),
                                  borderRadius: BorderRadius.circular(18),
                                  child: const CustomText(
                                    'Send',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ------- Bottom Price Pill -------
                    CustomContainer(
                      width: 237,
                      height: 50,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                      conColor: const Color(0xFFC7FF87),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.grey, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Image(
                            image: AssetImage('assets/images/f15daimend.png'),
                            height: 23,
                            width: 23,
                          ),
                          SizedBox(width: 10),
                          CustomText(
                            '15000',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // ------- Ring Image on top -------
              Positioned(
                top: -40,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    height: 110,
                    child: Image.asset(
                      'assets/images/f12.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ---------- Chip (CustomContainer + CustomText) ----------
class _DayChip extends StatelessWidget {
  final String text;
  final bool selected;
  const _DayChip(this.text, this.selected);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 25,
      width: 84,
      alignment: Alignment.center,
      borderRadius: BorderRadius.circular(12),
      conColor: selected ? const Color(0xFF7BE3A3) : const Color(0xFFEFEFEF),
      child: CustomText(
        text,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: selected ? Colors.black : Colors.black87,
      ),
    );
  }
}

// withdraw sheet

// withdraw_sheets.dart

/// FIRST SHEET — Choose Withdraw type
Future<void> openWithdrawTypeSheet(BuildContext context) async {
  final s = MediaQuery.of(context).size.width / 390.0;

  const coin    = 'assets/images/banklocal.png';
  const epay    = 'assets/images/pay.png';
  const binance = 'assets/images/binance.png';

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SafeArea(
      top: false,
      child: CustomContainer(
        width: double.infinity,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26 * s)),
        conColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20 * s, 18 * s, 20 * s,
            20 * s + MediaQuery.of(context).padding.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 14 * s),
                  child: CustomText(
                    'Choose Withdraw type',
                    fontSize: 16 * s, fontWeight: FontWeight.w700, color: Colors.black87,
                  ),
                ),
                SizedBox(height: 30,),
                _typeRow(
                  context,
                  s: s,
                  iconPath: coin,
                  title: 'Bank/Local Agent',
                  feeText: 'Fee:1.5%+50p',
                  arrivalText: 'Arrival With in: 24 h',
                ),
                SizedBox(height: 16 * s),
                _typeRow(
                  context,
                  s: s,
                  iconPath: epay,
                  title: 'Epay',
                  feeText: 'Fee: 1\$',
                  arrivalText: 'Arrival With in: 48 h',
                ),
                SizedBox(height: 16 * s),
                _typeRow(
                  context,
                  s: s,
                  iconPath: binance,
                  title: 'BINANCE (BEP20)',
                  feeText: 'Fee:1.5%+50p',
                  arrivalText: 'Arrival With in: 48 h',
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// SECOND SHEET — Choose Withdraw Method
Future<void> openWithdrawMethodSheet(BuildContext context) async {
  final s = MediaQuery.of(context).size.width / 390.0;

  const bank      = 'assets/icons/bt.png';
  const easypaisa = 'assets/icons/easyp.png';
  const jazzcash  = 'assets/icons/jazz.png';

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SafeArea(
      top: false,
      child: CustomContainer(
        width: double.infinity,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26 * s)),
        conColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20 * s, 18 * s, 20 * s,
            20 * s + MediaQuery.of(context).padding.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 14 * s),
                  child: CustomText(
                    'Choose Withdraw Method',
                    fontSize: 16 * s, fontWeight: FontWeight.w700, color: Colors.black87,
                    fontType: AppFont.poppins,
                  ),
                ),
                SizedBox(height: 30,),
                _methodRow(s: s, iconPath: bank,      title: 'Bank Transfer', arrivalText: 'Arrival With in: 4 h'),
                SizedBox(height: 16 * s),
                _methodRow(s: s, iconPath: easypaisa, title: 'Easy Paisa',    arrivalText: 'Arrival With in: 4 h'),
                SizedBox(height: 16 * s),
                _methodRow(s: s, iconPath: jazzcash,  title: 'Jazz cash',     arrivalText: 'Arrival With in: 4 h'),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/* ----------------------- helpers (no classes) ----------------------- */

Widget _typeRow(
    BuildContext context, {
      required double s,
      required String iconPath,
      required String title,
      required String feeText,
      required String arrivalText,
    }) {
  return CustomContainer(
    height: 86,
    conColor: const Color(0xFFDCDCDC),
    borderRadius: BorderRadius.circular(16 * s),
    padding: EdgeInsets.symmetric(horizontal: 5 * s, vertical: 20 * s),
    child: Row(
      children: [
        CustomContainer(
          width: 48 * s, height: 48 * s,
          borderRadius: BorderRadius.circular(24 * s),
          conColor: const Color(0xFFF5EAF2),
          child: Center(child: Image.asset(iconPath,)),
        ),
        SizedBox(width: 12 * s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(title, fontSize: 16 * s, fontWeight: FontWeight.w500, color: Colors.black87),
              SizedBox(height: 5 * s),
              Row(children: [_chip(feeText, s), SizedBox(width: 3 * s), _chip(arrivalText, s)]),
            ],
          ),
        ),
        SizedBox(width: 12 * s),

        // pink "Select" pill -> closes and opens 2nd sheet
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            openWithdrawMethodSheet(context);
          },
          child: CustomContainer(
            height: 32,
            width: 92,
            padding: EdgeInsets.symmetric(horizontal: 22 * s, vertical: 5 * s),
            borderRadius: BorderRadius.circular(24 * s),
            conColor: const Color(0xFFF2D2D6),
            child: CustomText('Select', fontSize: 16 * s, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}

Widget _methodRow({
  required double s,
  required String iconPath,
  required String title,
  required String arrivalText,
}) {
  return CustomContainer(
    height: 86,
    conColor: const Color(0xFFDCDCDC),
    borderRadius: BorderRadius.circular(16 * s),
    padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 20 * s),
    child: Row(
      children: [
        CustomContainer(
          width: 48 * s, height: 48 * s,
          borderRadius: BorderRadius.circular(24 * s),
          conColor: const Color(0xFFF5EAF2),
          child: Center(child: Image.asset(iconPath,)),
        ),
        SizedBox(width: 12 * s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(title, fontSize: 18 * s, fontWeight: FontWeight.w700, color: Colors.black87),
              SizedBox(height: 5 * s),
              Row(children: [_chip(arrivalText, s)]),
            ],
          ),
        ),
        SizedBox(width: 12 * s),
        CustomContainer(
          height: 32,
          width: 92,
          padding: EdgeInsets.symmetric(horizontal: 22 * s, vertical: 5 * s),
          borderRadius: BorderRadius.circular(24 * s),
          conColor: const Color(0xFFEDCFCF),
          child: CustomText('Select', fontSize: 16 * s, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ],
    ),
  );
}

Widget _chip(String text, double s) {
  return CustomContainer(
    padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 4 * s),
    borderRadius: BorderRadius.circular(8 * s),
    conColor: const Color(0xFFEDEBFF),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(text, fontSize: 8 * s, fontWeight: FontWeight.w500, color: const Color(0xFF3B3B3B)),
      ],
    ),
  );
}












































