import 'package:flutter/material.dart';

class EmptyHolder extends StatelessWidget {
  final IconData iconData;
  final String title;
  const EmptyHolder({super.key, required this.iconData, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 120),
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(iconData, size: 64,),
            SizedBox(height: 10,),
            Text(title),
          ],
        ),
      ),
    );
  }
}
