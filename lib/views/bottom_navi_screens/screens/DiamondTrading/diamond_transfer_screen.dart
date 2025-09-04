import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'package:riolive/views/bottom_navi_screens/screens/DiamondTrading/diamond_records_screen.dart';
import 'package:riolive/controller/diamond_trading_controller.dart';

class DiamondTransferScreen extends StatefulWidget {
  const DiamondTransferScreen({super.key});

  @override
  State<DiamondTransferScreen> createState() => _DiamondTransferScreenState();
}

class _DiamondTransferScreenState extends State<DiamondTransferScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final DiamondTradingController controller = Get.put(DiamondTradingController());

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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Custom App Bar
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
                          'Diamond Transfer',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Support/Headphone Icon
                      const Icon(
                        Icons.headset_mic,
                        color: Colors.green,
                        size: 25,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Diamond Trading Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xff5889EC),
                    // gradient: const LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   colors: [
                    //     Color(0xFF9C27B0), // Purple
                    //     Color(0xFF7B1FA2), // Darker purple
                    //   ],
                    // ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Diamond Trading Label
                      const CustomText(
                        'Diamond Trading',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Diamond Icon and Balance Row
                      Row(
                        children: [
                          // Diamond Icon
                          Image.asset(
                            'assets/icons/diamondicon.png',
                            width: 32,
                            height: 32,
                            color: Colors.white,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.diamond,
                                color: Colors.white,
                                size: 32,
                              );
                            },
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Balance Amount
                          const Expanded(
                            child: CustomText(
                              '34,576,540',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          
                          // Record Button
                          GestureDetector(
                            onTap: () => Get.to(() => const DiamondRecordsScreen()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const CustomText(
                                'Record',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF9C27B0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Transfer Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transfer To Section
                        const CustomText(
                          'Transfer To',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // User ID Input Field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
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
                          child: TextField(
                            controller: userIdController,
                            decoration: InputDecoration(
                              hintText: 'User ID Number',
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                                fontSize: 16,
                              ),
                              suffixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Transfer Amount Section
                        const CustomText(
                          'Transfer Amount',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Amount Input Field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
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
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Please enter diamond amount',
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Send Button
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 200,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  Color(0xFF5889EC), // Purple
                                  Color(0xFFEC6AE7), // Blue
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _handleTransfer,
                                borderRadius: BorderRadius.circular(28),
                                child: const Center(
                                  child: CustomText(
                                    'Send',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
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

  void _handleTransfer() {
    final userId = userIdController.text.trim();
    final amount = amountController.text.trim();

    if (userId.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter User ID',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (amount.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter transfer amount',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Show confirmation dialog
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                'Confirm Transfer',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              const SizedBox(height: 16),
              CustomText(
                'Transfer $amount diamonds to User ID: $userId?',
                fontSize: 16,
                color: Colors.black54,
                textAlign: TextAlign.center,
                lineHeight: 1.4,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const CustomText(
                        'Cancel',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _processTransfer(userId, amount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const CustomText(
                        'Confirm',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processTransfer(String userId, String amount) {
    // TODO: Implement actual transfer logic here
    Get.snackbar(
      'Success',
      'Transfer of $amount diamonds to $userId completed!',
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );

    // Clear form
    userIdController.clear();
    amountController.clear();
  }

  @override
  void dispose() {
    userIdController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
