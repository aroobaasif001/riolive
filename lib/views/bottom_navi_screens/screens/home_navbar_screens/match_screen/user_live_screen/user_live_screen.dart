// lib/views/party_room/party_room_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/customtext.dart';
import '../../../../../../customwidgets/customtextformfield.dart';

class PartyRoomController extends GetxController {
  final hostName = 'Wamiqa J.'.obs;
  final hostId = '7205215'.obs;
  final coin = 100100.obs;

  final stories = <String>[
    'assets/images/story_1.png',
    'assets/images/story_2.png',
    'assets/images/story_3.png',
    'assets/images/story_4.png',
  ].obs;

  final messages = <_ChatBubbleModel>[
    _ChatBubbleModel(
      name: 'Roshni',
      level: 43,
      text: 'okay… Take Care…',
      hasTranslate: true,
    ),
    _ChatBubbleModel(
      name: 'Niklas',
      level: 21,
      text: 'да я уже в угол встал, на горох',
      subText: 'I\'m already in the corner, on the peas.',
      flagged: true,
    ),
    _ChatBubbleModel(
      name: 'Twinkle',
      level: 4,
      icon: Icons.circle_outlined,
      text: 'enter the stream 😊',
    ),
    _ChatBubbleModel(
      name: 'Danny',
      level: 0,
      icon: Icons.circle_outlined,
      text: 'Hello..',
    ),
  ].obs;
}

class PartyRoomScreen extends GetView<PartyRoomController> {
  const PartyRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PartyRoomController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomContainer(
        width: size.width,
        height: size.height,
        image: const DecorationImage(
          image: AssetImage('assets/images/userTabImage.jpg'),
          fit: BoxFit.cover,
        ),
        child: CustomContainer(
          conColor: Colors.black.withOpacity(0.1),
          child: SafeArea(
            child: Column(
              children: [
                /* -------------------- TOP BAR -------------------- */
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _ProfileChip(),
                          SizedBox(height: 10),
                          _CoinsChip(),
                        ],
                      ),
                      Row(
                        children: const [
                          _TinyRound(
                            size: 30,
                            image: AssetImage('assets/images/story_1.jpg'),
                          ),
                          SizedBox(width: 6),
                          _TinyRound(
                            size: 30,
                            image: AssetImage('assets/images/story_2.png'),
                          ),
                          SizedBox(width: 6),
                          _TinyRound(
                            size: 30,
                            image: AssetImage('assets/images/story_3.jpg'),
                          ),
                          SizedBox(width: 6),
                          _PlusCountChip(countText: '+98'),
                          SizedBox(width: 6),
                          _CloseButton(),
                        ],
                      ),
                    ],
                  ),
                ),

                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: CustomText(
                      'Riolive',
                      fontType: AppFont.poppins,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /* ----------------- MID CONTENT ----------------- */
                Expanded(
                  child: Column(
                    children: [
                      // Gift + Join row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(flex: 6, child: _GiftStrip()),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  _EnteredRoomPill(username: 'Alex'),
                                  SizedBox(height: 10),
                                  _JoinButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: _SafetyBlock(),
                      ),

                      const SizedBox(height: 12),

                      // Chat list scrollable
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _ChatList(),
                        ),
                      ),
                    ],
                  ),
                ),

                /* ----------------- BOTTOM ACTIONS ---------------- */
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          _RoundIcon(
                            image: AssetImage('assets/icons/gift.png'),
                          ),
                          SizedBox(width: 14),
                          _RoundIcon(
                            image: AssetImage('assets/icons/gamepad.png'),
                          ),
                          SizedBox(width: 14),
                          _RoundIcon(
                            image: AssetImage('assets/icons/grid.png'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const _MessageField(),
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

/* ========================================================================== */
/* ============================ REUSABLE WIDGETS ============================= */
/* ========================================================================== */

class _ProfileChip extends GetView<PartyRoomController> {
  const _ProfileChip();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _FrostedPill(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _TinyRound(
              size: 36,
              image: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  controller.hostName.value,
                  fontType: AppFont.poppins,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                CustomText(
                  'ID: ${controller.hostId.value}',
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.85),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const _RoundGlow(
              size: 28,
              child: Icon(
                Icons.person_add_alt_1,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinsChip extends GetView<PartyRoomController> {
  const _CoinsChip();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _FrostedPill(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.monetization_on,
              size: 18,
              color: Color(0xffFFC86B),
            ),
            const SizedBox(width: 6),
            CustomText(
              '${(controller.coin.value / 1000).toStringAsFixed(2)} k',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 13,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatList extends GetView<PartyRoomController> {
  const _ChatList();
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    return Obx(
      () => ListView.builder(
        itemCount: controller.messages.length,
        padding: EdgeInsets.zero,
        itemBuilder: (_, i) {
          final m = controller.messages[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ChatBubble(m, maxWidth: screenW * 0.88),
          );
        },
      ),
    );
  }
}

class _PlusCountChip extends StatelessWidget {
  final String countText;
  const _PlusCountChip({required this.countText});

  @override
  Widget build(BuildContext context) {
    return _FrostedPill(
      width: 35,
      height: 30,
      padding: const EdgeInsets.all(5),
      child: CustomText(
        countText,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 12,
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return const _RoundGlow(
      size: 32,
      child: Icon(Icons.close, size: 18, color: Colors.white),
    );
  }
}

class _TinyRound extends StatelessWidget {
  final double size;
  final ImageProvider image;
  const _TinyRound({required this.size, required this.image});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: size,
      width: size,
      shape: BoxShape.circle,
      image: DecorationImage(image: image, fit: BoxFit.cover),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

class _GiftStrip extends StatelessWidget {
  _GiftStrip();

  @override
  Widget build(BuildContext context) {
    return _GradientPill(
      height: 58,
      gradient: const LinearGradient(
        colors: [Color(0xffD74FFF), Color(0xff6CD6FF)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: Row(
        children: [
          const _TinyRound(
            size: 36,
            image: AssetImage('assets/images/profile.jpg'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  'David Son',
                  fontType: AppFont.poppins,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                _FrostedPill(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.ac_unit_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Flexible(
                        child: CustomText(
                          'Crystal Diamond',
                          fontSize: 12,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Row(
            children: const [
              Icon(Icons.auto_awesome, size: 18, color: Colors.white),
              SizedBox(width: 4),
              CustomText(
                'x1',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EnteredRoomPill extends StatelessWidget {
  final String username;
  const _EnteredRoomPill({required this.username});

  @override
  Widget build(BuildContext context) {
    return _GradientPill(
      height: 36,
      gradient: const LinearGradient(
        colors: [Color(0xffFFB444), Color(0xffFF6A88)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _TinyRound(
            size: 24,
            image: AssetImage('assets/images/story_1.jpg'),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: CustomText(
              '$username : entered the room',
              color: Colors.white,
              fontSize: 12.5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  const _JoinButton();

  @override
  Widget build(BuildContext context) {
    return _GradientPill(
      height: 30,
      padding: EdgeInsets.zero,
      gradient: const LinearGradient(
        colors: [Color(0xff7F3DFF), Color(0xffEB5AE5)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(width: 14),
          CustomText(
            'Alexander',
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.only(top: 1.0, bottom: 1),
            child: VerticalDivider(color: Colors.white, thickness: 1, width: 1),
          ),
          SizedBox(width: 10),
          CustomText('join', color: Colors.white, fontWeight: FontWeight.w600),
          SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _SafetyBlock extends StatelessWidget {
  const _SafetyBlock();

  @override
  Widget build(BuildContext context) {
    return _FrostedPill(
      height: null,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CustomText(
            'Welcome to the party room. We\nmonitor every LIVE Party to keep the\ncommunity safe and healthy.\nBehaviors of bullies, harasses, or\nintimidates will be reported or\nbanned from use.',
            color: Colors.white,
            fontSize: 12.5,
            lineHeight: 1.35,
          ),
        ],
      ),
    );
  }
}

class _ChatBubbleModel {
  final String name;
  final int? level;
  final IconData? icon;
  final String text;
  final String? subText;
  final bool hasTranslate;
  final bool flagged;
  _ChatBubbleModel({
    required this.name,
    this.level,
    this.icon,
    required this.text,
    this.subText,
    this.hasTranslate = false,
    this.flagged = false,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatBubbleModel m;
  final double maxWidth;
  const _ChatBubble(this.m, {required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: _FrostedPill(
              height: null,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (m.level != null) _LevelTag(level: m.level!),
                      if (m.icon != null) ...[
                        const SizedBox(width: 6),
                        Icon(m.icon, size: 14, color: Colors.white70),
                      ],
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  m.name,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                                const CustomText(
                                  ' : ',
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                Expanded(
                                  child: CustomText(
                                    m.text,
                                    color: Colors.white.withOpacity(0.96),
                                    fontSize: 12.5,
                                    lineHeight: 1.25,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ),
                            if (m.subText != null) ...[
                              const SizedBox(height: 6),
                              CustomContainer(
                                height: 1,
                                width: double.infinity,
                                conColor: Colors.white.withOpacity(0.28),
                              ),
                              const SizedBox(height: 6),
                              CustomText(
                                m.subText!,
                                color: Colors.white.withOpacity(0.92),
                                fontSize: 12.2,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // translate badge (top-right of the first bubble) with small tail
          if (m.hasTranslate)
            Positioned(right: 8, top: -6, child: _TranslateBadge()),

          // orange flag/star (inside bubble, right edge)
          if (m.flagged)
            Positioned(
              right: 8,
              bottom: 8,
              child: Icon(
                Icons.star_rate_rounded,
                size: 18,
                color: Colors.orangeAccent.withOpacity(0.95),
              ),
            ),
        ],
      ),
    );
  }
}

class _TranslateBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _FrostedPill(
          width: 50,
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.translate, size: 14, color: Colors.white),
              SizedBox(width: 6),
              CustomText('Translate', color: Colors.white, fontSize: 12),
            ],
          ),
        ),
        // little tail
        Positioned(
          bottom: -4,
          left: 18,
          child: Transform.rotate(
            angle: 0.8,
            child: CustomContainer(
              height: 8,
              width: 8,
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 0.8,
              ),
              conColor: Colors.white.withOpacity(0.15),
            ),
          ),
        ),
      ],
    );
  }
}

class _LevelTag extends StatelessWidget {
  final int level;
  const _LevelTag({required this.level});

  @override
  Widget build(BuildContext context) {
    return _GradientPill(
      width: 70,
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gradient: const LinearGradient(
        colors: [Color(0xff28C0FF), Color(0xff6EE7F9)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.badge_rounded, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          CustomText(
            'LV ${level}',
            fontSize: 11.5,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
  const _MessageField();

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: 'Say Hi…',
      prefix: const SizedBox.shrink(),
      suffix: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: IconButton(
          icon: const Icon(Icons.emoji_emotions_outlined),
          onPressed: () {},
          color: Colors.black54,
        ),
      ),
      height: 50,
      width: double.infinity,
      hintTextColor: Colors.black45,
      showDivider: false,
      padding: const EdgeInsets.symmetric(horizontal: 18),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final ImageProvider image;
  const _RoundIcon({required this.image});

  @override
  Widget build(BuildContext context) {
    return _RoundGlow(
      size: 52,
      child: CustomContainer(
        height: 52,
        width: 52,
        shape: BoxShape.circle,
        image: DecorationImage(image: image, fit: BoxFit.cover),
      ),
    );
  }
}

class _FrostedPill extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const _FrostedPill({
    required this.child,
    this.height,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: width,
      height: height,
      padding: padding,
      borderRadius: BorderRadius.circular(100),
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.20),
          Colors.white.withOpacity(0.08),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 25,
          offset: const Offset(0, 3),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.12),
          blurRadius: 25,
          offset: const Offset(-2, -2),
        ),
      ],
      border: Border.all(color: Colors.white.withOpacity(0.25), width: 0.8),
      child: child,
    );
  }
}

class _GradientPill extends StatelessWidget {
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Gradient gradient;
  final Widget child;
  final double? width;

  const _GradientPill({
    required this.child,
    this.width,
    required this.gradient,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: width,
      height: height,
      padding: padding,
      borderRadius: BorderRadius.circular(42),
      gradient: gradient,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: child,
    );
  }
}

class _RoundGlow extends StatelessWidget {
  final double size;
  final Widget child;
  const _RoundGlow({required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: size,
      width: size,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: const Color(0xff7F3DFF).withOpacity(0.6),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
      child: Center(child: child),
    );
  }
}
