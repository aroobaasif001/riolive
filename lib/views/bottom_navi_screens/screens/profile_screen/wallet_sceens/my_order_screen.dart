import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customtext.dart'; // Custom Text Widget

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          image: DecorationImage(
            image: AssetImage("assets/images/Livebroadcastdatabg.jpg"), // Add your background image here
            fit: BoxFit.cover, // This will make the image cover the entire screen
            alignment: Alignment.topCenter,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              RioliveAppBar(title: 'My Orders'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    CustomContainer(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      height: 170,
                      width: 385,
                      conColor: Color(0xffE3D2FF),
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                 'Total Coin income',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Image(image: AssetImage('assets/icons/dolloricon.png'), height: 32, width: 32),
                                  CustomText(
                                     '100,000',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  CustomText(
                                     'Rewards',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  Image(image: AssetImage('assets/icons/dolloricon.png'), height: 20, width: 20),
                                  CustomText(
                                   '3000',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            top: 15,
                            left: 190,
                            child: Image(image: AssetImage('assets/images/bigdollorimage.png'), height: 112, width: 112),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomContainer(
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
                              Image(image: AssetImage('assets/icons/dolloricon.png'), height: 20, width: 20),
                              SizedBox(width: 5,),
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
                                 'Order income:',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              Spacer(),
                              Image(image: AssetImage('assets/icons/dolloricon.png'), height: 20, width: 20),
                              SizedBox(width: 5,),
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
                                'Reward:',
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              Spacer(),
                              Image(image: AssetImage('assets/icons/dolloricon.png'), height: 20, width: 20),
                              SizedBox(width: 5,),
                              CustomText(
                               '3,000',
                                fontWeight: FontWeight.w400,
                                color: Colors.black38,
                                fontSize: 20,
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              CustomText(
                                'Order Number:',
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
                              SizedBox(width: 5,),
                              Image(image: AssetImage('assets/images/muodericon.png'), height: 16, width: 12),
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
                              Image(image: AssetImage('assets/icons/dolloricon.png'), height: 20, width: 20),
                              SizedBox(width: 5,),
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
                              SizedBox(width: 70),
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
                          SizedBox(height: 25),
                          Row(
                            children: [
                              CustomText(
                                'Account:',
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                              Spacer(),
                              CustomText(
                                '000256625',
                                color: Colors.black38,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                              SizedBox(width: 5,),
                              Image(image: AssetImage('assets/images/muodericon.png'), height: 16, width: 12),
                            ],
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              CustomText(
                                'Recipient Name:',
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                              Spacer(),
                              CustomText(
                                '000256625',
                                color: Colors.black38,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                              SizedBox(width: 5,),
                              Image(image: AssetImage('assets/images/muodericon.png'), height: 16, width: 12),

                            ],
                          ),

                          // Grab Button
                        ],
                      ),
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
