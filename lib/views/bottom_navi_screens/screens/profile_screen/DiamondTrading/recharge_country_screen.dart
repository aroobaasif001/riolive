import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/profile_screen/DiamondTrading/diamond_records_screen.dart';

class RechargeCountryScreen extends StatefulWidget {
  const RechargeCountryScreen({super.key});

  @override
  State<RechargeCountryScreen> createState() => _RechargeCountryScreenState();
}

class _RechargeCountryScreenState extends State<RechargeCountryScreen> {
  String? selectedCountry;

  final List<Map<String, dynamic>> countries = [
    {'name': 'Philippines', 'flag': '🇵🇭'},
    {'name': 'United States', 'flag': '🇺🇸'},
    {'name': 'Pakistan', 'flag': '🇵🇰'},
    {'name': 'United Kingdom', 'flag': '🇬🇧'},
    {'name': 'India', 'flag': '🇮🇳'},
    {'name': 'China', 'flag': '🇨🇳'},
    {'name': 'Germany', 'flag': '🇩🇪'},
    {'name': 'France', 'flag': '🇫🇷'},
  ];

  final List<Map<String, dynamic>> agents = [
    {
      'name': 'Rani',
      'phone': '+10123656523',
      'avatar': 'assets/images/girl_img1.png',
      'flags': ['🇵🇭', '🇺🇸'],
      'countries': ['Philippines', 'USA'],
    },
    {
      'name': 'Riya',
      'phone': '+10123656523', 
      'avatar': 'assets/images/girl_img2.png',
      'flags': ['🇵🇭', '🇪🇸'],
      'countries': ['Philippines', 'Spain'],
    },
    {
      'name': 'Ritika',
      'phone': '+10123656523',
      'avatar': 'assets/images/girl_img3.png',
      'flags': ['🇹🇷', '🇫🇷'],
      'countries': ['Turkey', 'France'],
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/m&mBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                // Custom App Bar - exactly like image
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                            size: 24,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: CustomText(
                          'Recharge',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => const DiamondRecordsScreen()),
                        child: const CustomText(
                          'Records',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Diamonds Label - top right
                        const Align(
                          alignment: Alignment.centerRight,
                          child: CustomText(
                            'Diamonds',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Diamond Balance Card - exactly like image
                        Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFFBCFF), // Purple/Pink
                                Color(0xFF6E6AFF), // Blue
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Diamond Icon - positioned on left like in image
                              Positioned(
                                left: -25,
                                top: -35,
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/gem_icon.png',
                                    width: 150,
                                    height: 150,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback to regular diamond icon if gem_icon doesn't exist
                                      return Image.asset(
                                        'assets/icons/diamondicon.png',
                                        width: 80,
                                        height: 80,
                                        color: Colors.white.withOpacity(0.9),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Balance Text - exactly positioned like image
                              const Positioned(
                                right: 20,
                                bottom: 25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      '12,364,500',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                    CustomText(
                                      'Diamond Balance',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Top Up Header - exactly like image with underlines
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomText(
                                  'Top Up',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                SizedBox(height: 5,),
                                Container(
                                  height: 2,
                                  width: 30,
                                  margin: EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                            const CustomText(
                              'Agent upto 40% extra',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Country Selection Dropdown - exactly like image
                        GestureDetector(
                          onTap: () => _showCountrySelector(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Flag or Globe Icon
                                selectedCountry != null 
                                  ? Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          countries.firstWhere(
                                            (country) => country['name'] == selectedCountry,
                                            orElse: () => {'flag': '🌍'},
                                          )['flag']!,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF4FC3F7), // Light blue
                                            Color(0xFF29B6F6), // Darker blue
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Image.asset("assets/icons/globleicon.png",height: 15,width: 15,)
                                      // child: const Icon(
                                      //   Icons.public,
                                      //   color: Colors.white,
                                      //   size: 20,
                                      // ),
                                    ),
                                
                                const SizedBox(width: 12),
                                
                                // Country Selection Text
                                Expanded(
                                  child: CustomText(
                                    selectedCountry ?? 'Please Select Country',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                
                                // Dropdown Arrow
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Agent Cards - Show when country is selected
                        if (selectedCountry != null) ..._buildAgentCards(),

                        // Show message when no country selected
                        // if (selectedCountry == null)
                        //   Container(
                        //     height: 200,
                        //     child: const Center(
                        //       child: CustomText(
                        //         'Select your country to view\navailable agents',
                        //         fontSize: 16,
                        //         color: Colors.black54,
                        //         textAlign: TextAlign.center,
                        //         lineHeight: 1.5,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCountrySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                'Select Country',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              const SizedBox(height: 20),
              ...countries.map((country) => ListTile(
                leading: Text(
                  country['flag']!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: CustomText(
                  country['name']!,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                onTap: () {
                  setState(() {
                    selectedCountry = country['name'];
                  });
                  Navigator.pop(context);
                },
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAgentCards() {
    return agents.map((agent) => Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF6778FE), // Purple-blue
            Color(0xFF36FFDD), // Cyan
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                agent['avatar'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to a placeholder
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Name and Flags
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name with emoji
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      agent['name'],
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Row(
                      children: agent['flags'].map<Widget>((flag) =>
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(flag, style: const TextStyle(fontSize: 14)),
                        ),
                      ).toList(),
                    ),


                    // Phone Number with WhatsApp
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/icons/whatsapp_icon.png',
                            width: 16,
                            height: 16,
                            // color: Colors.white,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.phone, color: Colors.white, size: 16);
                            },
                          ),
                          const SizedBox(width: 6),
                          CustomText(
                            agent['phone'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.content_copy_rounded,
                            color: Colors.black54,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          

          
          // const SizedBox(width: 12),
          
          // WhatsApp Button
          Image.asset(
            'assets/icons/whatsapp_icon.png',
            width: 25,
            height: 25,
            // color: Colors.white,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.phone, color: Colors.white, size: 20);
            },
          ),
        ],
      ),
    )).toList();
  }
}
