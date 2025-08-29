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
    barrierColor: Colors.black.withOpacity(.0), // CHANGED: slight dim so bg is visible
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, a1, a2) {
      // pill chip
      Widget chip(String label, String flagPath, {bool highlighted = false}) {
        final Color txt = highlighted ? const Color(0xFF1C2B74) : const Color(0xFF202124);
        return CustomContainer(
          conColor: Colors.white,
          height: 26,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(.75), width: 1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                height: 16, width: 16,
                borderRadius: BorderRadius.circular(11),
                conColor: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.30),
                      blurRadius: 20, offset: const Offset(5, 2))],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.asset(flagPath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              CustomText(
                label,
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
              width: MediaQuery.of(ctx).size.width, // full width
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5), // no horizontal padding
              borderRadius: cardRadius,
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [Color(0xA0FFFFFF), Color(0x80FFFFFF), Color(0x66E6EAFF)],
              ),
              border: Border.all(color: Colors.white.withOpacity(.35), width: 1),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.26), blurRadius: 24, offset: const Offset(0, 12))],
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Recent',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      shadows: const [],
                    ),
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
                    CustomText(
                      'Country list',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      shadows: const [],
                    ),
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

      // Wrap in Dialog (transparent) to keep constraints & animations nice
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        elevation: 0,
        child: Stack(
          children: [
            // ⬇️ Background blur with subtle dark tint (so screen is slightly visible)
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3), // CHANGED: lighter blur for slight visibility
                child: Container(color: Colors.black.withOpacity(0.08)), // CHANGED: subtle tint
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: dialogCard,
              ),
            ),
          ],
        ),
      );
    },
    transitionBuilder: (ctx, anim, _, child) {
      final a = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -0.06), end: Offset.zero).animate(a),
        child: child,
      );
    },
  );
}

















