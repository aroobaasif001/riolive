import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../customwidgets/custom_gradient_button.dart';
import '../../../../../customwidgets/custombutton.dart';
import '../../../../../customwidgets/customtext.dart';
import '../../../../../customwidgets/custom_container.dart';
import '../../../../../customwidgets/CustomInputField.dart';

class ContactCustomerServiceScreen extends StatefulWidget {
  const ContactCustomerServiceScreen({super.key});

  @override
  State<ContactCustomerServiceScreen> createState() =>
      _ContactCustomerServiceScreenState();
}

class _ContactCustomerServiceScreenState
    extends State<ContactCustomerServiceScreen> {
  final TextEditingController _issueController = TextEditingController();
  int _charCount = 0;

  // Dropdown values
  String? _selectedProblemType;
  final List<String> _problemTypes = [
    'Recharge',
    'Withdraw',
    'Report',
    'App Issue',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _issueController.addListener(() {
      setState(() {
        _charCount = _issueController.text.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg11.png"), // 🔽 background image
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔽 AppBar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  const CustomText(
                    "Contact customer service",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Problem Type
              const CustomText(
                "Problem Type",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              const SizedBox(height: 8),

              // Dropdown for Problem Type
              DropdownButtonFormField<String>(
                value: _selectedProblemType,
                hint: const CustomText("Please select the problem type"),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300.withOpacity(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedProblemType = newValue;
                  });
                },
                items: _problemTypes.map((String problem) {
                  return DropdownMenuItem<String>(
                    value: problem,
                    child: CustomText(problem), // Replaced Text with CustomText
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Issue
              const CustomText(
                "Please Describe your issue",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              const SizedBox(height: 8),

              // Issue TextField
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _issueController,
                      maxLines: 5,
                      maxLength: 250,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Please Describe your issue....",
                        hintStyle:
                        TextStyle(fontSize: 12, color: Color(0xff000000)),
                        counterText: "", // remove default counter
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        "$_charCount/250",
                        fontSize: 12,
                        color: Color(0xff000000),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Upload photo
              const CustomText(
                "Upload photo",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              const SizedBox(height: 8),
              CustomContainer(
                height: 100,
                width: 100,
                borderRadius: BorderRadius.circular(12),
                conColor: Color(0x2ea1a1a1),
                child: const Center(
                  child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              const CustomText(
                "Upload up to 5 photos, the size of each photo does not exceed 2MB",
                fontSize: 12,
                color: Colors.grey,
                softWrap: true,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Phone
              const CustomText(
                "Phone",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              const SizedBox(height: 8),
               CustomInputField(
                hintText: "Phone",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Gmail
              const CustomText(
                "Gmail",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              const SizedBox(height: 8),
               CustomInputField(
                hintText: "Gmail",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),

              // Submit button
              CustomGradientButton(
                text: "Submit",
                onPressed: () {
                  // Submit logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
