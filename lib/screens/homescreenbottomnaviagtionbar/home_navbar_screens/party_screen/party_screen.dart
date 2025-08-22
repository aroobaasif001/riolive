import 'package:flutter/material.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.pink.shade200,
      Colors.green.shade200,
      Colors.orange.shade200,
      Colors.purple.shade200,
      Colors.blue.shade200,
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 70),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors[index],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/user.png", // replace with user image
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Rajesh Kumar",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Welcome Everyone",
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
              const Spacer(),
              Row(
                children: const [
                  Icon(Icons.card_giftcard, size: 18, color: Colors.green),
                  SizedBox(width: 4),
                  Text("10",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
