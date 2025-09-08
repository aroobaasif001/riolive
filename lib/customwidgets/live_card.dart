import 'package:flutter/material.dart';

import 'custom_container.dart';
import 'customtext.dart';

class LiveCard extends StatelessWidget {
  const LiveCard({
    required this.image,
    required this.name,
    this.isGray = false,
  });
  final String image;
  final String name;
  final bool isGray;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: isGray
                  ? const ColorFilter.mode(Colors.white, BlendMode.saturation)
                  : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: Image.asset(
                image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(left: 5, bottom: 38, child: _liveBadge('Live')),
            Positioned(right: 5, bottom: 38, child: _liveBadge('91')),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomContainer(
                height: 34,
                conColor: Colors.grey.withOpacity(.75),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  // vertical: 12,
                ),
                alignment: Alignment.centerLeft,
                child: CustomText(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _liveBadge(String text) => CustomContainer(
    child: CustomText(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
