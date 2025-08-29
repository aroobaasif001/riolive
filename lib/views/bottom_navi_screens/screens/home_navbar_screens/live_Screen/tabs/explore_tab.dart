import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  int _bannerIndex = 0;
  final List<String> banners = const [
    'assets/images/slide_image.png',
    'assets/images/slide_image.png',
    'assets/images/slide_image.png',
  ];
  final images = [
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
        SliverToBoxAdapter(
          child: CarouselSlider(
            items: banners
                .map(
                  (b) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(b, fit: BoxFit.cover, width: double.infinity),
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 110,
              viewportFraction: 0.93,
              autoPlay: true,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() => _bannerIndex = index);
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (i) => Container(
                width: _bannerIndex == i ? 18 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
                decoration: BoxDecoration(
                  color: _bannerIndex == i ? Colors.green : Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 14)),
        SliverToBoxAdapter(
          child: Row(
            children: [
              const Icon(Icons.public, color: Colors.blueAccent),
              const SizedBox(width: 6),
              const Text('Global', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.flag, size: 16, color: Colors.redAccent),
                    SizedBox(width: 6),
                    Text('Philippines', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.black87),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz, color: Colors.black87),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 230,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final img = images[index % images.length];
              final name = index % 2 == 0 ? 'Himanshi Khurana' : 'Kaanch';
              final viewers = index.isEven ? '56' : '91';
              return Column(
                children: [
                  CustomContainer(
                    height: 159,
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    image: DecorationImage(image: AssetImage(img), fit: BoxFit.fill),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          conColor: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                          child: const Text(
                            'Live',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                        ),
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          conColor: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.favorite, color: Colors.pinkAccent, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                viewers,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomContainer(
                    height: 35,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 11),
                    conColor: const Color(0x306517DA),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$name 🥰',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }, childCount: 8),
          ),
        ),
      ],
    );
  }
}