import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customdropdownfield.dart';
import 'package:riolive/customwidgets/customtext.dart';

import '../../../../../utile/dialog_helper.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // -------- MediaQuery scaling (base width = 390) --------
    final Size screen = MediaQuery.of(context).size;
    const double baseW = 390;
    final double s = screen.width / baseW; // scale factor from width

    const coinPath = 'assets/icons/coin.png';

    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          image: const DecorationImage(
            image: AssetImage("assets/images/Livebroadcastdatabg.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 0 * s, vertical: 0 * s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RioliveAppBar(title: 'Withdraw', rightImagePath: 'assets/icons/mic_icon.png',),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20 * s, vertical: 12 * s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Total Coins Card (responsive with MediaQuery) =====
                      CustomContainer(
                        height: 176 * s,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(10 * s),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF8A2EFF), Color(0xFFCCE0FF)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 18 * s,
                            offset: Offset(0, 10 * s),
                          ),
                        ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TOP
                            Padding(
                              padding: EdgeInsets.fromLTRB(18 * s, 20 * s, 18 * s, 12 * s),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    'Total  Coins',
                                    fontSize: 20 * s,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.2 * s,
                                  ),
                                  SizedBox(height: 12 * s),
                                  Row(
                                    children: [
                                      Image.asset(coinPath, width: 39 * s, height: 39 * s),
                                      SizedBox(width: 12 * s),
                                      CustomText(
                                        '0',
                                        fontSize: 30 * s,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        lineHeight: 1.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Divider
                            CustomContainer(
                              height: 1, // keep one logical pixel to avoid overflow
                              width: double.infinity,
                              conColor: Colors.white.withOpacity(0.45),
                            ),

                            // BOTTOM (soft glassy)
                            Expanded(
                              child: CustomContainer(
                                padding: EdgeInsets.symmetric(horizontal: 10 * s),
                                conColor: Colors.white.withOpacity(0.0),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24 * s),
                                  bottomRight: Radius.circular(24 * s),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.10),
                                    blurRadius: 10 * s,
                                    offset: Offset(0, 6 * s),
                                  ),
                                ],
                                child: Row(
                                  children: [
                                    // LEFT: Withdrawal Coins
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            'Withdrawal Coins',
                                            fontSize: 13 * s,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 12 * s),
                                          Row(
                                            children: [
                                              Image.asset(coinPath, width: 25 * s, height: 25 * s),
                                              SizedBox(width: 8 * s),
                                              CustomText(
                                                '0',
                                                fontSize: 16 * s,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 24 * s),

                                    // RIGHT: Reward Coins
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            'Reward Coins',
                                            fontSize: 13 * s,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 12 * s),
                                          Row(
                                            children: [
                                              Image.asset(coinPath, width: 25 * s, height: 25 * s),
                                              SizedBox(width: 8 * s),
                                              CustomText(
                                                '0',
                                                fontSize: 16 * s,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
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
                          ],
                        ),
                      ),

                      SizedBox(height: 15 * s),

                      // ===== Method =====
                      CustomText('Method', fontSize: 16 * s, fontWeight: FontWeight.w600, color: Colors.black),
                      SizedBox(height: 12 * s),

                      Row(
                        children: [
                          SizedBox(
                            width: 74 * s,
                            child: CustomText('Step 1:', fontSize: 16 * s, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          SizedBox(width: 10 * s),
                          Expanded(
                            child: CustomDropdownField(
                              hintText: 'Select a withdraw  type',
                              height: 42 * s, borderRadius: 30 * s, fontSize: 12 * s, fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16 * s),

                      Row(
                        children: [
                          SizedBox(
                            width: 74 * s,
                            child: CustomText('Step 2:', fontSize: 16 * s, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          SizedBox(width: 10 * s),
                          Expanded(
                            child: CustomDropdownField(
                              hintText: 'Choose your country',
                              height: 42 * s, borderRadius: 30 * s, fontSize: 12 * s, fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16 * s),

                      Row(
                        children: [
                          SizedBox(
                            width: 74 * s,
                            child: CustomText('Step 3:', fontSize: 16 * s, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          SizedBox(width: 10 * s),
                          Expanded(
                            child: CustomDropdownField(
                              hintText: 'Select a Withdraw method',
                              height: 42 * s, borderRadius: 30 * s, fontSize: 12 * s, fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16 * s),

                      Row(
                        children: [
                          SizedBox(
                            width: 74 * s,
                            child: CustomText('Step 4:', fontSize: 16 * s, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          SizedBox(width: 10 * s),
                          Expanded(
                            child: CustomDropdownField(
                              hintText: 'Bind a withdraw Account',
                              height: 42 * s, borderRadius: 30 * s, fontSize: 12 * s, fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 50 * s),

                      // ===== Withdraw Amount =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText('Withdraw Amount',
                              fontSize: 16 * s, fontWeight: FontWeight.w600, color: Colors.black),
                          CustomText('10,000 = 1\$', fontSize: 16 * s, fontWeight: FontWeight.w400, color: Colors.black38),
                        ],
                      ),
                      SizedBox(height: 12 * s),

                      // ===== Stack: top pill + circle + bottom pill =====
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Top pill
                              CustomContainer(
                                height: 85 * s,
                                padding: EdgeInsets.symmetric(horizontal: 22 * s),
                                borderRadius: BorderRadius.circular(28 * s),
                                conColor: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 14 * s,
                                    offset: Offset(0, 6 * s),
                                  ),
                                ],
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      '0',
                                      fontSize: 22 * s,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      lineHeight: 1.0,
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 40 * s),
                                          child: Image.asset(coinPath, width: 29 * s, height: 29 * s),
                                        ),
                                        SizedBox(height: 10 * s),
                                        CustomText(
                                          'Balance:0',
                                          fontSize: 16 * s,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16 * s),

                              // Bottom pill
                              CustomContainer(
                                height: 85 * s,
                                padding: EdgeInsets.symmetric(horizontal: 22 * s),
                                borderRadius: BorderRadius.circular(28 * s),
                                conColor: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 14 * s,
                                    offset: Offset(0, 6 * s),
                                  ),
                                ],
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      '0',
                                      fontSize: 22 * s,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      lineHeight: 1.0,
                                    ),
                                    const Spacer(),
                                    CustomText(
                                      '\$',
                                      fontSize: 22 * s,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Center circle
                          Positioned.fill(
                            child: Center(
                              child: CustomContainer(
                                border: Border.all(width: 4 * s, color: Colors.white),
                                width: 60 * s,
                                height: 60 * s,
                                borderRadius: BorderRadius.circular(30 * s),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFFAC8EFE), Color(0xFFD56DFA)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x33000000),
                                    blurRadius: 10 * s,
                                    offset: Offset(0, 4 * s),
                                  ),
                                ],
                                child: Icon(Icons.arrow_downward_rounded, size: 28 * s, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 18 * s),

                      Center(
                        child: CustomText(
                          'PKR 0.00 - reference rate: PKR 268.51=\$1',
                          fontSize: 15 * s,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 10 * s),

                      // Withdraw button
                      Center(
                        child: CustomGradientButton(
                          text: 'Withdraw',
                          onPressed: () => openWithdrawTypeSheet(context), // <- use here
                          height: 52 * s,
                          width: 300 * s,
                          borderRadius: 30 * s,
                          gradientColors: const [Color(0xffe496ff), Color(0xff8ec2fb)],
                        ),
                      ),


                      SizedBox(height: 26 * s),

                      // ===== Instructions =====
                      CustomText('Withdrawal Instructions',
                          fontSize: 16 * s, fontWeight: FontWeight.w700, color: Colors.black),
                      SizedBox(height: 10 * s),
                      CustomText(
                        '1. A minimum of \$10 is required for each withdrawal, and the withdrawal amount must be an integer.',
                        color: const Color(0xFF5F5F5F),
                        fontSize: 16 * s,
                        fontWeight: FontWeight.w700,
                        lineHeight: 1.45,
                        maxLines: 3,
                      ),
                      SizedBox(height: 6 * s),
                      CustomText(
                        '2. Only one withdrawal per day.',
                        color: const Color(0xFF5F5F5F),
                        fontSize: 16 * s,
                        fontWeight: FontWeight.w700,
                        lineHeight: 1.45,
                        maxLines: 3,
                      ),
                      SizedBox(height: 6 * s),
                      CustomText(
                        '3. The deposit time is for reference only, please refer to the actual deposit time.',
                        color: const Color(0xFF5F5F5F),
                        fontSize: 16 * s,
                        fontWeight: FontWeight.w700,
                        lineHeight: 1.45,
                        maxLines: 3,
                      ),
                      SizedBox(height: 6 * s),
                      CustomText(
                        '4. The estimated arrival time for the funds upto 48 h',
                        color: const Color(0xFF5F5F5F),
                        fontSize: 16 * s,
                        fontWeight: FontWeight.w700,
                        lineHeight: 1.45,
                        maxLines: 3,
                      ),

                      SizedBox(height: 28 * s),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
