
import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final String selectedItem;
  final ValueChanged<String> onItemTap;

  const CustomNavBar({
    super.key,
    required this.selectedItem,
    required this.onItemTap,
  });

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward(from: 0.0);
  }

  void _onItemTap(String item) {
    widget.onItemTap(item);
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fontLarge = (w * 0.055).clamp(18.0, 22.0).toDouble();
    final fontSmall = (w * 0.045).clamp(16.0, 18.0).toDouble();

    return Container(
      color: Colors.transparent, // ✅ No background
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Add space evenly between items
        children: [
          _buildNavItem("Match", fontLarge, fontSmall),
          _buildNavItem("Live", fontLarge, fontSmall),
          _buildNavItem("Party", fontLarge, fontSmall),
          const Spacer(),
          Row(children: [
            Container(
              height: 32,
              width: 36,
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(10),
                color: Colors.white24
              ),
              child: Center(child: Image(image: AssetImage('assets/icons/searchiconcolor.png'),height: 22,width: 22,),),
            ),
            Image(image: AssetImage('assets/images/textlogo.png'),height: 40,width: 70,)
          ],),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, double fontLarge, double fontSmall) {
    return GestureDetector(
      onTap: () => _onItemTap(label),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              0.0,
              widget.selectedItem == label ? _animation.value : 0,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Increased padding here
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: widget.selectedItem == label ? fontLarge : fontSmall,
                      fontWeight: widget.selectedItem == label
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  if (widget.selectedItem == label)
                    const Positioned(
                      top: -12,
                      right: -15,
                      child: Icon(Icons.star, size: 18, color: Colors.black),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}