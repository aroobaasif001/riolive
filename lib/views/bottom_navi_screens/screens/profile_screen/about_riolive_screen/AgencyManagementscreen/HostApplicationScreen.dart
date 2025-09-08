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
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          image: DecorationImage(
            image: AssetImage('assets/images/bg12.png'), // Update with your image path
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          child: Column(
            children: [
              // Profile and ID Section
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Align all to the left
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/profile.png'), // Profile image
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'عائشة', // Name
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
                        CustomGradientButton(
                          text: 'Rejected',
                          onPressed: () {
                            // Add reject functionality
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
