import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DiamondTradingController extends GetxController {
  // Top Up Screen Variables
  final RxString selectedTopUpAmount = ''.obs;
  final RxString selectedPaymentMethod = 'Select Payment Method'.obs;
  final RxBool isTopUpLoading = false.obs;
  final TextEditingController customAmountController = TextEditingController();

  // Predefined top-up amounts
  final List<String> topUpAmounts = ['100', '500', '1000', '2000', '5000'];
  
  // Payment methods
  final List<String> paymentMethods = [
    'Credit Card',
    'PayPal', 
    'Bank Transfer',
    'Mobile Wallet'
  ];

  // Coin Seller Screen Variables  
  final TextEditingController sellerNameController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final RxString selectedCountry = 'Please enter Coin selling area'.obs;
  final RxString selectedCountryCode = '+92'.obs;
  final RxBool isCoinSellerLoading = false.obs;
  
  // ID Card Images
  final RxString idCardFrontPath = ''.obs;
  final RxString idCardBackPath = ''.obs;

  // Countries list
  final List<Map<String, String>> countries = [
    {'name': 'Pakistan', 'code': '+92'},
    {'name': 'United States', 'code': '+1'},
    {'name': 'United Kingdom', 'code': '+44'},
    {'name': 'India', 'code': '+91'},
    {'name': 'China', 'code': '+86'},
    {'name': 'Germany', 'code': '+49'},
    {'name': 'France', 'code': '+33'},
    {'name': 'Italy', 'code': '+39'},
    {'name': 'Spain', 'code': '+34'},
    {'name': 'Canada', 'code': '+1'},
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    customAmountController.dispose();
    sellerNameController.dispose(); 
    verificationCodeController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }

  // Top Up Methods
  void selectTopUpAmount(String amount) {
    selectedTopUpAmount.value = amount;
    customAmountController.text = amount;
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> processTopUp() async {
    if (selectedTopUpAmount.value.isEmpty || selectedPaymentMethod.value == 'Select Payment Method') {
      Get.snackbar(
        'Error', 
        'Please select amount and payment method',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isTopUpLoading.value = true;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual API call here
      print('Processing top-up: Amount: ${selectedTopUpAmount.value}, Method: ${selectedPaymentMethod.value}');
      
      Get.snackbar(
        'Success',
        'Top-up request submitted successfully!',
        backgroundColor: Colors.green.withOpacity(0.8), 
        colorText: Colors.white,
      );
      
      // Reset form
      resetTopUpForm();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process top-up. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isTopUpLoading.value = false;
    }
  }

  void resetTopUpForm() {
    selectedTopUpAmount.value = '';
    selectedPaymentMethod.value = 'Select Payment Method';
    customAmountController.clear();
  }

  // Coin Seller Methods
  void selectCountry(String country, String code) {
    selectedCountry.value = country;
    selectedCountryCode.value = code;
  }

  Future<void> getVerificationCode() async {
    if (phoneNumberController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter phone number first',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Implement actual API call here
      print('Sending verification code to: ${selectedCountryCode.value}${phoneNumberController.text}');
      
      Get.snackbar(
        'Success',
        'Verification code sent successfully!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Failed to send verification code. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void setIdCardImage(String imagePath, bool isFront) {
    if (isFront) {
      idCardFrontPath.value = imagePath;
    } else {
      idCardBackPath.value = imagePath;
    }
  }

  Future<void> applyCoinSeller() async {
    if (!validateCoinSellerForm()) return;

    isCoinSellerLoading.value = true;
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual API call here
      print('Applying for coin seller:');
      print('Name: ${sellerNameController.text}');
      print('Phone: ${selectedCountryCode.value}${phoneNumberController.text}'); 
      print('Country: ${selectedCountry.value}');
      print('Verification Code: ${verificationCodeController.text}');
      print('ID Front: ${idCardFrontPath.value}');
      print('ID Back: ${idCardBackPath.value}');
      
      Get.snackbar(
        'Success',
        'Coin seller application submitted successfully!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      
      // Reset form
      resetCoinSellerForm();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit application. Please try again.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isCoinSellerLoading.value = false;
    }
  }

  bool validateCoinSellerForm() {
    if (sellerNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name',
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return false;
    }

    if (verificationCodeController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter verification code',
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return false;
    }

    if (selectedCountry.value == 'Please enter Coin selling area') {
      Get.snackbar('Error', 'Please select country',
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return false;
    }

    if (phoneNumberController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter phone number',
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return false;
    }

    if (idCardFrontPath.value.isEmpty || idCardBackPath.value.isEmpty) {
      Get.snackbar('Error', 'Please upload both ID card images',
          backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      return false;
    }

    return true;
  }

  void resetCoinSellerForm() {
    sellerNameController.clear();
    verificationCodeController.clear();
    phoneNumberController.clear();
    selectedCountry.value = 'Please enter Coin selling area';
    selectedCountryCode.value = '+92';
    idCardFrontPath.value = '';
    idCardBackPath.value = '';
  }
}
