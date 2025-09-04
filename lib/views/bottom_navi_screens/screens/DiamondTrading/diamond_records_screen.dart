import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/customtext.dart';

class DiamondRecordsScreen extends StatefulWidget {
  const DiamondRecordsScreen({super.key});

  @override
  State<DiamondRecordsScreen> createState() => _DiamondRecordsScreenState();
}

class _DiamondRecordsScreenState extends State<DiamondRecordsScreen> {
  String selectedDateRange = '2025-01-18 To 2025-01-20';
  String selectedFilter = 'ALL';

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
                          'Diamond Records',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 40), // Balance the back button
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Filter Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Date Range Filter
                      Expanded(
                        child: GestureDetector(
                          onTap: _showDatePicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(25),
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
                                Expanded(
                                  child: CustomText(
                                    selectedDateRange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black54,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Type Filter
                      GestureDetector(
                        onTap: _showTypeFilter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFA726), // Yellow/Orange
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                selectedFilter,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Empty State - No Records Found
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Empty State Image
                        Container(
                          width: 280,
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background illustration (person pushing folder)
                              Image.asset(
                                'assets/icons/no_diamond.png',
                                width: 250,
                                height: 250,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback if no_diamond.png doesn't exist
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade400,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_open,
                                          size: 80,
                                          color: Colors.orange.shade800,
                                        ),
                                        const SizedBox(height: 12),
                                        CustomText(
                                          '•  •\n  ‿',
                                          fontSize: 24,
                                          color: Colors.black87,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Empty State Text
                        const CustomText(
                          'No diamond records found',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        const CustomText(
                          'Your diamond transaction history\nwill appear here',
                          fontSize: 14,
                          color: Colors.black38,
                          textAlign: TextAlign.center,
                          lineHeight: 1.4,
                        ),
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

  void _showDatePicker() {
    final dateRanges = [
      '2025-01-18 To 2025-01-20',
      '2025-01-15 To 2025-01-18',
      '2025-01-10 To 2025-01-15',
      '2025-01-01 To 2025-01-10',
      'Last 7 days',
      'Last 30 days',
    ];

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
                'Select Date Range',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              const SizedBox(height: 20),
              ...dateRanges.map((range) => ListTile(
                title: CustomText(
                  range,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                onTap: () {
                  setState(() {
                    selectedDateRange = range;
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

  void _showTypeFilter() {
    final filterTypes = [
      'ALL',
      'Recharge',
      'Spend',
      'Gift',
      'Reward',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomText(
              'Select Filter Type',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            const SizedBox(height: 20),
            ...filterTypes.map((type) => ListTile(
              title: CustomText(
                type,
                fontSize: 16,
                color: Colors.black87,
              ),
              onTap: () {
                setState(() {
                  selectedFilter = type;
                });
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }
}
