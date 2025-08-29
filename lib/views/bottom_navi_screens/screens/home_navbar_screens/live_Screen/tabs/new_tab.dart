import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class NewTab extends StatefulWidget {
  const NewTab({super.key});

  @override
  State<NewTab> createState() => _NewTabState();
}

class _NewTabState extends State<NewTab> {
  int _bannerIndex = 0;


  final List<String> images = const [
    'assets/images/girl_img1.png',
    'assets/images/girl_img2.png',
    'assets/images/hbg3.jpg',
    'assets/images/hbg4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        // Grid cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 210,
              mainAxisSpacing: 1,
              crossAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final img = images[index % images.length];
                final name = index % 2 == 0 ? 'Himanshi Khurana' : 'Kaanch';
                final viewers = index.isEven ? '56' : '91';

                return Column(
                  children: [
                    // top image + badges
                    CustomContainer(
                      height: 159,
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      image: DecorationImage(
                        image: AssetImage(img),
                        fit: BoxFit.fill,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            conColor: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                            child: const CustomText(
                              'Live',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          CustomContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            conColor: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.favorite,
                                    color: Colors.pinkAccent, size: 14),
                                const SizedBox(width: 4),
                                CustomText(
                                  viewers,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // bottom name bar
                    CustomContainer(
                      height: 35,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                      conColor: const Color(0x306517DA),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              '$name 🥰',
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
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
    );
  }
}
