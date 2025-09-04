import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';
import '../../../../../customwidgets/CustomInputField.dart';
import '../../../../../customwidgets/custom_gradient_button.dart';

class CreateAgencyScreen extends StatelessWidget {
  const CreateAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: const CustomText(
          "Create an Agency",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg11.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 340, // 👈 content ki width limit ki (screen choti hogi)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),

                  // 🔹 Your RioLive ID
                  const CustomText("*Your RioLive Id",
                      fontSize: 14, fontWeight: FontWeight.w500),
                  const SizedBox(height: 6),
                   CustomInputField(hintText: "ID Number"),

                  const SizedBox(height: 16),

                  // 🔹 Verification Code + Get Button Inside Field
                  const CustomText("RioLive Verification Code",
                      fontSize: 14, fontWeight: FontWeight.w500),
                  const SizedBox(height: 6),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Verification Code",
                      hintStyle:
                      const TextStyle(fontSize: 12, color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade300.withOpacity(0.6),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFD6FFF), Color(0xFF8EC2FB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // 👉 GET logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(50, 30),
                          ),
                          child: const Text(
                            "Get",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Country
                  const CustomText("Country",
                      fontSize: 14, fontWeight: FontWeight.w500),
                  const SizedBox(height: 6),
                   CustomInputField(
                    hintText: "Please enter Country",
                    suffixIcon:
                    Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Description
                  const CustomText("Description",
                      fontSize: 14, fontWeight: FontWeight.w500),
                  const SizedBox(height: 6),
                   CustomInputField(hintText: "Please Add"),

                  const SizedBox(height: 16),

                  // 🔹 WhatsApp
                  const CustomText("WhatsApp",
                      fontSize: 14, fontWeight: FontWeight.w500),
                  const SizedBox(height: 6),
                   CustomInputField(
                    hintText: "Please fill in WhatsApp with country code",
                    suffixIcon:
                    Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 Experience Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          "Experience",
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 12),

                        // Radio Buttons Vertical
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: true,
                                    groupValue: true,
                                    onChanged: (_) {}),
                                const CustomText("Yes", fontSize: 12),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: false,
                                    groupValue: true,
                                    onChanged: (_) {}),
                                const CustomText("No", fontSize: 12),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Normal TextField (underline)
                        const CustomText("Name of other Platforms:",
                            fontSize: 12),
                        const SizedBox(height: 6),
                        const TextField(
                          decoration: InputDecoration(
                            hintText: "Please enter",
                            hintStyle: TextStyle(
                                fontSize: 12, color: Colors.black54),
                            border: UnderlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 12),
                        const CustomText("Proof of cooperation (optional)",
                            fontSize: 12),
                        const SizedBox(height: 8),
                        Container(
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xffDDDDDD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Apply Gradient Button
                  CustomGradientButton(
                    text: "Apply",
                    onPressed: () {},
                    width: double.infinity,
                    height: 50,
                    borderRadius: 12,
                    gradientColors: const [
                      Color(0xFFFD6FFF),
                      Color(0xFF8EC2FB)
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Warm Tips
                  const CustomText(
                    "Warm Tips:",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),

                  // 👉 Left padding for tips
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        CustomText(
                          "1. Plz invite 5 valid hosts at least within a month after registration.",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0x80000000),
                          softWrap: true,
                          maxLines: 3,
                        ),
                        SizedBox(height: 8),
                        CustomText(
                          "2. Valid host: Live for over 2 hours daily at least on one day within a week.",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0x80000000),
                          softWrap: true,
                          maxLines: 3,
                        ),
                        SizedBox(height: 10),
                        CustomText(
                          "3. If active valid hosts is less than 5 in a month, platform holds the right to take follow-up action to the agency.",
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0x80000000),
                          softWrap: true,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
