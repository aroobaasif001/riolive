import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'categoryTab.dart';
import 'custom_container.dart';
import 'customtext.dart';
import 'giftItem.dart';

void showGiftPopup(BuildContext context) {
  int selectedIndex = -1; // -1 means none selected
  int pageIndex = 0; // 0..3 for the 4 progress lines (optional)
  int qty = 1; // 👈 default quantity so "x1" always visible

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, modalSetState) {
          // gifts list: name, price, image
          final List<List<String>> gifts = [
            ["Goddess perfu..", "50", "assets/gifts/gift_1.png"],
            ["Goddess Crown", "50", "assets/gifts/gift_2.png"],
            ["Sapphire flowe..", "100k", "assets/gifts/gift_3.png"],
            ["Golden Crystal..", "50k", "assets/gifts/gift_4.png"],
            ["My Heart Will..", "5M", "assets/gifts/gift_5.png"],
            ["Crystal diam..", "1.5M", "assets/gifts/gift_6.png"],
            ["sapphire and d..", "50", "assets/gifts/gift_7.png"],
            ["Advanced Trea..", "50", "assets/gifts/gift_8.png"],
          ];

          return SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Get.back(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.3,
                maxChildSize: 0.9,
                builder: (_, scrollController) {
                  return CustomContainer(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF000000),
                        Color(0xFF10172C),
                        Color(0xFF0D294A),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Handle bar
                        CustomContainer(
                          margin: const EdgeInsets.only(top: 8),
                          width: 40,
                          height: 4,
                          conColor: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),

                        const SizedBox(height: 16),

                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              CustomText(
                                "Send to : Reya",
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Category tabs
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: [
                              categoryTab("Popular", true),
                              categoryTab("Lucky", false),
                              categoryTab("Events", false),
                              categoryTab("Family", false),
                              categoryTab("Cele", false),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Gift grid
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.builder(
                              controller: scrollController,
                              itemCount: gifts.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 0.8,
                                  ),
                              itemBuilder: (context, index) {
                                final g = gifts[index];
                                return giftItem(
                                  g[0], // name
                                  g[1], // price
                                  g[2], // image
                                  isSelected: selectedIndex == index,
                                  onTap: () {
                                    modalSetState(() {
                                      selectedIndex = index;
                                      // qty = 1; // (optional) reset qty on select
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),

                        // 4 progress lines
                        _TopIndicator(activeIndex: pageIndex, total: 4),

                        // Footer
                        _GiftFooter(
                          balanceText: "50 k",
                          qtyText: 'x$qty', // 👈 always shows x1 initially
                          onSend: () {
                            if (selectedIndex < 0) {
                              Get.snackbar(
                                "No gift selected",
                                "Please select a gift first",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black.withOpacity(0.6),
                                colorText: Colors.white,
                              );
                              return;
                            }
                            // TODO: send gift using gifts[selectedIndex] & qty
                            Get.back();
                          },
                          onQtyTap: () {
                            // TODO: open qty selector
                            // example quick toggle:
                            modalSetState(() {
                              qty = (qty == 1) ? 10 : 1;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    },
  );
}

// ---------- Widgets used in footer ----------

class _TopIndicator extends StatelessWidget {
  final int activeIndex;
  final int total;
  const _TopIndicator({
    Key? key,
    required this.activeIndex,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (i) {
          final bool isActive = i == activeIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 24 : 14,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }
}

class _GiftFooter extends StatelessWidget {
  final String balanceText;
  final String qtyText;
  final VoidCallback onSend;
  final VoidCallback? onQtyTap;

  const _GiftFooter({
    Key? key,
    required this.balanceText,
    required this.qtyText,
    required this.onSend,
    this.onQtyTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Balance
          Row(
            children: [
              Image.asset(
                'assets/icons/diamond_icon 2 1.png',
                height: 20,
                width: 20,
              ),
              const SizedBox(width: 6),
              CustomText(
                balanceText,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          // Promo chip
          CustomContainer(
            // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            // conColor: Colors.purple,
            // borderRadius: BorderRadius.circular(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/treasure_chest.png', // your asset
                  height: 18,
                  width: 18,
                ),
                const SizedBox(width: 6),
                const CustomText(
                  "First Top-up Gifts",
                  color: Colors.white,
                  fontSize: 12,
                ),
                const Icon(Icons.navigate_next, color: Colors.white),
              ],
            ),
          ),

          // Qty + Send pill (Row-based so label is always visible)
          _QtySendPill(
            quantityText: qtyText,
            onTapQty: onQtyTap,
            onSend: onSend,
          ),
        ],
      ),
    );
  }
}

/// Pill with left "x1" and right "Send"
class _QtySendPill extends StatelessWidget {
  final String quantityText;
  final VoidCallback? onTapQty;
  final VoidCallback onSend;

  const _QtySendPill({
    Key? key,
    required this.quantityText,
    this.onTapQty,
    required this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double pillHeight = 40;
    const double pillRadius = 22;

    return Container(
      height: pillHeight,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(pillRadius),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Left qty label
          GestureDetector(
            onTap: onTapQty,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomText(
                quantityText, // e.g., x1
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Spacer gap between qty and button
          const SizedBox(width: 8),
          // Right Send button
          GestureDetector(
            onTap: onSend,
            child: Container(
              height: pillHeight - 8,
              width: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF0079FF),

                borderRadius: BorderRadius.circular(pillRadius),
              ),
              child: const CustomText(
                "Send",
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
