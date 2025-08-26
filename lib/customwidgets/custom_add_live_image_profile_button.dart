import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';

class CustomAddLiveImageProfileButton extends StatefulWidget {
  final ImageProvider<Object> image;
  final void Function()? onImagePressed;
  final void Function()? onAddButtonPressed;
  final Duration checkmarkDuration;

  const CustomAddLiveImageProfileButton({
    super.key,
    required this.image,
    this.onImagePressed,
    this.onAddButtonPressed,
    this.checkmarkDuration = const Duration(seconds: 1),
  });

  @override
  State<CustomAddLiveImageProfileButton> createState() => _CustomAddLiveImageProfileButtonState();
}

class _CustomAddLiveImageProfileButtonState extends State<CustomAddLiveImageProfileButton>
    with SingleTickerProviderStateMixin {
  bool _showCheckmark = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleImageTap() {
    widget.onImagePressed?.call();
  }

  void _handleAddButtonTap() {
    if (_showCheckmark) return;

    setState(() {
      _showCheckmark = true;
    });

    // Start scale animation
    _animationController.forward();

    Future.delayed(widget.checkmarkDuration, () {
      if (mounted) {
        setState(() {
          _showCheckmark = false;
        });
        // Reset animation
        _animationController.reset();
      }
    });

    widget.onAddButtonPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 60,
      width: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Profile Image with separate tap handler
          GestureDetector(
            onTap: _handleImageTap,
            child: CustomContainer(
              height: 50,
              width: 50,
              image: DecorationImage(image: widget.image, fit: BoxFit.cover),
              shape: BoxShape.circle,
            ),
          ),

          // Add Icon with separate tap handler (only visible when checkmark is not showing)
          if (!_showCheckmark)
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: _handleAddButtonTap,
                child: CustomContainer(
                  height: 20,
                  width: 20,
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/add_icon.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

          // Checkmark Icon with animation (only visible when _showCheckmark is true)
          if (_showCheckmark)
            Align(
              alignment: Alignment.bottomCenter,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: CustomContainer(
                  height: 14,
                  width: 14,
                  conColor: Colors.green,
                  shape: BoxShape.circle,
                  child: const Icon(Icons.check, color: Colors.white, size: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
