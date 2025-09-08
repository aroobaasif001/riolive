import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riolive/customwidgets/settingRow.dart';

import '../utile/const.dart';
import 'custom_container.dart';
import 'gradientSwitch.dart';

void showEffectMsgSettingSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return SafeArea(
        child: DraggableScrollableSheet(
          initialChildSize: 0.30,
          minChildSize: 0.25,
          maxChildSize: 0.85,
          builder: (_, controller) {
            return EffectMsgSheet(controller: controller);
          },
        ),
      );
    },
  );
}

class EffectMsgSheet extends StatefulWidget {
  const EffectMsgSheet({required this.controller});
  final ScrollController controller;

  @override
  State<EffectMsgSheet> createState() => EffectMsgSheetState();
}

class EffectMsgSheetState extends State<EffectMsgSheet> {
  bool luckyGift = true;
  bool entryCar = false;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: sheetBg,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // handle
          Center(
            child: Container(
              width: 54,
              height: 5,
              decoration: BoxDecoration(
                color: handleColor.withOpacity(.9),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // header with back arrow + centered title
          Row(
            children: [
              InkWell(
                onTap: () => Get.back(), // close settings sheet
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Effect&Msg setting',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24), // balance for centering
            ],
          ),
          const SizedBox(height: 8),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              'Too many effect/msgs, click switch below to set them flexibly',
              style: TextStyle(
                color: mutedText,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // options
          SettingRow(
            title: 'Lucky Gift',
            onInfoTap: () {},
            trailing: GradientSwitch(
              value: luckyGift,
              onChanged: (v) => setState(() => luckyGift = v),
            ),
          ),
          const SizedBox(height: 12),
          SettingRow(
            title: 'Entry&car',
            onInfoTap: () {},
            trailing: GradientSwitch(
              value: entryCar,
              onChanged: (v) => setState(() => entryCar = v),
            ),
          ),
        ],
      ),
    );
  }
}
