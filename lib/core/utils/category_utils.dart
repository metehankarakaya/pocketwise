import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

IconData iconForCategory(String category) {
  switch (category) {
    case AppStrings.restaurant: return Icons.restaurant;
    case AppStrings.groceries: return Icons.shopping_cart;
    case AppStrings.transport: return Icons.directions_car;
    case AppStrings.fuel: return Icons.local_gas_station;
    case AppStrings.rent: return Icons.home;
    case AppStrings.bills: return Icons.receipt_long;
    case AppStrings.subscription: return Icons.subscriptions;
    case AppStrings.entertainment: return Icons.movie;
    case AppStrings.clothing: return Icons.checkroom;
    case AppStrings.health: return Icons.local_hospital;
    case AppStrings.education: return Icons.school;
    case AppStrings.technology: return Icons.devices;
    case AppStrings.salary: return Icons.attach_money;
    default: return Icons.category;
  }
}

Color colorForCategory(String category) {
  switch (category) {
    case AppStrings.restaurant: return Colors.orange;
    case AppStrings.groceries: return Colors.blue;
    case AppStrings.transport: return Colors.purple;
    case AppStrings.fuel: return Colors.deepOrange;
    case AppStrings.rent: return Colors.brown;
    case AppStrings.bills: return Colors.red;
    case AppStrings.subscription: return Colors.deepPurple;
    case AppStrings.entertainment: return Colors.pink;
    case AppStrings.clothing: return Colors.amber;
    case AppStrings.health: return Colors.teal;
    case AppStrings.education: return Colors.indigo;
    case AppStrings.technology: return Colors.cyan;
    case AppStrings.salary: return Colors.green;
    default: return Colors.grey;
  }
}
