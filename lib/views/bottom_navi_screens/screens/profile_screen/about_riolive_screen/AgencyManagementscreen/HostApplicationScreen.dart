import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customtext.dart';

class HostApplicationScreen extends StatelessWidget {
  const HostApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: CustomText(
            'Host Application',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,

          ),

          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            // FULL-SCREEN background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg12.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            // Foreground: tumhara wahi CustomContainer
            CustomContainer(
              child: Column(
                children: [
                  buildHostCard(hostname: 'عائشة', image: 'profile.png'),
                  buildHostCard(hostname: 'Reya', image: 'avatar.png'),
                  buildHostCard(hostname: 'Adnan', image: 'avatar1.png'),
                  buildHostCard(hostname: 'saamie', image: 'avatar2.png'),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }

  Padding buildHostCard({required String hostname, required String image}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align all to the left
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
              'assets/images/$image',
            ), // Profile image
          ),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                hostname, // Name
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              CustomText(
                'ID: 10207604', // ID
                fontWeight: FontWeight.normal,
                fontSize: 10,
              ),
            ],
          ),
          Spacer(),
          // Accept/Reject Buttons Section (Horizontally aligned)
          Row(
            children: [
              CustomGradientButton(
                text: 'Accept',
                onPressed: () {
                  // Add accept functionality
                },
              ),
              SizedBox(width: 2), // Space between the buttons
              SizedBox(
                child: TextButton(
                  onPressed: () {
                    // Add reject functionality
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFE8ECEF), // light grey fill
                    foregroundColor: const Color(0xFF7A7A7A), // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child:  CustomText(
                    'Rejected',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
