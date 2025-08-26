import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class SquarePost {
  final String userName;
  final String avatarAsset;
  final String? caption;
  final List<String> imageAssets; // first two shown; rest counted in +N badge
  final String timeAgo;

  const SquarePost({
    required this.userName,
    required this.avatarAsset,
    required this.imageAssets,
    this.caption,
    this.timeAgo = '5 mins ago',
  });
}

class SquareTab extends StatelessWidget {
  const SquareTab({super.key, this.posts});

  final List<SquarePost>? posts;

  static const List<SquarePost> _sample = [
    SquarePost(
      userName: 'dishi_007 ❤️😊',
      avatarAsset: 'assets/images/girl_img1.png',
      caption: "I’m Beachamtic and I’m happiest my toes in Sand.",
      imageAssets: ['assets/images/girl_img1.png'],
    ),
    SquarePost(
      userName: 'dishi_007 ❤️😊',
      avatarAsset: 'assets/images/girl_img1.png',
      caption: "I’m Beachamtic and I’m happiest my toes in Sand.",
      imageAssets: [
        'assets/images/girl_img1.png',
        'assets/images/girl_img1.png',
        'assets/images/girl_img1.png',
        'assets/images/girl_img1.png',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<SquarePost> data = posts ?? _sample;
    return Padding(
      padding: EdgeInsets.only(top: 8, left: 18, right: 18, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 80),
          CustomText(text: 'Moments', fontSize: 16, fontWeight: FontWeight.w600),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final post = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CustomContainer(
                    borderRadius: BorderRadius.circular(15),
                    conColor: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 4)),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(backgroundImage: AssetImage(post.avatarAsset), radius: 16),
                            title: Text(post.userName, style: const TextStyle(fontWeight: FontWeight.w700)),
                            trailing: const Icon(Icons.more_vert),
                          ),
                          const SizedBox(height: 4),
                          Text(post.caption ?? "", style: const TextStyle(color: Colors.black87)),
                          const SizedBox(height: 8),
                          _buildMedia(post.imageAssets, fillSingle: index == 0),
                          const SizedBox(height: 10),
                          CustomContainer(
                            conColor: const Color(0xFFF3F5F7),
                            borderRadius: BorderRadius.circular(14),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.favorite_rounded, color: Colors.red, size: 28),
                                    const SizedBox(width: 16),
                                    Image.asset('assets/icons/comment.png', height: 24),
                                    const SizedBox(width: 16),
                                    Image.asset('assets/icons/share.png', height: 22),
                                  ],
                                ),
                                CustomText(text: post.timeAgo, fontSize: 11, color: Colors.grey),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedia(List<String> assets, {bool fillSingle = false}) {
    if (assets.isEmpty) {
      return const SizedBox.shrink();
    }
    if (assets.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          assets.first,
          height: 210,
          width: double.infinity,
          fit: fillSingle ? BoxFit.fill : BoxFit.cover,
        ),
      );
    }
    // 2 or more → show first two, with +N badge on second if more remain
    final String left = assets[0];
    final String right = assets.length > 1 ? assets[1] : assets[0];
    final int remaining = assets.length - 2;
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(left, height: 160, fit: BoxFit.fill),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(right, height: 160, fit: BoxFit.fill),
              ),
              if (remaining > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xff6FFFA9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+$remaining',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
