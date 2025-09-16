import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/random_call_controller.dart';
import '../utile/filter_constants.dart';

class FilterBottomSheet {
  static void show(BuildContext context) {
    try {
      debugPrint("🎨 FilterBottomSheet.show called");
      final screenSize = MediaQuery.of(context).size;
      final isTablet = screenSize.width > 600;
      debugPrint("🎨 Screen size: ${screenSize.width}x${screenSize.height}, isTablet: $isTablet");
      
      showModalBottomSheet(
        context: context,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          debugPrint("🎨 Building FilterBottomSheetContent");
          return FilterBottomSheetContent(isTablet: isTablet);
        },
      ).then((_) {
        debugPrint("🎨 Bottom sheet closed");
      });
      
      debugPrint("🎨 showModalBottomSheet called successfully");
    } catch (e) {
      debugPrint("❌ Error showing FilterBottomSheet: $e");
    }
  }
}


class FilterBottomSheetContent extends StatefulWidget {
  final bool isTablet;
  
  const FilterBottomSheetContent({
    super.key,
    required this.isTablet,
  });

  @override
  State<FilterBottomSheetContent> createState() => _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<FilterBottomSheetContent> {
  String selectedFilter = FilterConstants.none; // Track selected filter

  @override
  Widget build(BuildContext context) {
    debugPrint("🎨 FilterBottomSheetContent build method called");
    
    final screenSize = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;
    debugPrint("🎨 Screen size in build: ${screenSize.width}x${screenSize.height}");

    return Container(
      height: screenSize.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: widget.isTablet ? 60 : 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isTablet ? 24 : 20,
              vertical: widget.isTablet ? 16 : 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: widget.isTablet ? 32 : 28,
                      height: widget.isTablet ? 32 : 28,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.filter_vintage,
                        color: Colors.white,
                        size: widget.isTablet ? 20 : 16,
                      ),
                    ),
                    SizedBox(width: widget.isTablet ? 16 : 12),
                    Text(
                      'Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.isTablet ? 22 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: widget.isTablet ? 26 : 24,
                  ),
                ),
              ],
            ),
          ),
          
          // Filter options
          Container(
            height: widget.isTablet ? 120 : 100,
            padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 20 : 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildFilterOptions(),
              ),
            ),
          ),
          
          // Action buttons
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.08,
              vertical: widget.isTablet ? 20 : 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.refresh,
                  label: 'Reset',
                  color: Colors.grey,
                  onTap: () {
                    try {
                      setState(() {
                        selectedFilter = FilterConstants.none;
                      });
                      final controller = Get.find<CallController>();
                      controller.removeAllFilters();
                      // Get.snackbar(
                      //   'Reset Complete',
                      //   'All filters have been removed',
                      //   backgroundColor: Colors.grey.withOpacity(0.8),
                      //   colorText: Colors.white,
                      //   duration: const Duration(seconds: 2),
                      //   icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                      // );
                    } catch (e) {
                      debugPrint("Error: $e");
                    }
                  },
                ),
                _buildActionButton(
                  icon: Icons.settings,
                  label: 'Settings',
                  color: Colors.blue,
                  onTap: () {
                    Get.snackbar(
                      'Coming Soon', 
                      'Advanced filter settings coming soon!',
                      backgroundColor: Colors.blue.withOpacity(0.8),
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                      icon: const Icon(Icons.settings, color: Colors.white),
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.check,
                  label: 'Apply',
                  color: Colors.green,
                  onTap: () {
                    // Get.snackbar('Filter Applied', 'Filter applied successfully');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          
          // Bottom safe area
          SizedBox(height: safeArea.bottom + 16),
        ],
      ),
    );
  }
  
  List<Widget> _buildFilterOptions() {
    return FilterConstants.availableFilters.map((filter) {
      final isSelected = selectedFilter == filter.id;
      
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 8 : 6),
        child: GestureDetector(
          onTap: () => _applyFilter(filter.id),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: widget.isTablet ? 70 : 60,
                    height: widget.isTablet ? 70 : 60,
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? filter.color.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: isSelected 
                          ? filter.color.withOpacity(0.8)
                          : Colors.white.withOpacity(0.3),
                        width: isSelected ? 3 : 2,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: filter.color.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ] : null,
                    ),
                    child: Icon(
                      filter.icon,
                      color: isSelected ? filter.color : Colors.white70,
                      size: widget.isTablet ? 32 : 28,
                    ),
                  ),
                  
                  // Checkmark for selected filter
                  if (isSelected)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: widget.isTablet ? 24 : 20,
                        height: widget.isTablet ? 24 : 20,
                        decoration: BoxDecoration(
                          color: filter.color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: widget.isTablet ? 14 : 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                filter.name,
                style: TextStyle(
                  color: isSelected ? filter.color : Colors.white70,
                  fontSize: widget.isTablet ? 14 : 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final size = widget.isTablet ? 70.0 : 60.0;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(widget.isTablet ? 20 : 16),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: widget.isTablet ? 32 : 28,
            ),
            if (widget.isTablet) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _applyFilter(String filterId) async {
    try {
      // Update selected state first
      setState(() {
        selectedFilter = filterId;
      });
      
      final controller = Get.find<CallController>();
      debugPrint("🎨 Applying filter: $filterId");
      
      // Apply the actual filter
      if (filterId == FilterConstants.beauty) {
        await controller.applyBeautyFilter();
      } else if (filterId == FilterConstants.none) {
        await controller.removeAllFilters();
      } else {
        await controller.applyColorFilter(filterId);
      }
      
      // Find the filter details for better message
      final filterOption = FilterConstants.availableFilters.firstWhere(
        (f) => f.id == filterId,
        orElse: () => FilterConstants.availableFilters.first,
      );
      
      // Get.snackbar(
      //   'Filter Applied',
      //   '${filterOption.name} filter applied successfully',
      //   backgroundColor: filterOption.color.withOpacity(0.8),
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 2),
      //   icon: Icon(filterOption.icon, color: Colors.white, size: 20),
      // );
    } catch (e) {
      debugPrint("❌ Error applying filter: $e");
      Get.snackbar(
        'Error',
        'Failed to apply filter: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
