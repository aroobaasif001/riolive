import 'package:flutter/material.dart';
import '../../../../../../customwidgets/custom_container.dart';
import '../../../../../../customwidgets/customtext.dart';

class HostrewardTab extends StatelessWidget {
  const HostrewardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomContainer(
            child: SafeArea(
              top: false, // parent tab usually already handles top padding
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ================= Part 1 =================
                    Center(
                      child: CustomContainer(
                        height: 36,
                        width: 237,
                        borderRadius: BorderRadius.circular(5),
                        conColor: const Color(0x63870AE1), // 👈 bg color set here
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9B7BFF).withOpacity(.35),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.monetization_on, color: Colors.yellow, size: 18),
                            SizedBox(width: 8),
                            CustomText(
                              '10,000  =  1\$',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              shadows: [],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ================= Stats Card =================
                    CustomContainer(
                      height: 183,
                      width: 400,
                      borderRadius: BorderRadius.circular(18),
                      conColor: const Color(0xFFEDEEFF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.07),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              CustomText(
                                '( June 10- June 16 )',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F1F),
                                shadows: [],
                              ),
                              CustomText(
                                'Today Hourly Salary',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F1F1F),
                                shadows: [],
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              CustomText(
                                'Income in the past 7 days',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1F1F1F),
                                shadows: [],
                              ),
                             Row(children: [
                               Image(image: AssetImage('assets/icons/dolloricon.png'),height: 20,width: 22,),
                               CustomText(
                                 '1000',
                                 fontSize: 14,
                                 fontWeight: FontWeight.w600,
                                 color: Color(0xFF1F1F1F),
                                 shadows: [],
                               ),
                             ],)
                            ],
                          ),
                          SizedBox(height: 10,),
                          CustomText(
                            'Upgrade to',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F1F1F),
                            shadows: [],
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _chip('1000/H', selected: true),
                              _chip('2000/H'),
                              _chip('2500/H'),
                              _chip('3500/H'),
                            ],
                          ),
                          const SizedBox(height: 14),
                          CustomContainer(
                            width: 356, // 👈 fixed width
                            height: 6,  // 👈 fixed height
                            borderRadius: BorderRadius.circular(12),
                            conColor: const Color(0xFFCFE1FF),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: 0.33, // filled percentage
                                child: CustomContainer(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFB27A), Color(0xFFFF9A5C)],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                              CustomText(
                                'Tomorrow Level up need 99000',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF8A8FA1),
                                shadows: [],
                              ),
                              SizedBox(width: 5,),
                              Image(image: AssetImage('assets/icons/dolloricon.png'),height: 16,width: 16,)
                            ],)
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ================= Part 2 =================
                    CustomContainer(
                      // height: 183,            // ❌ remove fixed height
                      width: double.infinity,    // ✅ let it take available width safely
                      borderRadius: BorderRadius.circular(24),
                      conColor: const Color(0xFFF1EEFF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            'Start live to get salary',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF151515),
                            shadows: [],
                          ),
                          const SizedBox(height: 26),
                          const Padding(
                            padding: EdgeInsets.only(left: 90),
                            child: CustomText(
                              'Today Live Duration 60 minutes',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E1E1E),
                              shadows: [],
                            ),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 40, left: 20),
                                child: Image(
                                  image: AssetImage('assets/icons/recordingicon.png'),
                                  height: 28,
                                  width: 28,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                      width: 166,
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          CustomContainer(
                                            height: 6,
                                            width: 166,
                                            borderRadius: BorderRadius.circular(12),
                                            conColor: const Color(0xFFBFE4FF),
                                          ),
                                          const Positioned(
                                            left: 10,
                                            child: SizedBox(
                                              width: 10,
                                              height: 10,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFFFA34F),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const CustomText(
                                      '0/60Mins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                      shadows: [],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CustomContainer(
                              height: 27,
                              width: 69,
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7E80FF), Color(0xFF6AEEFF)],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                CustomText(
                                  'Claim',
                                  color: Color(0xff6C6868),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  shadows: [],
                                ),
                                  SizedBox(width: 5,),
                                Image(image: AssetImage('assets/icons/dolloricon.png'),height:15 ,width: 16,)
                              ],)
                            ),
                          ),
                        ],
                      ),
                    ),


                    const SizedBox(height: 16),

                    // ================= Part 3 (Notice) =================
                    CustomContainer(
                      borderRadius: BorderRadius.circular(18),
                      conColor: const Color(0xFFEDEEFF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      padding: const EdgeInsets.all(18),
                      child: const CustomText(
                        'Please Notice:\n'
                            '1. Your total countable income in the past 7 days = your current task level = your hourly basic salary ratio for that day. 10000 diamonds = 1 US dollar.\n\n'
                            '2. The total countable income of the past 7 days = the income you received from gifts and private video chats, including gold coin gifts and silver coin gifts. Other rewards, task rewards and game tips will not be counted.\n\n'
                            '3. The increase in your count income today will change your task level for the next day, but will not change your task level and hourly salary ratio for today.\n\n'
                            '4. Your task will be refreshed after task timer count down. Timer will follow Singapore Time Zone UTC +1.\n\n'
                            '5. The accumulative time of the task of receiving your basic salary is only calculated according to the time you have started the single-player live broadcast. The party room duration is not counted.',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        lineHeight: 1.5,
                        maxLines: 999,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        shadows: [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(String text, {bool selected = false}) {
    return CustomContainer(
      height: 20,
      width: 71,
      borderRadius: BorderRadius.circular(38),
      conColor: const Color(0x63E10A0E), // 👈 your color code
      alignment: Alignment.center,
      child: Stack(
        children: [
          // Inner shadow effect
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(38),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.25),
                  blurRadius: 4,
                  spreadRadius: -2, // negative = inner shadow feel
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          // Actual chip content
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.yellow, size: 16),
                const SizedBox(width: 4),
                CustomText(
                  text,
                  color: Colors.white, // ✅ always white
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  shadows: const [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
