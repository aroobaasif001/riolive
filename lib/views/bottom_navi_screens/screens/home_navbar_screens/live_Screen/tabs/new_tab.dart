import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../controller/host_controller_for_new_tab.dart';
import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/customtext.dart';
import '../../../host_video_call_screen/host_start_live_streaming_screen/host_start_live_streaming_screen.dart';

class NewTab extends StatelessWidget {
  const NewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final HostController hostController = Get.put(HostController());

    final List<String> images = const [
      'assets/images/girl_img1.png',
      'assets/images/girl_img2.png',
      'assets/images/hbg3.jpg',
      'assets/images/hbg4.jpg',
    ];

    return Obx(() {
      final hosts = hostController.hosts;

      return CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Grid cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 210,
                mainAxisSpacing: 1,
                crossAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final host = hosts[index];
                final img = images[index % images.length];

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => const HostStartLiveStreamingScreen(),
                      arguments: {
                        "channelName": host.channelName,
                        "token": host.token,
                        "appId": host.appId,
                        "uid": host.id,
                        "isHost": false,
                      },
                    );
                  },
                  child: Column(
                    children: [
                      // top image + badges
                      CustomContainer(
                        height: 159,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        image: DecorationImage(
                          image: AssetImage(img),
                          fit: BoxFit.fill,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              conColor: Colors.redAccent,
                              borderRadius: BorderRadius.circular(12),
                              child: const CustomText(
                                'Live',
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            CustomContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              conColor: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.pinkAccent,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  CustomText(
                                    "99",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // bottom name bar
                      CustomContainer(
                        height: 35,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        conColor: const Color(0x306517DA),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                host.name,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: hosts.length),
            ),
          ),
        ],
      );
    });
  }
}
