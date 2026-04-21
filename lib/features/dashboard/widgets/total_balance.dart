import 'package:flutter/material.dart';

class TotalBalance extends StatelessWidget {
  final double balance;
  const TotalBalance({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Text("₺ ${balance.toStringAsFixed(2)}", style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),);
  }
}
