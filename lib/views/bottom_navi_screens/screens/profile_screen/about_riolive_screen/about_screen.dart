import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
/// ✅ Custom App Bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CustomAppBar({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color(0xFFB6F2E3),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context); // Back action
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200);
}

class CustomGradient {
  static const LinearGradient mainBackground = LinearGradient(
    colors: [
      Color(0xFFB6F2E3),
      Color(0xFFF2D6F9),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
/// ✅ Custom Background with Gradient
class CustomBackground extends StatelessWidget {
  final Widget child;
  const CustomBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: CustomGradient.mainBackground, // ✅ using custom gradient
      ),
      child: SafeArea(child: child),
    );
  }
}

/// ✅ Custom List Item
class CustomListItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const CustomListItem({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {}, // Optional action
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black12,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Main Screen
class AboutRioScreen extends StatelessWidget {
  const AboutRioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: CustomAppBar(title: "About Rio"),
      body: CustomBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 20, vertical: 20),
          child: ListView(
            children: const [
              CustomListItem(title: "Privacy Policy"),
              CustomListItem(title: "Terms of service"),
              CustomListItem(title: "Live Agreement"),
              CustomListItem(title: "User Recharge Agreement"),
              CustomListItem(title: "No Child endangerment policy"),
            ],
          ),
        ),
      ),
    );
  }
}