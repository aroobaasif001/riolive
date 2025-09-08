import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart'; // <-- added

import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/settings_screen/settings_screen.dart' hide CustomText;

const Color kGreyLabel = Color(0xFF999DA3);
const Color kIdGrey    = Color(0xFF8FA0A6);

class LiveBroadcastDataScreen extends StatefulWidget {
  const LiveBroadcastDataScreen({super.key});

  @override
  State<LiveBroadcastDataScreen> createState() => _LiveBroadcastDataScreenState();
}

class _LiveBroadcastDataScreenState extends State<LiveBroadcastDataScreen> {
  int _selected = 0; // 0: Today, 1: yesterday, 2: last 7 days

  // ===== Popover state =====
  final GlobalKey _helpKey = GlobalKey(); // anchor for question icon
  OverlayEntry? _helpEntry;

  void _toggleHelp() {
    if (_helpEntry == null) {
      _showHelp();
    } else {
      _hideHelp();
    }
  }

  void _showHelp() {
    // Guard double-schedule
    if (_helpEntry != null) return;

    // Wait until after layout so the anchor has a concrete RenderBox
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _helpKey.currentContext;
      if (ctx == null) return;

      final render = ctx.findRenderObject();
      if (render is! RenderBox) return;

      final anchor = render.localToGlobal(Offset.zero);
      final aSize  = render.size;
      final screen = MediaQuery.of(context).size;

      const panelW = 350.0;
      const arrowW = 16.0;
      const arrowH = 10.0;
      const gap    = 8.0;

      final anchorCenterX = anchor.dx + aSize.width / 2;

      // panel left/top (clamped to screen)
      double left = anchorCenterX - panelW / 2;
      left = left.clamp(12.0, screen.width - panelW - 12.0);
      final double top = anchor.dy + aSize.height + gap;

      // arrow position (kept within panel bounds)
      double arrowLeft = anchorCenterX - arrowW / 2;
      final double minArrowLeft = left + 12;
      final double maxArrowLeft = left + panelW - 12 - arrowW;
      arrowLeft = arrowLeft.clamp(minArrowLeft, maxArrowLeft);

      _helpEntry = OverlayEntry(
        builder: (_) => Stack(
          children: [
            // dim barrier — tap to close
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _hideHelp,
                child: Container(color: Colors.black.withOpacity(0.55)),
              ),
            ),

            // popover panel
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: CustomContainer(
                  width: panelW,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  borderRadius: BorderRadius.circular(12),
                  conColor: const Color(0xFF111111),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BulletLine(
                        no: '1.',
                        text: 'On Withdraw Transaction fees will vary depending on the payment method',
                      ),
                      SizedBox(height: 10),
                      _BulletLine(
                        no: '2.',
                        text: 'Settlement time: 0:00 (UTC+1)',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // little up-arrow
            Positioned(
              left: arrowLeft,
              top: top - arrowH,
              child: CustomPaint(
                size: const Size(arrowW, arrowH),
                painter: _ArrowUpPainter(color: Color(0xFF111111)),
              ),
            ),
          ],
        ),
      );

      // Use the root overlay to guarantee visibility above everything
      Overlay.of(context, rootOverlay: true)?.insert(_helpEntry!);
    });
  }

  void _hideHelp() {
    _helpEntry?.remove();
    _helpEntry = null;
  }

  @override
  void dispose() {
    _hideHelp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          image: const DecorationImage(
            image: AssetImage("assets/images/Livebroadcastdatabg.jpg"),
            fit: BoxFit.cover,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RioliveAppBar(title: 'Live broadcast Data'),
                const SizedBox(height: 30),

                // ======= PROFILE + TOP SECTION =======
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomContainer(
                            padding: const EdgeInsets.all(3),
                            conColor: Colors.white,
                            borderRadius: BorderRadius.circular(1000), // circle-ish
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage("assets/images/profile.jpg"), // replace
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  "Shadow King",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      "ID: 6523847",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: kIdGrey,
                                    ),
                                    Image(image: AssetImage('assets/icons/liveidicon.png'), height: 20, width: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Row(
                        children: [
                          // coin pill
                          CustomContainer(
                            height: 48,
                            width: 130,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            conColor: const Color(0xFFB1F1C9),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.10),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            child: const Row(
                              children: [
                                Image(image: AssetImage('assets/icons/dolloricon.png'), height: 35, width: 33),
                                Spacer(),
                                CustomText(
                                  "0",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          // question mark (ANCHOR + TAP) — use SizedBox so RenderBox is guaranteed
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _toggleHelp,
                            child: SizedBox(
                              key: _helpKey, // <-- anchor
                              height: 24,
                              width: 24,
                              child:  CustomContainer(
                                image: DecorationImage(
                                  image: AssetImage('assets/icons/quetionmarlicon.png'),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),

                          const Image(image: AssetImage('assets/icons/walleticon.png'), height: 36, width: 36),
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              "Coins Balance",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: kGreyLabel,
                            ),
                          ),
                          CustomText(
                            "Wallet",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kGreyLabel,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ======= WHITE STATS CARD (no dividers) =======
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
                  child: CustomContainer(
                    height: 210,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 18),
                    conColor: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _StatCell(value: "0", label: "Earn Coins")),
                            Expanded(child: _StatCell(value: "0", label: "Reward Coin")),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _StatCell(value: "00:00:00", label: "Time Duration")),
                            Expanded(child: _StatCell(value: "0", label: "Day Valid")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ======= LIVE RECORDS + TABS =======
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                  child: CustomText(
                    "Live Records",
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _TabText(
                        title: "Today",
                        isActive: _selected == 0,
                        onTap: () => setState(() => _selected = 0),
                      ),
                      const SizedBox(width: 24),
                      _TabText(
                        title: "yesterday",
                        isActive: _selected == 1,
                        onTap: () => setState(() => _selected = 1),
                      ),
                      const SizedBox(width: 24),
                      _TabText(
                        title: "last 7 days",
                        isActive: _selected == 2,
                        onTap: () => setState(() => _selected = 2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // ======= NO DATA =======
                const Center(
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/icons/emptyicon.png'), height: 92, width: 92),
                      SizedBox(height: 16),
                      CustomText(
                        "No Data",
                        fontSize: 18,
                        color: kGreyLabel,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== Helper widgets =====
class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          value,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        const CustomText(""), // keep placeholder (no UI change)
        CustomText(
          label,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: kGreyLabel,
        ),
      ],
    );
  }
}

class _TabText extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  const _TabText({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: CustomText(
          title,
          fontSize: 18,
          fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
          color: isActive ? Colors.black : kGreyLabel,
        ),
      ),
    );
  }
}

// ===== Popover helpers (arrow + numbered lines) =====
class _BulletLine extends StatelessWidget {
  final String no;
  final String text;
  const _BulletLine({required this.no, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 2),
        CustomText(
          no,
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          maxLines: 3,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomText(
            text,
            fontSize: 16,
            maxLines: 3,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ArrowUpPainter extends CustomPainter {
  final Color color;
  _ArrowUpPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowUpPainter oldDelegate) =>
      oldDelegate.color != color;
}
