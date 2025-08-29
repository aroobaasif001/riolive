import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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
class TaskDialog extends StatelessWidget {
  final String imagePath = 'assets/images/daytaskimage.png'; // Path to your background image

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Transparent dialog background
      child: Stack(
        children: [
          // Blurred background behind the dialog
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Apply blur
              child: Container(
                color: Colors.black.withOpacity(0), // Keep it transparent
              ),
            ),
          ),

          // Column to stack text, image, and content
          Column(
            mainAxisSize: MainAxisSize.min, // Make the dialog take minimum space
            children: [
              // Text "Day 2 task" at the top of the dialog
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Day 2 task",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
              ),

              // Background image with fixed size
              Container(
                height: 425, // Fixed height of 425
                width: 350, // Fixed width of 350
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.fill, // Ensure the image covers the container
                  ),
                ),
                child: Stack(children: [
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Ensure left-aligned
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start, // Align row to start
                          children: [
                            CustomText(
                              'Require',
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5), // Add space between text and image
                            Image(
                              image: AssetImage('assets/icons/diamond_icon 2 1.png'),
                              height: 17,
                              width: 17,
                            ),
                            SizedBox(width: 5), // Add space between image and text
                            CustomText(
                              'x50',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ],
                        ), // Add space between rows
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage('assets/icons/About_24.png'),
                                height: 12,
                                width: 12,
                              ),
                              SizedBox(width: 2),
                              CustomText(
                                'Need to be completed in 3 days',
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 115,
                      right:-3 ,
                      child: Container(
                    height: 72,
                    width: 310,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/Union.png',))
                    ),
                  )),


                ],),
              ),

              // Cross icon at the top-right corner to close the dialog
              Positioned(
                right: 5,
                top: 5,
                child: IconButton(
                  icon: Image.asset('assets/icons/crossicon.png', height: 19, width: 19),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
void showTaskDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Allow tapping outside to dismiss the dialog
    builder: (BuildContext context) {
      return TaskDialog(); // Show the TaskDialog
    },
  );
}








