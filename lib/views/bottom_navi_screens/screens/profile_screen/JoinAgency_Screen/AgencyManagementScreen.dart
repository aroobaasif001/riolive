import 'package:flutter/material.dart';

import '../../../../../customwidgets/custom_container.dart';
import '../../../../../customwidgets/customtext.dart';

class AgencyManagementScreen extends StatelessWidget {
  const AgencyManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          "Agency Management",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔹 Profile + Support + Agency Level (ek hi container)
            CustomContainer(
              conColor: Color(0xffCDF2CB), // ✅ solid light green background
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Profile Row
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage("assets/images/profile.png"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            CustomText("Alexander",
                                fontSize: 16, fontWeight: FontWeight.bold),
                            CustomText("ID: 10209804",
                                fontSize: 12, color: Colors.black54),
                          ],
                        ),
                      ),
                      const Icon(Icons.copy, color: Colors.white, size: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  // Support Row
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.support_agent, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      CustomText("Support",
                          fontSize: 14, fontWeight: FontWeight.bold),
                      Spacer(),
                      CustomText("Rio", fontSize: 14),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),

                  // My Agency Level Row
                  Row(
                    children: const [
                      Icon(Icons.bar_chart, color: Colors.purple),
                      SizedBox(width: 12),
                      CustomText("My Agency Level",
                          fontSize: 14, fontWeight: FontWeight.bold),
                      Spacer(),
                      CustomText("A:16%", fontSize: 14, color: Colors.black87),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Invite Section (with image background buttons)
            CustomContainer(
              conColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CustomText("Invite Creator & Agency",
                      fontSize: 14, fontWeight: FontWeight.bold),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: CustomContainer(
                          height: 44,
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/invitehost1.png"),
                            fit: BoxFit.cover,
                          ),
                          alignment: Alignment.center,
                          child: const CustomText("Invite Host",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomContainer(
                          height: 44,
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/invitehost1.png"),
                            fit: BoxFit.cover,
                          ),
                          alignment: Alignment.center,
                          child: const CustomText("Invite Agency",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CustomText("SUMMARY",
                    fontWeight: FontWeight.bold, color: Colors.black),
                CustomText("Host", color: Colors.grey),
                CustomText("Sub AGENCY", color: Colors.grey),
                CustomText("MINE", color: Colors.grey),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Rewards Section
            // 🔹 Rewards Section
            CustomContainer(
              conColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CustomText("Total Bonus: 0",
                          fontSize: 14, fontWeight: FontWeight.bold),
                      CustomText("Details", fontSize: 12, color: Colors.black54),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Reward 1 - Host Commission
                  CustomContainer(
                    conColor: const Color(0xFFFFF5E5),
                    borderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Left Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              CustomText("Reward 1",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                              SizedBox(height: 4),
                              CustomText("Host Commission",
                                  fontSize: 12, color: Colors.black87),
                            ],
                          ),
                        ),
                        // Right Side Commission
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: const [
                                CustomText("6%",
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                SizedBox(width: 4),
                                Icon(Icons.monetization_on,
                                    color: Colors.orange, size: 18),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const CustomText("0",
                                fontSize: 12, color: Colors.black54),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Reward 2 - Agent Commission
                  CustomContainer(
                    conColor: const Color(0xFFE5F0FF),
                    borderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Left Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              CustomText("Reward 2",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                              SizedBox(height: 4),
                              CustomText("Agent Commission",
                                  fontSize: 12, color: Colors.black87),
                            ],
                          ),
                        ),
                        // Right Side Commission
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: const [
                                CustomText("6%",
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                SizedBox(width: 4),
                                Icon(Icons.monetization_on,
                                    color: Colors.orange, size: 18),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const CustomText("0",
                                fontSize: 12, color: Colors.black54),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Reward - Total Commission
                  CustomContainer(
                    conColor: const Color(0xFFFFE5E5),
                    borderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Left Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              CustomText("Reward",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                              SizedBox(height: 4),
                              CustomText("Total Commission",
                                  fontSize: 12, color: Colors.black87),
                            ],
                          ),
                        ),
                        // Right Side Total Earned
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.monetization_on,
                                    color: Colors.orange, size: 18),
                                SizedBox(width: 4),
                                CustomText("Earned",
                                    fontSize: 12, color: Colors.black87),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const CustomText("1,917.32",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ],
                        ),
                      ],
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
