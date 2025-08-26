import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_add_live_image_profile_button.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/customwidgets/social_button.dart';
import 'package:riolive/utile/dialog_helper.dart';

class VideoTab extends StatefulWidget {
  const VideoTab({super.key});

  @override
  State<VideoTab> createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(height: 90),
            // Background media
            CustomContainer(
              image: DecorationImage(image: AssetImage('assets/images/girl_img2.png'), fit: BoxFit.fill),
            ),
            //name, chat and right side buttons
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 17, bottom: 19),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Bottom-left caption
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      CustomText(
                        text: '@dishi_007',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 6),
                      CustomText(text: 'but share cant #foryou', color: Colors.white, fontSize: 12),
                      CustomText(text: '#snapyourlife', color: Colors.white, fontSize: 12),
                      SizedBox(height: 50),
                    ],
                  ),
                  // Right action bar
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomAddLiveImageProfileButton(
                        image: AssetImage('assets/images/girl_img2.png'),
                        onAddButtonPressed: () {
                          print('User followed!');
                        },
                        onImagePressed: () {
                          print('Goto profile');
                        },
                      ),
                      const SizedBox(height: 16),
                      SocialButton(asset: 'assets/icons/heard.png', onPressed: () {}),
                      const SizedBox(height: 16),
                      SocialButton(
                        asset: 'assets/icons/comment_2.png',
                        onPressed: () => DialogHelper.showCommentsBottomSheet(context),
                      ),
                      const SizedBox(height: 16),
                      SocialButton(
                        asset: 'assets/icons/share_2.png',
                        onPressed: () => DialogHelper.showShareOptions(context),
                      ),
                      const SizedBox(height: 16),
                      SocialButton(asset: 'assets/icons/live_gift_s.png', onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
