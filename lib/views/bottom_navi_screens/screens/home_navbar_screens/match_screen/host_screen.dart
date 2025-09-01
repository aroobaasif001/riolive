import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class HostScreen extends StatelessWidget {
  const HostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        image: const DecorationImage(image: AssetImage('assets/images/girl_img2.png'), fit: BoxFit.fill),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            child: Column(
              children: [
                // 🔹 Header Section
                Row(
                  children: [
                    // Profile Info
                    CustomContainer(
                      conColor: Color(0x30ffffff),
                      borderRadius: BorderRadius.circular(100),
                      padding: EdgeInsets.only(top: 1.85, bottom: 2.15, left: 3, right: 18),
                      child: Row(
                        children: [
                          CustomContainer(
                            height: 34,
                            width: 35,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/girl_img3.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                "Waniya J.",
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText("ID: 7203275", color: Colors.white, fontSize: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ],
                ),
                // 🔹 Call Timer & Coin
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          conColor: Color(0x3089ff1b),
                          borderRadius: BorderRadius.circular(10),
                          child: const CustomText("12:55:59", color: Colors.white, fontSize: 13),
                        ),
                        SizedBox(width: 14),
                        // In Call + Close
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Color(0x30361bff),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "In Call",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(0x63b90ae1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image(image: AssetImage('assets/icons/coin.png'), height: 16, width: 17),
                          const Text("100k coins", style: TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _chatBubble("Rashid", "Okay... Take care.", 50),
                          const SizedBox(height: 8),
                          _chatBubble("Rashid", "Okay... Take care.", 60),
                        ],
                      ),
                    ),
                    SizedBox(width: 50),
                    GestureDetector(
                      onTap: () {},
                      child: CustomContainer(
                        width: 100,
                        height: 120,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/girl_img1.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 37),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomContainer(
                      height: 31,
                      width: 223,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      conColor: Color(0x30ffffff),
                      borderRadius: BorderRadius.circular(25),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "Say hi...",
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: const CustomContainer(
                        height: 40,
                        width: 40,
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage('assets/icons/menu_icon.png')),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatBubble(String name, String msg, int coins) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter, // 🔹 Purple at top
          end: Alignment.bottomCenter, // 🔹 Pink at bottom
          colors: [Color(0x669557f9), Color(0x666fffa9)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // 🔹 Left Circle (with number)
          CustomContainer(
            width: 13,
            height: 13,
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter, // 🔹 Purple at top
              end: Alignment.bottomCenter, // 🔹 Pink at bottom
              colors: [Color(0x809557f9), Color(0xcc6fffa9)],
            ),
            alignment: Alignment.center,
            child: CustomText("$coins", color: Colors.white, fontSize: 5.25),
          ),

          const SizedBox(width: 8),

          // 🔹 Username + Verified + Message
          Expanded(
            child: Row(
              children: [
                CustomText(name, color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                const SizedBox(width: 4),

                // Verified Tick
                const Icon(Icons.verified, size: 7.5, color: Colors.blue),

                const SizedBox(width: 4),

                // Message
                Expanded(
                  child: Text(
                    msg,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

