import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/invite Hostbg.jpg"), // 👈 your bg image
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RioliveAppBar(title: 'Shop'),
                const SizedBox(height: 15),
                // === First row ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _topItem("assets/images/f.png", "Frame"),
                      _topItem("assets/images/f1.png", "Party Theme"),
                      _topItem("assets/images/f2.png", "Chat Bubble"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // === Second row ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _topItem("assets/images/f3.png", "Special ID"),
                      _topItem("assets/images/f4.png", "Entrance"),
                      _topItem("assets/images/f5.png", "Ride"),
                    ],
                  ),
                ),
                // Divider with Ride heading
                const Divider(thickness: 1.5, color: Colors.black12, endIndent: 20, indent: 25,),
            
                // === Ride Heading ===
                _sectionTitle("Ride"),
            
                // === Ride items ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _rideItem("assets/images/f6.png", "Pink Rose Carriage", "360,000"),
                      _rideItem("assets/images/f7.png", "Ultimate Sports Car", "360,000"),
                      _rideItem("assets/images/f8.png", "Luxury Car Beauty", "360,000"),
                    ],
                  ),
                ),
            
                const SizedBox(height: 20),
            
                // === Entrance Heading ===
                _sectionTitle("Entrance"),
            
                // === Entrance items ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _rideItem("assets/images/f9.png", "Luxury Sports Ride", "360,000"),
                      _rideItem("assets/images/f10.png", "Aurora Sports Car", "360,000"),
                      _rideItem("assets/images/f11.png", "Wansheng Car", "360,000"),
                    ],
                  ),
                ),
            
                const SizedBox(height: 20),
            
                // === Frame Heading ===
                _sectionTitle("Frame"),
            
                // === Frame items ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _rideItem("assets/images/f12.png", "Floral Bike", "360,000"),
                      _rideItem("assets/images/f13.png", "Floral Bike", "360,000"),
                      _rideItem("assets/images/f14.png", "Floral Bike", "360,000"),
                    ],
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for ride items (wrapped in Container with added diamond icon)
  Widget _rideItem(String asset, String label, String price) {
    return Container(
      height: 152,  // Height as requested
      width: 115,   // Width as requested
      padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5,color: Colors.grey.withOpacity(0.5)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
              SizedBox(width: 5,),
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
    );
  }

  // Helper widget for section title
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Text(
            "All >",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for top items
  Widget _topItem(String asset, String label) {
    return Column(
      children: [
        Image.asset(asset, height: 70, width: 70, fit: BoxFit.contain),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
