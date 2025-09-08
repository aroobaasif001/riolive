import 'package:flutter/material.dart';

import 'customtext.dart';
import 'gradient_pill.dart';

class JoinButton extends StatelessWidget {
  const JoinButton();

  @override
  Widget build(BuildContext context) {
    return GradientPill(
      height: 30,
      padding: EdgeInsets.zero,
      gradient: const LinearGradient(
        colors: [Color(0xff3b1f68), Color(0xff1e113e)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(width: 14),
          CustomText(
            'Alexander',
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.only(top: 1.0, bottom: 1),
            child: VerticalDivider(color: Colors.white, thickness: 1, width: 1),
          ),
          SizedBox(width: 10),
          CustomText(
            'join               ',
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(width: 14),
        ],
      ),
    );
  }
}
