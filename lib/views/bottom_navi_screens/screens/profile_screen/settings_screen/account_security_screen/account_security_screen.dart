import 'package:flutter/material.dart';


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
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      backgroundColor: const Color(0xFFB6F2E3),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onBack ?? () => Navigator(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

/// ✅ Gradient Background (3-color configurable)
class CustomBackground extends StatelessWidget {
  final Widget child;
  final Color topColor;
  final Color middleColor;
  final Color bottomColor;

  const CustomBackground({
    super.key,
    required this.child,
    this.topColor = const Color(0xFFB6F2E3), // default top
    this.middleColor = Colors.white,        // default middle
    this.bottomColor = const Color(0xFFF2D6F9), // default bottom
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [topColor, middleColor, bottomColor],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
/// ✅ Shield Icon Section
class CustomImageSection extends StatelessWidget {
  const CustomImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/icons/shield.png',
        width: 80, // Adjust size
        height: 80,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// ✅ Description Text
class CustomDescription extends StatelessWidget {
  final String text;
  const CustomDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.red,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// ✅ List Item
class CustomListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showDivider;
  final VoidCallback? onTap;

  const CustomListItem({
    super.key,
    required this.title,
    this.subtitle = '',
    this.showDivider = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      if (subtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0),
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.blue),
                          ),
                        ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
          if (showDivider)
            const Divider(
              thickness: 0.7,
              height: 0.7,
              color: Color(0xff858282),
              indent: 12,
              endIndent: 12,
            ),
        ],
      ),
    );
  }
}

/// ✅ Delete Button
class CustomDeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomDeleteButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff85828269),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: const Text(
        'Delete account',
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
      ),
    );
  }
}

/// ✅ Main Screen
class AccountAndSecurityScreen extends StatelessWidget {
  const AccountAndSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: const CustomAppBar(title: "Account and security"),
      body: CustomBackground(
        // ✅ colors can be overridden if needed
        topColor: const Color(0xFFB6F2E3),
        middleColor: Colors.white,
        bottomColor: const Color(0xFFF2D6F9),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 20, vertical: 16),
          child: ListView(
            children: const [
              CustomImageSection(),
              SizedBox(height: 16),
              CustomDescription(
                text:
                'Lorem Ipsum is simply dummy text of the printing Lorem Ipsum.',
              ),
              SizedBox(height: 16),
              CustomListItem(title: "Set Password", showDivider: true),
              CustomListItem(title: "Phone number", subtitle: "Bind"),
              SizedBox(height: 16),
              CustomListItem(title: "Email address", subtitle: "Bind"),
              SizedBox(height: 24),
              CustomDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }
}