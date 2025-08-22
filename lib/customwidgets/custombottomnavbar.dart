import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final ValueChanged<int> onItemSelected;
  final int currentIndex;

  CustomBottomNavBar({
    Key? key,
    required this.onItemSelected,
    required this.currentIndex,
  }) : super(key: key);

  final List<_NavBarItem> _items = const [
    _NavBarItem(
      imageIcon: "assets/icons/CartoonParrotbottom1.png",
      label: '',
    ),
    _NavBarItem(
      imageIcon: "assets/icons/bottom2.png",
      label: '',
    ),
    _NavBarItem(
      imageIcon: "assets/icons/bottom3.png",
      label: '',
    ),
    _NavBarItem(
      imageIcon: "assets/icons/bottom4.png",
      label: '',
    ),
    _NavBarItem(
      imageIcon: "assets/icons/bottom5.png",
      label: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: Colors.transparent,
      color: Color(0xffE9E8E8),
      buttonBackgroundColor: Color(0xffCBEDC5),
      height: 60,
      items: _items.map((item) {
        final isSelected = _items.indexOf(item) == currentIndex;

        return Padding(
          padding: EdgeInsets.only(top: isSelected ? 0 : 27), // Keep as is for selected state effect
          child: SizedBox(
            width: 50,
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  item.imageIcon,
                  height: 26, // Adjusted to a default size (use dynamic size if needed)
                  width: 26,  // Adjusted to a default size
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 20,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.green, // Customize this as needed
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onTap: onItemSelected,
    );
  }
}

class _NavBarItem {
  final String imageIcon;
  final String label;

  const _NavBarItem({
    required this.imageIcon,
    required this.label,
  });
}
