import 'package:flutter/material.dart';
import '../../../../../customwidgets/custom_container.dart';
import '../../../../../customwidgets/custombutton.dart';
import '../../../../../customwidgets/customtext.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg11.png"), // apni bg image ka path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Custom AppBar
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back),
                    const SizedBox(width: 15),
                    CustomText(
                      "Settings",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // First group
                     CustomContainer(
                      title: "Account and security",
                      subTitle: "Security level: Low",
                    ),
                     CustomContainer(title: "Security Password"),
                     CustomContainer(title: "Language Setting"),

                    // Second group
                     CustomContainer(title: "Blacklist"),

                    // Third group
                     CustomContainer(title: "Out-of-app Picture-in-Picture"),
                     CustomContainer(title: "Version"),
                     CustomContainer(title: "Rate for Rio"),
                     CustomContainer(title: "Clear Cache"),

                    // Logout button
                    CustomButton(
                      text: "Log Out",
                      onTap: () {
                        // Add your logout logic
                      }, onPressed: () {  },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
