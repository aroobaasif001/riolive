import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riolive/controller/diamond_trading_controller.dart';
import 'package:riolive/customwidgets/customtext.dart';

class CoinSellerScreen extends StatelessWidget {
  const CoinSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DiamondTradingController controller = Get.put(DiamondTradingController());
    final ImagePicker imagePicker = ImagePicker();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/m&mBackground.png"),fit: BoxFit.cover)
    // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color(0xFF87CEEB), // Light blue
          //     Color(0xFFE6E6FA), // Lavender
          //   ],
          // ),
        ),
        child: SafeArea(
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
                        'Coin Seller',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // Name Field
                      const CustomText(
                        'Name',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: controller.sellerNameController,
                        hint: 'Name',
                      ),

                      const SizedBox(height: 20),

                      // RioLive Verification Code
                      const CustomText(
                        'RioLive Verification Code',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: controller.verificationCodeController,
                        hint: 'Verification Code',
                            suffix: _buildGradientButton(
                            text: 'Get',
                            onPressed: controller.getVerificationCode,
                            width: 70,
                            height: 35,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            borderRadius: 17.5,
                          ),
                      ),
                      // const SizedBox(height: 8),

                      const SizedBox(height: 20),

                      // Country Field
                      const CustomText(
                        'Country',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xffDDDDDD),
                          borderRadius: BorderRadius.circular(25),
                          // border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: DropdownButton<String>(
                          value: controller.selectedCountry.value == 'Please enter Coin selling area'
                              ? null
                              : controller.selectedCountry.value,
                          hint: const CustomText(
                            'Please enter Coin selling area',
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          isExpanded: true,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                          items: controller.countries.map((country) {
                            return DropdownMenuItem<String>(
                              value: country['name'],
                              child: CustomText(
                                country['name']!,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              final selectedCountry = controller.countries
                                  .firstWhere((country) => country['name'] == value);
                              controller.selectCountry(value, selectedCountry['code']!);
                            }
                          },
                        ),
                      )),

                      const SizedBox(height: 20),

                      // Phone Number Field
                      const CustomText(
                        'Phone Number',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                                              _buildInputField(
                          controller: controller.phoneNumberController,
                          hint: 'WhatsApp Number',
                          keyboardType: TextInputType.phone,
                          prefix: Obx(() => Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xff9DA9F0),
                            ),
                            child: Text(
                              controller.selectedCountryCode.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )),
                        ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 24),
                      // ID Information Section
                      const CustomText(
                        'ID Information',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 4),
                      const CustomText(
                        'Please upload valid document',
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      const SizedBox(height: 12),

                      // ID Card Upload Section
                      Row(
                        children: [
                          // ID Card Front
                          Expanded(
                            child: _buildImageUploadCard(
                              title: 'ID Card Front',
                              onTap: () async {
                                final XFile? image = await imagePicker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (image != null) {
                                  controller.setIdCardImage(image.path, true);
                                }
                              },
                              imagePath: controller.idCardFrontPath,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // ID Card Back
                          Expanded(
                            child: _buildImageUploadCard(
                              title: 'ID Card Back',
                              onTap: () async {
                                final XFile? image = await imagePicker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (image != null) {
                                  controller.setIdCardImage(image.path, false);
                                }
                              },
                              imagePath: controller.idCardBackPath,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Apply Button
                      Align(
                        alignment: Alignment.center,
                        child: Obx(() => _buildGradientButton(
                          text: controller.isCoinSellerLoading.value ? 'Applying...' : 'Apply',
                          onPressed: controller.isCoinSellerLoading.value
                              ? () {}
                              : controller.applyCoinSeller,
                          width: 200,
                          height: 65,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          borderRadius: 50
                        )),
                      ),

                      const SizedBox(height: 20),

                      // Warm Tips Section
                      const CustomText(
                        'Warm Tips :',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            '1. Accept Driving Licensee',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          CustomText(
                            '2. Accept Govt ID',
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefix,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffDDDDDD),
        borderRadius: BorderRadius.circular(35),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefix != null ? Container(
            width: 60,
            alignment: Alignment.centerLeft,
            child: prefix,
          ) : null,
          suffixIcon: suffix != null ? Container(
            width: 100,
            padding: const EdgeInsets.all(8),
            child: suffix,
          ) : null,
          filled: true,
          fillColor: const Color(0xffDDDDDD),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.7),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: prefix != null ? 60 : suffix != null ? 8 : 20,
            vertical: 16
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadCard({
    required String title,
    required VoidCallback onTap,
    required RxString imagePath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(() => Container(
        height: 120,
        decoration: BoxDecoration(
          color: Color(0xffDDDDDD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              size: 40,
              color: Colors.grey.withOpacity(0.6),
            ),
            const SizedBox(height: 8),
            CustomText(
              title,
              fontSize: 12,
              color: Colors.black54,
              textAlign: TextAlign.center,
            ),
            if (imagePath.value.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const CustomText(
                  'Uploaded',
                  fontSize: 10,
                  color: Colors.green,
                ),
              ),
            ]
          ],
        ),
      )),
    );
  }

  // Custom Gradient Button Method
  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    double? width,
    double? height,
    List<Color>? colorList,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w600,
    double borderRadius = 25,
  }) {
    return Container(
      width: width,
      height: height ?? 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colorList ?? const [ Color(0xFFFD6FFF), Color(0xFF8EC2FB) ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.black.withOpacity(0.1),width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
