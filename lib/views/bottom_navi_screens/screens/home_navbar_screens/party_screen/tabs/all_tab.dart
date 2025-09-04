import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/views/bottom_navi_screens/screens/home_navbar_screens/party_screen/party_room_screen/party_room_screen.dart';

import '../../../../../../customwidgets/custom_container.dart';

class AllTab extends StatelessWidget {
  const AllTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 same gradients you provided
    final List<LinearGradient> gradientList = [
      const LinearGradient(
        colors: [Color(0xFFFF6173), Color(0xFFFFB0B9)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      const LinearGradient(
        colors: [Color(0xFF61FF69), Color(0xFFB0FFDE)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      const LinearGradient(
        colors: [Color(0xFFFFD964), Color(0xFFFFB0B9)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      const LinearGradient(
        colors: [Color(0xFFED7FF0), Color(0xFFFFB0B9)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      const LinearGradient(
        colors: [Color(0xFFE53935), Color(0xFFFFB0B9)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ];

    // apne real list length use kar lo yahan
    final int totalFriends = 20;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: totalFriends,
      itemBuilder: (context, index) {
        final gradient = gradientList[index % gradientList.length];

        return CustomContainer(
          margin: const EdgeInsets.only(bottom: 12),
          height: 81,
          width: double.maxFinite,
          gradient: gradient,
          borderRadius: BorderRadius.circular(22),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: 82,
                width: 105,
                borderRadius: BorderRadius.circular(22),
                image: DecorationImage(
                  image: AssetImage('assets/images/girl_img3.png'),
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  Get.to(() => PartyRoomScreen());
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rajesh Kumar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Welcome Everyone",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Row(
                    children: const [
                      Image(
                        image: AssetImage('assets/icons/charticon.png'),
                        height: 14,
                        width: 12,
                      ),
                      Text(
                        "10",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
