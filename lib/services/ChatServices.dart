import 'package:chat2025/constants/constants.dart';
import 'package:chat2025/widgets/DropDown.dart';
import 'package:chat2025/widgets/TextWidget.dart';
import 'package:flutter/material.dart';

class ChatServices {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(child: TextWidget(label: "Chosen Model:", fontSize: 16)),
              Flexible(flex: 2, child: DropDown()),
            ],
          ),
        );
      },
    );
  }
}
