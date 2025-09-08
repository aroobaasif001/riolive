import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/settings_screen/settings_screen.dart';

import '../../../../../customwidgets/customtext.dart';
import '../../../../../utile/dialog_helper.dart';

class FrameScreen extends StatefulWidget {
  const FrameScreen({super.key});

  @override
  _FrameScreenState createState() => _FrameScreenState();
}

class _FrameScreenState extends State<FrameScreen> {
  // Track selected item index
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/invite Hostbg.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RioliveAppBar(title: 'Frame'),
                SizedBox(height: 20),
                // === Ride items ===
                Container(
                  height: 194,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // Semi-transparent background
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/images/f12.png'), height: 108, width: 108),
                      const Text(
                        'Angle',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _rideItem(0, "assets/images/f12.png", "Angle", "360,000"),
                        _rideItem(1, "assets/images/f12.png", "Floral Bike", "360,000"),
                        _rideItem(2, "assets/images/f12.png", "Floral Bike", "360,000"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // === Entrance items ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _rideItem(3, "assets/images/f12.png", "Floral Bike", "360,000"),
                        _rideItem(4, "assets/images/f12.png", "Floral Bike", "360,000"),
                        _rideItem(5, "assets/images/f12.png", "Floral Bike", "360,000"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // === Frame items ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _rideItem(6, "assets/images/f12.png", "Floral Bike", "360,000"),
                        _rideItem(7, "assets/images/f12.png", "Floral Bike", "360,000"),
                        _rideItem(8, "assets/images/f12.png", "Floral Bike", "360,000"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Container(
                  height: 77,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffEEBFBF),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image(image: AssetImage('assets/images/daimondlastframe.png'),height: 18,width: 16,),
                        SizedBox(width: 5,),
                        CustomText(text:'360,000',fontWeight: FontWeight.w400,fontSize: 14,),
                        SizedBox(width: 150,),
                        CustomGradientButton(text: 'Purchase', onPressed: () {
                          showAngelGiftBottomSheet(context);

                        },width: 114,height: 36,)

                    ],),
                  ),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for ride items (with selected state for container)
  Widget _rideItem(int index, String asset, String label, String price) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = isSelected ? null : index; // Toggle selection
        });
      },
      child: Container(
        height: 151,
        width: 125,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent, // White background when selected
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Color(0xffDF9B44), width: 1) : null, // Golden border when selected
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : null, // Add shadow only when selected
        ),
        child: Column(
          children: [
            Image.asset(asset, height: 80, width: 80, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset('assets/images/f15daimend.png', height: 14, width: 14, fit: BoxFit.contain),
                const SizedBox(width: 2),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
