import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomContainer(
          width: double.infinity,
          height: double.infinity,
          image: const DecorationImage(
            image: AssetImage("assets/images/Livebroadcastdatabg.jpg"),
            fit: BoxFit.cover, // full-screen cover
            alignment: Alignment.topCenter,
          ),
          child: Column(
            children: const [
              // yahan apna wallet UI add karein
            ],
          ),
        ),
      ),
    );
  }
}
