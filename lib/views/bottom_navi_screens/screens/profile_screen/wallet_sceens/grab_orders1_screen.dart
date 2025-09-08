import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart'; // Custom Text Widget

class GrabOrders1Screen extends StatelessWidget {
  const GrabOrders1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          image: DecorationImage(
            image: AssetImage("assets/images/Livebroadcastdatabg.jpg"), // Your background image path
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RioliveAppBar(title: 'Grab Orders'),
              SizedBox(height: 20),
              // Main container with white background
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: CustomContainer(
                  width: 385,
                  height: 481,
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(12),
                  conColor: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Income Row
                      Row(
                        children: [
                          CustomText(
                            'Total income',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          Spacer(),
                          CustomText(
                            '100,000',
                            fontWeight: FontWeight.w600,
                            color: Colors.black38,
                            fontSize: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      // Order Income Row
                      Row(
                        children: [
                          CustomText(
                            'Order income',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          Spacer(),
                          CustomText(
                            '97,000',
                            fontWeight: FontWeight.w400,
                            color: Colors.black38,
                            fontSize: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      // Reward Row
                      Row(
                        children: [
                          CustomText(
                            'Reward',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          Spacer(),
                          CustomText(
                            '3,000',
                            fontWeight: FontWeight.w400,
                            color: Colors.black38,
                            fontSize: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.black.withOpacity(0.4), thickness: 1),
                      SizedBox(height: 20),
                      // Order Section - Updated to use Row & Spacer() below the divider
                      Row(
                        children: [
                          CustomText(
                            'Order:',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          Spacer(),
                          CustomText(
                            '100,000',
                            fontWeight: FontWeight.w600,
                            color: Colors.black38,
                            fontSize: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      // Amount of Payment Row
                      Row(
                        children: [
                          CustomText(
                            'Amount of payment:',
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                         SizedBox(width: 70,),
                          CustomText(
                            '\$10',
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      // Payment Channels Row
                      Row(
                        children: [
                          CustomText(
                            'Payment channels:',
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                          Spacer(),
                          CustomText(
                            'Localpayment',
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: 80),
                      // Grab Button
                      Center(
                        child: CustomGradientButton(
                          onPressed: () {},
                          text: 'Grab',
                          textColor: Color(0xffA62B2B),
                          height: 52,
                          width: 180,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          borderRadius: 30,
                          gradientColors: const [Color(0xffe496ff), Color(0xff8ec2fb)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
