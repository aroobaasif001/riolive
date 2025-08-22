import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/custombutton.dart';
import 'package:riolive/customwidgets/customtext.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  int _albumCount = 0;
  final int _maxAlbumItems = 5;

  final Color brandColor = const Color(0xFF9055FA);

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/rgb_background.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            // 🔥 Entire screen scrollable
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                _buildAppBar(context, isSmallScreen),
                const SizedBox(height: 16),

                // Profile Picture Section
                _buildProfilePictureSection(isSmallScreen),
                const SizedBox(height: 20),

                // Form Fields
                _buildFormField(
                  label: "Name",
                  assetIcon: "assets/icons/user.png",
                  controller: _nameController,
                  isSmallScreen: isSmallScreen,
                  hintText: "Enter your name",
                ),
                const SizedBox(height: 20),

                _buildFormField(
                  label: "Date of Birth",
                  assetIcon: "assets/icons/date.png",
                  controller: _dobController,
                  isSmallScreen: isSmallScreen,
                  onTap: () => _selectDate(context),
                  hintText: "Select your date of birth",
                ),
                const SizedBox(height: 20),

                _buildFormField(
                  label: "Location",
                  assetIcon: "assets/icons/location.png",
                  controller: _locationController,
                  isSmallScreen: isSmallScreen,
                  hintText: "Enter your location",
                ),
                const SizedBox(height: 20),

                _buildFormField(
                  label: "Bio",
                  assetIcon: "assets/icons/bio.png",
                  controller: _bioController,
                  isSmallScreen: isSmallScreen,
                  hintText: "Write a short self introduction",
                  maxLines: 3,
                ),
                const SizedBox(height: 30),

                // Album Section
                _buildAlbumSection(isSmallScreen),
                const SizedBox(height: 40),

                // Save Button
                _buildSaveButton(isSmallScreen),
                const SizedBox(height: 20), // bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 20.0, vertical: 16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            ),
          ),
          Expanded(
            child: Center(
              child: CustomText(
                text: "Edit Profile",
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection(bool isSmallScreen) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CircleAvatar(
                radius: isSmallScreen ? 50 : 60,
                backgroundImage: const AssetImage("assets/images/avatar.png"),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    String? assetIcon,
    IconData? icon,
    required TextEditingController controller,
    required bool isSmallScreen,
    int maxLines = 1,
    VoidCallback? onTap,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 10 : 14,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 3)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: assetIcon != null
                      ? Image.asset(
                          assetIcon,
                          width: isSmallScreen ? 22 : 24,
                          height: isSmallScreen ? 22 : 24,
                        )
                      : Icon(icon, size: isSmallScreen ? 22 : 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: maxLines,
                    enabled: onTap == null,
                    style: TextStyle(
                      color: brandColor,
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: brandColor,
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "Album ($_albumCount/$_maxAlbumItems)",
          fontSize: isSmallScreen ? 14 : 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        const SizedBox(height: 12),

        // ✅ Use Wrap instead of Row
        Wrap(
          spacing: 12, // horizontal gap
          runSpacing: 12, // vertical gap
          children: [
            // Add button
            GestureDetector(
              onTap: _albumCount < _maxAlbumItems ? _addPhoto : null,
              child: Container(
                width: isSmallScreen ? 90 : 100,
                height: isSmallScreen ? 90 : 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(Icons.add, size: isSmallScreen ? 32 : 36, color: Colors.black54),
              ),
            ),

            // Album Images
            ...List.generate(
              _albumCount,
              (index) => Container(
                width: isSmallScreen ? 90 : 100,
                height: isSmallScreen ? 90 : 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/avatar.png"),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removePhoto(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isSmallScreen) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: CustomButton(
        text: "Save",
        onPressed: _saveProfile,
        width: isSmallScreen ? double.infinity : screenWidth * 0.8,
        height: isSmallScreen ? 50 : 56,
        backgroundColor: Colors.white,
        textColor: brandColor,
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: brandColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _addPhoto() {
    if (_albumCount < _maxAlbumItems) {
      setState(() {
        _albumCount++;
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _albumCount--;
    });
  }

  void _saveProfile() {
    Get.snackbar(
      'Success',
      'Profile updated successfully!',
      backgroundColor: Colors.green[600],
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }
}
