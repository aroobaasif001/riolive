import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/screens/homescreenbottomnaviagtionbar/call_screen/live_Screen/live_screen.dart';

class CustomNavBar extends StatefulWidget {
  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String selectedItem = 'Match'; // Default selected item is 'Match'

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0.0, end: -20.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Trigger the animation for the default selected item
    _controller.forward(from: 0.0);
  }

  void _onItemTap(String item) {
    setState(() {
      selectedItem = item;
    });
    _controller.forward(from: 0.0); // Restart the animation when a new item is tapped
  }

  @override
  Widget build(BuildContext context) {
    // ---- MediaQuery values ----
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    final double fontLarge = (w * 0.055).clamp(18.0, 22.0).toDouble();
    final double fontSmall = (w * 0.045).clamp(16.0, 18.0).toDouble();
    final double iconSize = (w * 0.05).clamp(18.0, 24.0).toDouble();
    final double containerPadding = (w * 0.025).clamp(6.0, 12.0).toDouble();
    // ---------------------------

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025),
      child: Container(
        color: Colors.transparent, // Background color for the navbar
        padding: EdgeInsets.all(containerPadding),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _onItemTap('Match'),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      selectedItem == 'Match' ? 0.30 : 0.0,
                      selectedItem == 'Match' ? _animation.value : 0,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.025),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            'Match',
                            style: TextStyle(
                              fontSize: selectedItem == 'Match' ? fontLarge : fontSmall,
                              fontWeight: selectedItem == 'Match' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (selectedItem == 'Match')
                            Positioned(
                              top: -12,
                              right: -15,
                              child: Icon(Icons.star, color: Colors.black, size: iconSize),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => {
                    _onItemTap('Live'),
                  },
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          selectedItem == 'Live' ? 0.10 : 0.0,
                          selectedItem == 'Live' ? _animation.value : 0,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.025),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                'Live',
                                style: TextStyle(
                                  fontSize: selectedItem == 'Live' ? fontLarge : fontSmall,
                                  fontWeight: selectedItem == 'Live' ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (selectedItem == 'Live')
                                Positioned(
                                  top: -12,
                                  right: -15,
                                  child: Icon(Icons.star, color: Colors.black, size: iconSize),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => _onItemTap('Party'),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          selectedItem == 'Party' ? 0.10 : 0.0,
                          selectedItem == 'Party' ? _animation.value : 0,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.025),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                'Party',
                                style: TextStyle(
                                  fontSize: selectedItem == 'Party' ? fontLarge : fontSmall,
                                  fontWeight: selectedItem == 'Party' ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (selectedItem == 'Party')
                                Positioned(
                                  top: -12,
                                  right: -15,
                                  child: Icon(Icons.star, color: Colors.black, size: iconSize),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                // Add your search action here
              },
              child: Row(children: [
                Container(
                  height: h * 0.045,
                  width: w * 0.09,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/icons/searchiconcolor.png'),
                      height: h * 0.025,
                      width: h * 0.025,
                    ),
                  ),
                ),
                SizedBox(width: w * 0.01),
                Padding(
                  padding: EdgeInsets.only(bottom: h * 0.025),
                  child: Container(
                    height: h * 0.05,
                    width: w * 0.18,
                    child: Center(
                      child: Image(image: AssetImage('assets/images/textlogo.png')),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
