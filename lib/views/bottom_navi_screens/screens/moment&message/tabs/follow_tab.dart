import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customtext.dart';

class FollowTab extends StatelessWidget {
  const FollowTab({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Container(
          color: Colors.black,
          child: const Center(
            child: CustomText(text: 'Follow', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}
