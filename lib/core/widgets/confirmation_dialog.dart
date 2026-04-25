import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pocketwise/core/constants/app_strings.dart';

class ConfirmationDialog {
  static void show(BuildContext context, {required String title, required String content, required VoidCallback onPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel.tr()),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(AppStrings.delete.tr()),
          )
        ],
      ),
    );
  }
}
