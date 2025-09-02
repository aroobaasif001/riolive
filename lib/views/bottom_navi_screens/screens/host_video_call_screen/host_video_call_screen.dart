import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/host_video_call_controller.dart';
import '../../../../customwidgets/custom_container.dart';
import '../../../../customwidgets/custombutton.dart';
import '../../../../customwidgets/customcirclebutton.dart';
import '../../../../customwidgets/customtext.dart';

class HostVideoCallScreen extends StatelessWidget {
  const HostVideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HostVideoCallController());
    final size = Get.size;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background (replace with your live background image)
          CustomContainer(
            height: size.height,
            width: size.width,
            image: const DecorationImage(
              image: AssetImage("assets/images/hostVideoBg.png"),
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 Overlay content
          SafeArea(
            child: Column(
              children: [
                // Close button ❌
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CloseButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red),
                      ),
                      onPressed: () => Get.back(),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 🦜 Top popup box
                CustomContainer(
                  height: 120,
                  width: size.width * 0.9,
                  borderRadius: BorderRadius.circular(20),
                  conColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Parrot Icon + Edit
                      CustomContainer(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 1),
                        child: Column(
                          children: [
                            CustomContainer(
                              height: 60,
                              width: 60,
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                image: AssetImage("assets/images/parrot.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const CustomText(
                              "Edit",
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Middle column: title + public/private
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              "Add a title to chat",
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 10),

                            // Toggle Button (Public / Private)
                            Obx(() {
                              return GestureDetector(
                                onTap: () => controller.isPublic.value =
                                    !controller.isPublic.value,
                                child: CustomContainer(
                                  height: 32,
                                  width: 100,
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xfffba859),
                                      Color(0xfffc6363),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: CustomText(
                                    controller.isPublic.value
                                        ? "👥 Public"
                                        : "🔒 Private",
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Hashtag Text
                const CustomText(
                  "#Virtual Host",
                  fontSize: 15,
                  color: Colors.white,
                ),

                const Spacer(),

                // 🔹 Bottom buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left circle (people icon)
                    CustomCircleButton(
                      size: 70,
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: const Icon(
                        Icons.people,
                        size: 32,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Right circle (refresh icon)
                    CustomCircleButton(
                      size: 70,
                      backgroundColor: Colors.red,
                      onPressed: () {},
                      child: const Icon(
                        Icons.refresh,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Live Button
                CustomButton(
                  text: "Live",
                  backgroundColor: Colors.purple,
                  textColor: Colors.white,
                  height: 55,
                  width: size.width * 0.5,
                  onPressed: () {
                    // Start Live Action
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
