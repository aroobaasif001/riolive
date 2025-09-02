import 'package:flutter/material.dart';

import 'customtextformfield.dart';

class MessageField extends StatelessWidget {
  const MessageField();

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      hintText: 'Say Hi…',
      prefix: const SizedBox.shrink(),
      suffix: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: IconButton(
          icon: const Icon(Icons.emoji_emotions_outlined),
          onPressed: () {},
          color: Colors.black54,
        ),
      ),
      height: 50,
      width: double.infinity,
      hintTextColor: Colors.black45,
      showDivider: false,
      padding: const EdgeInsets.symmetric(horizontal: 18),
    );
  }
}
