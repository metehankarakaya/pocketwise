import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeLanguageModal {

  static void show(BuildContext context) {
    showModalBottomSheet(
      clipBehavior: Clip.antiAlias,
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              context.setLocale(const Locale("tr"));
              Navigator.pop(context);
            },
            title: Text("🇹🇷 Türkçe"),
          ),
          const Divider(indent: 10, endIndent: 10, height: 0,),
          ListTile(
            onTap: () {
              context.setLocale(const Locale("en", "US"));
              Navigator.pop(context);
            },
            title: Text("🇺🇸 English"),
          ),
          const Divider(indent: 10, endIndent: 10, height: 0,),
          ListTile(
            onTap: () {
              context.setLocale(const Locale("de"));
              Navigator.pop(context);
            },
            title: Text("🇩🇪 Deutsch"),
          ),
          const Divider(indent: 10, endIndent: 10, height: 0,),
          ListTile(
            onTap: () {
              context.setLocale(const Locale("es"));
              Navigator.pop(context);
            },
            title: Text("🇪🇸 Español"),
          ),
        ],
      ),
    );
  }

}
