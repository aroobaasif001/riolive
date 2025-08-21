import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        color: Colors.transparent, // Background color for the navbar
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _onItemTap('Match'),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      selectedItem == 'Match' ? 0.30 : 0.0, // No rightward movement for Match
                      selectedItem == 'Match' ? _animation.value : 0, // Move upwards
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10), // Reduced horizontal padding
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            'Match',
                            style: TextStyle(
                              fontSize: selectedItem == 'Match' ? 22 : 18,
                              fontWeight: selectedItem == 'Match' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (selectedItem == 'Match')
                            Positioned(
                              top: -12,
                              right: -15,
                              child: Icon(Icons.star, color: Colors.black, size: 20),
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
                  onTap: () => _onItemTap('Live'),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          selectedItem == 'Live' ? 0.10 : 0.0, // Move rightwards for 'Live'
                          selectedItem == 'Live' ? _animation.value : 0, // Move upwards
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10), // Reduced horizontal padding
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                'Live',
                                style: TextStyle(
                                  fontSize: selectedItem == 'Live' ? 22 : 18,
                                  fontWeight: selectedItem == 'Live' ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (selectedItem == 'Live')
                                Positioned(
                                  top: -12,
                                  right: -15,
                                  child: Icon(Icons.star, color: Colors.black, size: 20),
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
                          selectedItem == 'Party' ? 0.10 : 0.0, // Move rightwards for 'Party'
                          selectedItem == 'Party' ? _animation.value : 0, // Move upwards
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10), // Reduced horizontal padding
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Text(
                                'Party',
                                style: TextStyle(
                                  fontSize: selectedItem == 'Party' ? 22 : 18,
                                  fontWeight: selectedItem == 'Party' ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (selectedItem == 'Party')
                                Positioned(
                                  top: -12,
                                  right: -15,
                                  child: Icon(Icons.star, color: Colors.black, size: 20),
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
              child: Icon(Icons.search, size: 30),
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
