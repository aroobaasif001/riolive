import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class PKTab extends StatelessWidget {
  const PKTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = (size.width / 375).clamp(0.85, 1.20);
    final hPad = size.width >= 600 ? 18.0 : 12.0;
    final vGap = size.width >= 600 ? 16.0 : 12.0;

    return Container(
      decoration: const BoxDecoration(),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, vGap, hPad, vGap),
            sliver: SliverList.builder(
              itemCount: 6,  // Changed from 3 to 6 items
              itemBuilder: (context, i) => Padding(
                padding: EdgeInsets.only(bottom: vGap * 1.2),
                child: PKCard(match: _matches[i % _matches.length], scale: scale),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PKCard extends StatelessWidget {
  final _PKMatch match;
  final double scale;

  const PKCard({required this.match, required this.scale});

  @override
  Widget build(BuildContext context) {
    final radius = 22.0 * scale;
    final borderWidth = 3.0;

    return CustomContainer(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFA475), Color(0xFF9356F9)],
      ),
      child: CustomContainer(
        margin: EdgeInsets.all(borderWidth),
          conColor: Colors.white,
          borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16 * scale, 12 * scale, 16 * scale, 8 * scale),
              child: Row(
                children: [
                  _UserAvatarSection(user: match.left, scale: scale, isLeft: true),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10 * scale),
                    child: SizedBox(
                      width: 38,
                      height: 38,
                      child: Image.asset('assets/images/vs.png', fit: BoxFit.contain),
                    ),
                  ),
                  _UserAvatarSection(user: match.right, scale: scale, isLeft: false),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            CustomContainer(
              height: 35,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFA671FF),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 38,
                      width: 150,
                      padding: EdgeInsets.symmetric(horizontal: 12,),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF95252),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFFFF08A), Color(0xFFFFC64A)],
                              ),
                              boxShadow: const [
                                BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Image.asset('assets/icons/hearticon.png', width: 20, height: 20), // Updated image path
                          ),
                          SizedBox(width: 6),
                          CustomText(
                            '${match.leftCoins}',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: EdgeInsets.only(right: 12 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${match.rightCoins}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13 * scale,
                            ),
                          ),
                          SizedBox(width: 8 * scale),
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFFFF08A), Color(0xFFFFC64A)],
                              ),
                              boxShadow: const [
                                BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2)),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Image.asset('assets/icons/hearticon.png', width: 20, height: 20), // Updated image path
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserAvatarSection extends StatelessWidget {
  final _PKUser user;
  final double scale;
  final bool isLeft;

  const _UserAvatarSection({required this.user, required this.scale, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Padding(
            padding: isLeft
                ? EdgeInsets.only(left: 5 * scale)
                : EdgeInsets.only(right: 5 * scale), // Adjust for 5 units movement
            child: _AvatarCircle(image: user.image, size: 64 * scale),
          ),
          SizedBox(height: 10 * scale),
          Row(
            children: [
              Expanded(
                child: Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF141414),
                  ),
                ),
              ),
              Text(' 🥰', style: TextStyle(fontSize: 14 * scale)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String image;
  final double size;

  const _AvatarCircle({required this.image, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
}

class _PKUser {
  final String name;
  final String image;
  const _PKUser({required this.name, required this.image});
}

class _PKMatch {
  final _PKUser left;
  final _PKUser right;
  final int leftCoins;
  final int rightCoins;
  const _PKMatch({
    required this.left,
    required this.right,
    this.leftCoins = 0,
    this.rightCoins = 563145,
  });
}

const _matches = <_PKMatch>[
  _PKMatch(
    left: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
    right: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
  ),
  _PKMatch(
    left: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
    right: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
  ),
  _PKMatch(
    left: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
    right: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
  ),
  _PKMatch(
    left: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
    right: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
  ),
  _PKMatch(
    left: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
    right: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
  ),
  _PKMatch(
    left: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
    right: _PKUser(name: 'Himanshi Khurana', image: 'assets/images/girl_img1.png'),
  ),
];
