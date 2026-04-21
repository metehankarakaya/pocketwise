import 'package:flutter/material.dart';

class TransactionTypeButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const TransactionTypeButton({super.key, required this.isSelected, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.shade500,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold
            )
          ),
        ),
      ),
    );
  }
}
