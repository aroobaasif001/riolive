import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  int _selectedIndex = 1; // Default: Explore
  int _bannerIndex = 0;
  final banners = [
    'assets/images/slide_image.png',
    'assets/images/slide_image.png',
    'assets/images/slide_image.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildChip('New', _selectedIndex == 0),
            _buildChip('Explore', _selectedIndex == 1),
            _buildChip('PK', _selectedIndex == 2),
            _buildChip('Multi', _selectedIndex == 3),
          ],
        ),
        const SizedBox(height: 12),
        CarouselSlider(
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
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (i) => Container(
              width: _bannerIndex == i ? 18 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _bannerIndex == i ? Colors.green : Colors.green.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
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
        const SizedBox(height: 10),
        // GridView.builder(
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //     mainAxisExtent: 200,
        //     mainAxisSpacing: 12,
        //     crossAxisSpacing: 12,
        //   ),
        //   itemBuilder: (context, index) {
        //     return Column(
        //       children: [
        //         CustomContainer(
        //           height: 150,
        //           image: DecorationImage(image: AssetImage('assets/images/girl_img3.png'), fit: BoxFit.fill),
        //           borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(25),
        //             topRight: Radius.circular(25),
        //           ),
        //           padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        //           child: Row(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               // Top-left "Live" badge
        //               Container(
        //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //                 decoration: BoxDecoration(
        //                   color: Colors.redAccent,
        //                   borderRadius: BorderRadius.circular(12),
        //                 ),
        //                 child: const Text(
        //                   'Live',
        //                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
        //                 ),
        //               ),
        //
        //               // Top-right Likes badge
        //               Container(
        //                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        //                 decoration: BoxDecoration(
        //                   color: Colors.black54,
        //                   borderRadius: BorderRadius.circular(12),
        //                 ),
        //                 child: Row(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: const [
        //                     Icon(Icons.favorite, color: Colors.pinkAccent, size: 14),
        //                     SizedBox(width: 4),
        //                     Text(
        //                       '120K', // 👈 yahan apna dynamic likes count
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.w600,
        //                         fontSize: 12,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         CustomContainer(
        //           height: 40,
        //           width: double.maxFinite,
        //           conColor: Color(0x306517da),
        //           alignment: Alignment.center,
        //           borderRadius: BorderRadius.only(
        //             bottomLeft: Radius.circular(25),
        //             bottomRight: Radius.circular(25),
        //           ),
        //           child: CustomText('text'),
        //         ),
        //       ],
        //     );
        //   },
        // ),
      ],
    );
  }

  Widget _buildChip(String text, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == 'New') _selectedIndex = 0;
          if (text == 'Explore') _selectedIndex = 1;
          if (text == 'PK') _selectedIndex = 2;
          if (text == 'Multi') _selectedIndex = 3;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFFC6F7C8).withOpacity(0.85), const Color(0xFFA8F0B0).withOpacity(0.85)],
          ),
          border: Border.all(
            color: selected ? const Color(0xFFEFEA97) : Colors.transparent,
            width: selected ? 3 : 0,
          ),
          boxShadow: [
            BoxShadow(color: Colors.white.withOpacity(0.7), offset: const Offset(-4, -4), blurRadius: 10),
            BoxShadow(color: Colors.black.withOpacity(0.15), offset: const Offset(6, 6), blurRadius: 12),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF2F2F2F),
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
