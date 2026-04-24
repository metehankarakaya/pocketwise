import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

IconData iconForCategory(String category) {
  switch (category) {
    case AppStrings.food: return Icons.fastfood;
    case AppStrings.groceries: return Icons.shopping_cart;
    case AppStrings.transport: return Icons.directions_car;
    case AppStrings.bills: return Icons.receipt_long;
    case AppStrings.entertainment: return Icons.movie;
    case AppStrings.health: return Icons.local_hospital;
    case AppStrings.education: return Icons.school;
    case AppStrings.clothing: return Icons.checkroom;
    case AppStrings.technology: return Icons.devices;
    case AppStrings.subscription: return Icons.subscriptions;
    default: return Icons.category;
  }
}

Color colorForCategory(String category) {
  switch (category) {
    case AppStrings.food: return Colors.orange;
    case AppStrings.groceries: return Colors.blue;
    case AppStrings.transport: return Colors.purple;
    case AppStrings.bills: return Colors.red;
    case AppStrings.entertainment: return Colors.pink;
    case AppStrings.health: return Colors.teal;
    case AppStrings.education: return Colors.indigo;
    case AppStrings.clothing: return Colors.brown;
    case AppStrings.technology: return Colors.cyan;
    case AppStrings.subscription: return Colors.deepPurple;
    default: return Colors.grey;
  }
}