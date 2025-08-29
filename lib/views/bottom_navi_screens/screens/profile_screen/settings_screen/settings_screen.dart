import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:riolive/utile/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../controller/signin_controller.dart';
import '../../../../splashscreen/splash_screen.dart';
import 'account_security_screen/account_security_screen.dart';

/// ✅ Custom Text
class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

/// ✅ Custom App Bar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const CustomAppBar({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(
        text: title,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      backgroundColor: const Color(0xFFB6F2E3), // ✅ Added background color
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}

/// ✅ Custom Background with Gradient
class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x66B6F2E3), Color(0xFFF2D6F9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}

/// ✅ Divider
class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.black12,
      thickness: 0.8,
      indent: 12,
      endIndent: 12,
      height: 0.8,
    );
  }
}

/// ✅ List Item
class CustomListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool rightAlignSubtitle;
  final VoidCallback? onTap;

  const CustomListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.rightAlignSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  if (subtitle != null &&
                      subtitle!.isNotEmpty &&
                      !rightAlignSubtitle)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: CustomText(
                        text: subtitle!,
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty && rightAlignSubtitle)
              CustomText(text: subtitle!, fontSize: 12, color: Colors.black54),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Toggle Item
class CustomToggleItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomToggleItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

/// ✅ Logout Button
class CustomLogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomLogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: const Color(0x69676363),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: const CustomText(
          text: "Log Out",
          fontSize: 20,

          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),
    );
  }
}

/// ✅ Settings Screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SignInController _signInController; // Declare the controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signInController = Get.put(
      SignInController(),
    ); // Initialize SignInController
  }

  bool pipEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Settings"),
      body: CustomBackground(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            CustomListItem(
              title: "Account and security",
              subtitle: "Security level: Low",
              onTap: () {
                Get.to(() => const AccountAndSecurityScreen());
              },
            ),
            const CustomDivider(),
            const CustomListItem(title: "Security Password"),
            const CustomDivider(),
            const CustomListItem(title: "Language Setting"),

            // 🔹 Spacing before Blacklist
            const SizedBox(height: 20),
            const CustomDivider(),
            const CustomListItem(title: "Blacklist"),
            // 🔹 Spacing after Blacklist
            const SizedBox(height: 12),

            /// ✅ White full-width group (no radius)
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  CustomToggleItem(
                    title: "Out-of-app Picture-in-Picture",
                    value: pipEnabled,
                    onChanged: (val) {
                      setState(() {
                        pipEnabled = val;
                      });
                    },
                  ),
                  const CustomDivider(),
                  const CustomListItem(
                    title: "Version",
                    subtitle: "5.2.392.112B",
                    rightAlignSubtitle: true,
                  ),
                  const CustomDivider(),
                  const CustomListItem(title: "Rate for Rio"),
                  const CustomDivider(),
                  const CustomListItem(
                    title: "Clear Cache",
                    subtitle: "177.95M",
                    rightAlignSubtitle: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            CustomLogoutButton(
              onPressed: () async {
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      final token = await _signInController.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "No token found. Please login again.");
        Get.offAll(() => const SplashScreen()); // or SignUpScreen
        return;
      }

      final response = await http.post(
        Uri.parse(AppUrl.logout),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // header me token
        },
      );

      debugPrint("Logout status: ${response.statusCode}");
      debugPrint("Logout body: ${response.body}");

      if (response.statusCode == 200) {
        // ✅ Successful logout
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token'); // remove saved token

        Get.snackbar("Success", "Logged out successfully!");
        Get.offAll(() => const SplashScreen()); // ya SignUpScreen
      } else {
        Get.snackbar("Error", "Logout failed: ${response.statusCode}");
      }
    } catch (e, st) {
      debugPrint("Logout error: $e\n$st");
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}
