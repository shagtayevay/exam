import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ThemeToggle extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;
  const ThemeToggle(
      {super.key, required this.isDarkMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('dark_theme'.tr()),
      value: isDarkMode,
      onChanged: onChanged,
    );
  }
}
