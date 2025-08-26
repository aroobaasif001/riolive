import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_circle.dart';
import 'package:riolive/customwidgets/customtext.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Makes the body extend behind the AppBar
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(height: 50),
          CustomCircle(
            centerImg: 'assets/images/girl_img2.png',
            topLeftImg: 'assets/images/girl_img2.png',
            topRightImg: 'assets/images/girl_img2.png',
            centerLeftImg: 'assets/images/girl_img2.png',
            centerRightImg: 'assets/images/girl_img2.png',
            bottomLeftImg: 'assets/images/girl_img2.png',
            bottomRightImg: 'assets/images/girl_img2.png',
          ),
          SizedBox(height: 40),
          CustomText(
            'Match Random Video Call',
            color: Color(0xff5EBFEF),
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontType: AppFont.poppins,
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/icons/diamondicon.png'), height: 20, width: 27),
              CustomText(
                '800/min',
                color: Color(0xff60ED59),
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontType: AppFont.poppins,
              ),
            ],
          ),
          SizedBox(height: 40),
          Material(
            color: Colors.transparent, // background transparent
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {},
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // 👈 agar background color chahiye
                ),
                padding: const EdgeInsets.all(8), // thoda spacing image k liye
                child: Image.asset('assets/icons/phoneicon.png', fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
