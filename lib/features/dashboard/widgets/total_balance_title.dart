import 'package:flutter/material.dart';

class TotalBalanceTitle extends StatelessWidget {
  const TotalBalanceTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Toplam Bakiye",
      ),
    );
  }
}
