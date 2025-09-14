import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/customappbar_agencyscreen.dart';
import 'package:riolive/customwidgets/customdropdownfield.dart';
import 'package:riolive/customwidgets/customtext.dart';
import '../../../../../customwidgets/CustomInputField.dart';
import '../../../../../customwidgets/custom_gradient_button.dart';
import 'package:riolive/customwidgets/custom_container.dart';

class CreateAgencyScreen extends StatelessWidget {
  const CreateAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomContainer(
        width: double.infinity,
        height: double.infinity,
        image: const DecorationImage(
          image: AssetImage("assets/images/bg11.png"),
          fit: BoxFit.cover,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RioliveAppBar(title: 'Create an Agency',),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 45,),

                        // 🔹 Your RioLive ID
                        const CustomText("*Your RioLive Id",
                            fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black,),
                        const SizedBox(height: 6),
                        CustomInputField(hintText: "ID Number",),

                        const SizedBox(height: 16),

                        // 🔹 Verification Code + Get Button Inside Field
                        const CustomText("RioLive Verification Code",
                            fontSize: 16, fontWeight: FontWeight.w400,),
                        const SizedBox(height: 6),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Verification Code",
                            hintStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black45,
                                fontWeight: FontWeight.w400),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300.withOpacity(0.6),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),

                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CustomGradientButton(
                                text: 'get',
                                onPressed: () {},
                                padding: const EdgeInsets.only(bottom: 2),
                                height: 38,
                                width: 70,
                                textColor: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🔹 Country
                        const CustomText("Country",
                            fontSize: 16, fontWeight: FontWeight.w400),
                        const SizedBox(height: 6),
                        const CustomDropdownField(
                          hintText: 'Please enter country',
                          height: 57,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          backgroundColor: Color(0xffDDDDDD),
                        ),

                        const SizedBox(height: 16),

                        // 🔹 Description
                        const CustomText("Description",
                            fontSize: 16, fontWeight: FontWeight.w400),
                        const SizedBox(height: 6),
                        CustomInputField(hintText: "Please Add"),

                        const SizedBox(height: 16),

                        // 🔹 WhatsApp
                        const CustomText("WhatsApp",
                            fontSize: 16, fontWeight: FontWeight.w400),
                        const SizedBox(height: 6),
                        CustomInputField(
                          hintText: "Please fill in WhatsApp with country code",
                          suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                        ),

                        const SizedBox(height: 15),
                        const CustomText(
                          "Experience",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 15),

                        // 🔹 Experience Section (Container -> CustomContainer)
                        CustomContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(12),
                          conColor: Colors.grey.shade200.withOpacity(0.6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(
                                "Add your experience",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                              const SizedBox(height: 12),

                              // Radio Buttons Vertical
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Colors.black,
                                          radioTheme: RadioThemeData(
                                            fillColor: MaterialStateProperty.all(Colors.black),
                                            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                        child: SizedBox(
                                          height: 25,
                                          width: 22,
                                          child: Transform.scale(
                                            scale: 22 / 25,
                                            child: Radio<bool>(
                                              value: true,
                                              groupValue: true,
                                              onChanged: (_) {},
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const CustomText(
                                        "Yes",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor: Colors.black,
                                          radioTheme: RadioThemeData(
                                            fillColor: MaterialStateProperty.all(Colors.black),
                                            visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                        child: SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: Transform.scale(
                                            scale: 22 / 25,
                                            child: Radio<bool>(
                                              value: false,
                                              groupValue: true,
                                              onChanged: (_) {},
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const CustomText(
                                        "No",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Normal TextField (underline)
                              const CustomText("Name of other Platforms:", fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black45,),
                              const SizedBox(height: 6),
                              const TextField(
                                decoration: InputDecoration(
                                  hintText: "Please enter",
                                  hintStyle: TextStyle(fontSize: 16, color: Colors.black45,fontWeight: FontWeight.w400),
                                  border: UnderlineInputBorder(),
                                ),
                              ),

                              const SizedBox(height: 12),
                              const CustomText("Proof of cooperation (optional)", fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black45,),
                              const SizedBox(height: 8),

                              // Proof box (Container -> CustomContainer)
                              CustomContainer(
                                height: 80,
                                width: 100,
                                borderRadius: BorderRadius.circular(5),
                                conColor: const Color(0xffDDDDDD),
                                child: const Icon(Icons.camera_alt, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // 🔹 Apply Gradient Button
                        Center(
                          child: CustomGradientButton(
                            text: "Apply",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            textColor: Colors.black,
                            onPressed: () {},
                            width: 180,
                            height: 52,
                            borderRadius: 30,

                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Warm Tips
                        const CustomText(
                          "Warm Tips:",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontType: AppFont.poppins,
                        ),
                        const SizedBox(height: 8),

                        // 👉 Left padding for tips
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              CustomText(
                                "1. Plz invite 5 valid hosts at least within a month after registration.",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0x80000000),
                                softWrap: true,
                                maxLines: 3,
                              ),
                              SizedBox(height: 8),
                              CustomText(
                                "2. Valid host: Live for over 2 hours daily at least on one day within a week.",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0x80000000),
                                softWrap: true,
                                maxLines: 3,
                              ),
                              SizedBox(height: 10),
                              CustomText(
                                "3. If active valid hosts is less than 5 in a month, platform holds the right to take follow-up action to the agency.",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0x80000000),
                                softWrap: true,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 100,),
            ],
          ),
        ),
      ),
    );
  }
}
