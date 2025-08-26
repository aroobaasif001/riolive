import 'package:flutter/material.dart';
import 'custom_container.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final BorderRadius? borderRadius;

  const CustomProgressIndicator({
    super.key,
    required this.value,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.height = 6,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: height,
      conColor: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              CustomContainer(
                width: constraints.maxWidth * value.clamp(0.0, 1.0),
                height: height,
                conColor: progressColor,
                borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
              ),
            ],
          );
        },
      ),
    );
  }
}
