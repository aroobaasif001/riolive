import 'package:flutter/material.dart';

import '../models/chat_bubble_model.dart';
import 'custom_container.dart';
import 'customtext.dart';
import 'frosted_pill.dart';
import 'level_tag.dart';

class ChatBubble extends StatelessWidget {
  final ChatBubbleModel m;
  final double maxWidth;
  const ChatBubble(this.m, {required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth, minWidth: 100),
            child: FrostedPill(
              height: null,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (m.level != null) LevelTag(level: m.level!),
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
                                    maxLines: 1,

                                    color: Colors.white.withOpacity(0.96),
                                    fontSize: 12.5,
                                    lineHeight: 1.25,
                                    overflow: TextOverflow.ellipsis,
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

          // // translate badge (top-right of the first bubble) with small tail
          // if (m.hasTranslate)
          //   Positioned(right: 8, top: -6, child: _TranslateBadge()),

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
