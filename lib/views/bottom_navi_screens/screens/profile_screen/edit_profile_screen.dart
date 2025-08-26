import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riolive/customwidgets/custombutton.dart';
import 'package:riolive/customwidgets/customtext.dart';
import 'dart:io';

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

  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

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
          image: DecorationImage(
            image: AssetImage("assets/images/rgb_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16.0 : 20.0,
        vertical: 16.0,
      ),
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
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: CustomText(
                "Edit Profile",
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
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage("assets/images/avatar.png")
                          as ImageProvider,
              ),
              GestureDetector(
                onTap: _showImageSourceBottomSheet,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
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
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
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
          "Album ($_albumCount/$_maxAlbumItems)",
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
                child: Icon(
                  Icons.add,
                  size: isSmallScreen ? 32 : 36,
                  color: Colors.black54,
                ),
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
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
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

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CustomText(
                "Choose Image Source",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: brandColor,
              ),
            ),

            const SizedBox(height: 16),

            // Camera option
            _buildBottomSheetOption(
              icon: Icons.camera_alt,
              title: "Take Photo",
              subtitle: "Use camera to take a new photo",
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),

            const Divider(height: 1, indent: 24, endIndent: 24),

            // Gallery option
            _buildBottomSheetOption(
              icon: Icons.photo_library,
              title: "Choose from Gallery",
              subtitle: "Select an existing photo",
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),

            const SizedBox(height: 16),

            // Cancel button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: "Cancel",
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.grey[200]!,
                  textColor: Colors.grey[700]!,
                  height: 48,
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: brandColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        backgroundColor: Colors.red[600],
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
