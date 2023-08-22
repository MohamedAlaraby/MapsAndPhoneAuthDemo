import 'package:flutter/material.dart';

class CustomProgrssIndicator extends StatelessWidget {
  const CustomProgrssIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
      ),
    );
  }
}
