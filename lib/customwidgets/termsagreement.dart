import 'package:flutter/material.dart';

class TermsAgreement extends StatefulWidget {
  final bool showCheckbox;
  const TermsAgreement({super.key, this.showCheckbox = true});

  @override
  State<TermsAgreement> createState() => _TermsAgreementState();
}

class _TermsAgreementState extends State<TermsAgreement> {
  bool isChecked = true; // default checked

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // 👈 center horizontally
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // 👈 center Row content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.showCheckbox)
              Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  value: isChecked,
                  activeColor: Colors.purple,
                  shape: const CircleBorder(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  onChanged: (val) {
                    setState(() {
                      isChecked = val ?? false;
                    });
                  },
                ),
              ),
            const SizedBox(width: 4), // thoda sa gap (optional)
            const Text(
              "By using Riolive, you agree to the",
              style: TextStyle(
                color: Color(0xffFFFFFF),
                fontSize: 14,
              ),
            ),
          ],
        ),

        const SizedBox(height: 2),

        // 👇 yeh bhi center aligned hoga
        RichText(
          textAlign: TextAlign.center, // 👈 center align text
          text: const TextSpan(
            style: TextStyle(
              color: Color(0xffFFFFFF),
              fontSize: 14,
            ),
            children: [
              TextSpan(
                text: "Riolive Live Terms Of Services ",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: "And "),
              TextSpan(
                text: "Privacy Policy",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
