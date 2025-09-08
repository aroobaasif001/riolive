import 'package:flutter/material.dart';

class AccountAndSecurityScreen extends StatelessWidget {
  const AccountAndSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Account and security")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB6F2E3), Colors.white, Color(0xFFF2D6F9)],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 20,
            vertical: 16,
          ),
          child: ListView(
            children: [
              // 🔹 Normal Image Section
              Center(
                child: Image.asset(
                  'assets/icons/shield.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Normal Description
              const Text(
                'Lorem Ipsum is simply dummy text of the printing Lorem Ipsum.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 🔹 Normal List Items
              ListTile(
                title: const Text(
                  "Set Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const Divider(thickness: 0.7, height: 0.7, indent: 12, endIndent: 12),

              ListTile(
                title: const Text(
                  "Phone number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  "Bind",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const SizedBox(height: 16),

              ListTile(
                title: const Text(
                  "Email address",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  "Bind",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const SizedBox(height: 24),

              // 🔹 Delete Button (custom widget abhi bhi use ho raha hai)

            ],
          ),
        ),
      ),
    );
  }
}
