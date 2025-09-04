import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:riolive/customwidgets/custom_gradient_button.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key? key, required this.title, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class CustomDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final Function(String?)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.hint,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0x2D9D9D9D),
      ),
      child: DropdownButton<String>(
        hint: Text(widget.hint),
        value: selectedValue,
        isExpanded: true,
        underline: const SizedBox(),
        items: widget.items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        style: const TextStyle(fontSize: 14, color: Colors.black),
        dropdownColor: const Color(0xFFB6F2E3),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;

  const CustomInputField({
    Key? key,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0x2D9D9D9D),
      ),
      child: TextField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}

class CustomUploadSection extends StatelessWidget {
  const CustomUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: const Color(0x2D9D9D9D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.camera_alt_outlined,
              size: 40,
              color: Color(0xFF4D4D4D),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Upload up to 5 photos, the size of each photo does not exceed 2MB',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }
}

class ContactCustomerServiceScreen extends StatelessWidget {
  const ContactCustomerServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Contact customer service"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB6F2E3), Color(0xFFF2D6F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Problem Type',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              CustomDropdown(
                hint: "Please select the problem type",
                items: ['Recharge', 'Withdraw', 'Report', 'App issue', 'Other'],
                onChanged: (value) {},
              ),
              const Text(
                'Please Describe your issue',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              CustomInputField(
                hint: "Please Describe your issue......",
                maxLines: 5,
              ),
              const Text(
                'Upload photo',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const CustomUploadSection(),
              const SizedBox(height: 16),
              const Text(
                'Phone',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              CustomInputField(
                hint: "Phone",
                keyboardType: TextInputType.phone,
              ),
              const Text(
                'Gmail',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              CustomInputField(
                hint: "Gmail",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              CustomGradientButton(
                  text: "Submit",
                  width: double.infinity,
                  height: 50,
                  onPressed: () {}
              ),
            ],
          ),
        ),
      ),
    );
  }
}
