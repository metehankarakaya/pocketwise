import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketwise/core/constants/app_strings.dart';
import 'package:pocketwise/core/providers/user_provider.dart';

class ChangeUsernameDialog {

  static void show(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.changeUsername.tr()),
        content: TextField(
          maxLength: 50,
          controller: controller,
          decoration: InputDecoration(
            counterText: "",
            hintText: AppStrings.enterUsername.tr(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppStrings.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(userProvider.notifier).setName(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: Text(AppStrings.save.tr()),
          ),
        ],
      )
    );
  }

}
