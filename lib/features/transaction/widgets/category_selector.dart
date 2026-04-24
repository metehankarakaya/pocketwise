import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  const CategorySelector({super.key, required this.selectedCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: categories.map((c) {
        return ChoiceChip(
          showCheckmark: false,
          selected: selectedCategory == c,
          selectedColor: colorScheme.primaryContainer,
          onSelected: (val) => onCategorySelected(val ? c : null),
          label: Text(c.tr()),
          labelStyle: TextStyle(
            color: selectedCategory == c ? colorScheme.onPrimaryContainer : colorScheme.onSurface
          ),
        );
      }).toList(),
    );
  }
}
