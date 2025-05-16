import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSelector extends StatelessWidget {
  final Locale currentLocale;
  final ValueChanged<Locale?> onChanged;
  const LanguageSelector(
      {super.key, required this.currentLocale, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: currentLocale,
      icon: const Icon(Icons.language),
      onChanged: onChanged,
      items: [
        DropdownMenuItem(value: Locale('en'), child: Text('EN'.tr())),
        DropdownMenuItem(value: Locale('ru'), child: Text('RU'.tr())),
        DropdownMenuItem(value: Locale('kk'), child: Text('KK'.tr())),
      ],
    );
  }
}
